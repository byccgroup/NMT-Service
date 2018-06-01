package com.ln.core;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.zeromq.ZContext;
import org.zeromq.ZMQ;
import org.zeromq.ZMQ.Socket;

import com.ln.server.ZHelper;
import com.ln.util.Redis;
import com.opensymphony.xwork2.ActionSupport;

public class CoreAction extends ActionSupport implements ServletRequestAware{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4263855423002428053L;
	private static Logger log = Logger.getLogger(CoreAction.class.getName());
	private String inputtext;
	private String result;
	private Redis redis = new Redis();
	protected HttpServletRequest request;
	
	public String getInputtext() {
		return inputtext;
	}
	
	public void setInputtext(String inputtext) {
		this.inputtext = inputtext;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public void setServletRequest(HttpServletRequest request) {
		// TODO Auto-generated method stub
		this.request = request;
	}
	
	public String getIpAddr(HttpServletRequest request) {  
	       String ip = request.getHeader("x-forwarded-for");  
	       if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	           ip = request.getHeader("Proxy-Client-IP");  
	       }  
	       if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	           ip = request.getHeader("WL-Proxy-Client-IP");  
	       }  
	       if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	           ip = request.getRemoteAddr();  
	       }  
	       return ip;  
	}  

    public String Connection(String listname) {  
    	String ret = null;
        ret = Createclient(listname);         
        return ret;  
    }
    
	@SuppressWarnings({ "deprecation", "resource" })
	public static String Createclient(String listname){ 
		String reply = new String();
		ZContext context = new ZContext();
		log.info("create client");
		try{
			Socket client = context.createSocket(ZMQ.REQ);
			ZHelper.setId(client);
			log.info("begin connect");
			client.connect("tcp://192.168.2.216:5672");
			log.info("already connect");
			client.send(listname);
			reply = client.recvStr();
			context.destroy();
		}catch(Exception e){
			log.info(e.toString());
		}
		return reply;
	}

	public String Core(){
		
		if("".equals(inputtext))
			return "empty";
		String inputname = getIpAddr(request)+System.currentTimeMillis();
		String name = redis.SetList(inputname, inputtext);
		
		log.info("name:"+name);
		String recv = Connection(name);
		log.info("recv:"+recv);
		String str = "";
		if(recv==null){
			str = "∑≠“Î ß∞‹£°";
		}else{
			str = redis.GetList(recv);
		}
		Map<String, String> map = new HashMap<String, String>();
		map.put("result", str);
		JSONObject jo = JSONObject.fromObject(map);
		this.result = jo.toString();
		
		return SUCCESS;
	}
}

