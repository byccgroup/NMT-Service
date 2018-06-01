#include <cstdlib>
#include <iostream>
#include <string>
#include <boost/timer/timer.hpp>
#include <boost/thread/tss.hpp>

#include "common/god.h"
#include "common/logging.h"
#include "common/search.h"
#include "common/threadpool.h"
#include "common/printer.h"
#include "common/sentence.h"
#include "common/exception.h"
#include "common/redis.h"

#include "czmq.h"
#define WORKER_READY "READY"

int id=0;

History TranslationTask(const std::string& in, size_t taskCounter) {
#ifdef __APPLE__
  static boost::thread_specific_ptr<Search> s_search;
  Search *search = s_search.get();

  if(search == NULL) {
    //LOG(info) << "Created Search for thread " << std::this_thread::get_id();
    search = new Search(taskCounter);
    s_search.reset(search);
  }
#else
  thread_local std::unique_ptr<Search> search;
  if(!search) {
    //LOG(info) << "Created Search for thread " << std::this_thread::get_id();
    search.reset(new Search(taskCounter));
  }
#endif

  return search->Decode(Sentence(taskCounter, in));
}

int main(int argc, char* argv[]) {
  God::Init(argc, argv);
  std::setvbuf(stdout, NULL, _IONBF, 0);
  std::setvbuf(stdin, NULL, _IONBF, 0);
  boost::timer::cpu_timer timer;

  std::string in;
  std::size_t taskCounter = 0;

  size_t cpuThreads = God::Get<size_t>("cpu-threads");
  LOG(info) << "Setting CPU thread count to " << cpuThreads;

  size_t totalThreads = cpuThreads;
#ifdef CUDA
  size_t gpuThreads = God::Get<size_t>("gpu-threads");
  auto devices = God::Get<std::vector<size_t>>("devices");
  LOG(info) << "Setting GPU thread count to " << gpuThreads;
  totalThreads += gpuThreads * devices.size();
#endif

  LOG(info) << "Total number of threads: " << totalThreads;
  UTIL_THROW_IF2(totalThreads == 0, "Total number of threads is 0");

  if (God::Get<bool>("wipo")) {
    LOG(info) << "Reading input1";
    while (std::getline(God::GetInputStream(), in)) {
      History result = TranslationTask(in, taskCounter);
      Printer(result, taskCounter++, std::cout);
    }
  } else {
    ThreadPool pool(totalThreads);
    LOG(info) << "Reading input2";
    //connect redis
    //------------------worker-----------------------
	zctx_t *ctx = zctx_new();
	void *worker = zsocket_new(ctx, ZMQ_REQ);
	zsocket_connect(worker, "tcp://localhost:5673"); // backend
	zframe_t *frame = zframe_new(WORKER_READY, strlen(WORKER_READY));
	zframe_send(&frame, worker, 0);

    Redis *r = new Redis();
    if(!r->connect("192.168.2.216", 6379)){
        LOG(info) << "connect error !";
        return 0;
    }
    while(true){
        printf("begin\n");
        zmsg_t *msg = zmsg_recv(worker);
        char * buff = zframe_strdup(zmsg_last(msg));
        printf("Worker%d:%s\n", id, buff);

        int len = r->llen(buff);

        std::string tem = buff;
        std::string name = tem + "r";
        std::size_t taskCounter1 = 0;
        //-------------------------------
        std::vector<std::future<History>> results;
        for(int i=0; i<len; i++){
            in = r->rpop(buff);
            if(in==""){
                continue ;
            }else{
                results.emplace_back(pool.enqueue(
                    [=]{ return TranslationTask(in, taskCounter1);
                    }
                ));

            }
        }
        for (auto&& result : results){
            std::string best = Join(God::Postprocess(God::GetTargetVocab()(result.get().Top().first)));
            r->lpush(name, best);
        }

        size_t slen = name.size();
        std::cout<<"return:"<<name<<std::endl;

		zframe_reset(zmsg_last(msg), name.c_str(), slen);
		zmsg_send(&msg, worker);
    }
    delete r;
    zctx_destroy(&ctx);
  }
  LOG(info) << "Total time: " << timer.format();
  God::CleanUp();

  return 0;
}
