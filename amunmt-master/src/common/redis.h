#ifndef _REDIS_H_
#define _REDIS_H_

#include <iostream>
#include <string.h>
#include <string>
#include <stdio.h>

#include "hiredis.h"

class Redis{
    public:
        Redis(){}
        ~Redis(){
            this->_connect = NULL;
            this->_reply = NULL;
        }

        bool connect(std::string host, int port){
            this->_connect = redisConnect(host.c_str(), port);
            if(this->_connect != NULL && this->_connect->err){
                printf("connect error: %s\n", this->_connect->errstr);
                return 0;
            }
            return 1;
        }

        std::string get(std::string key){
            this->_reply = (redisReply*)redisCommand(this->_connect, "GET %s", key.c_str());
            std::string str = this->_reply->str;
            freeReplyObject(this->_reply);
            return str;
        }

        void set(std::string key, std::string value){
            redisCommand(this->_connect, "SET %s %s", key.c_str(), value.c_str());
        }

        void lpush(std::string key, std::string value){
            this->_reply = (redisReply*)redisCommand(this->_connect, "LPUSH %s %s", key.c_str(), value.c_str());
	    freeReplyObject(this->_reply);
        }

        std::string rpop(std::string key){
            this->_reply = (redisReply*)redisCommand(this->_connect, "RPOP %s", key.c_str());
            std::string str = this->_reply->str;
            freeReplyObject(this->_reply);
            return str;
        }

        long long llen(std::string key){
            this->_reply = (redisReply*)redisCommand(this->_connect, "LLEN %s", key.c_str());
            long long len = this->_reply->integer;
            freeReplyObject(this->_reply);
            return len;
        }

        bool exists(std::string key){
            this->_reply = (redisReply*)redisCommand(this->_connect, "EXISTS %s", key.c_str());
            bool flag = (bool)this->_reply->integer;
            freeReplyObject(this->_reply);
            return flag;
        }

    private:
        redisContext* _connect;
        redisReply* _reply;
};

#endif //_REDIS_H_
