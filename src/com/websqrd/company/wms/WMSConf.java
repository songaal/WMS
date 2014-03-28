package com.websqrd.company.wms;

import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class WMSConf {
	protected static Logger logger = LoggerFactory.getLogger(WMSConf.class);
	public static WMSConf instance = new WMSConf();
	public Properties props;
	
	public static WMSConf getInstance(){
		return instance;
	}
	
	public WMSConf(){ }
	
	public void init(Properties props){
		this.props = props;
	}
	
	public String get(String key){
		return props.getProperty(key);
	}
	
	public String get(String key, String defaultValue){
		return props.getProperty(key, defaultValue);
	}
	
	public int getInt(String key, int defaultValue){
		String value = props.getProperty(key);
		int val = defaultValue;
		try{
			val = Integer.parseInt(value);
		}catch(NumberFormatException e){ 
			logger.error("", e.getMessage());
		}
		return val;
	}
	
}
