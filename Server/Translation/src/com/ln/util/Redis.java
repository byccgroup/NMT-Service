package com.ln.util;

import redis.clients.jedis.Jedis;

public class Redis {
	
	public String SetList(String name, String s){
		try{
			@SuppressWarnings("resource")
			Jedis jedis = new Jedis("192.168.2.216");
			if(jedis.exists(name))
				jedis.del(name);
			String[]list = s.split("\n");
			String lp = null;
			for(int i=0; i<list.length; i++){
				lp = list[i].replace("\r", "");
				if(!"".equals(lp))
					jedis.lpush(name, lp);
			}
			jedis.disconnect();
		}catch(Exception e){
			e.printStackTrace();			
			return null;
		}
		return name;
	}
	
	public String GetList(String name){
		@SuppressWarnings("resource")
		Jedis jedis = new Jedis("192.168.2.216");
		StringBuffer strbuf = new StringBuffer();
		Long len = jedis.llen(name);
		if(len>0){
			for(int i=0; i<len; i++){
				strbuf.append(jedis.rpop(name)+"\n");
			}
			return strbuf.toString();
		}
		jedis.disconnect();
		return null;
	}
}
