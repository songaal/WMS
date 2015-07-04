package co.fastcat.wms;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.util.Date;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DAO {
	protected static Logger logger = LoggerFactory.getLogger(DAO.class);
	
	protected String getString(Map<String, String[]> valueMap, String key) {
		String[] obj = valueMap.get(key);
		if(obj != null){
			return obj[0];
		}
		return null;
	}

	
	protected int getInt(Map<String, String[]> valueMap, String key) {
		String[] obj = valueMap.get(key);
		if(obj != null){
			try{
				return Integer.parseInt(obj[0]);
			}catch(Exception e){
				logger.error("필드값 파싱중 에러발생. Boolean => {}", obj[0]);
			}
		}
		return -1;
	}
	
	protected boolean getBoolean(Map<String, String[]> valueMap, String key) {
		String[] obj = valueMap.get(key);
		if(obj != null){
			try{
				return Boolean.parseBoolean(obj[0]);
			}catch(Exception e){
				logger.error("필드값 파싱중 에러발생. Boolean => {}", obj[0]);
			}
		}
		return false;
	}
	
	protected char getCharacter(Map<String, String[]> valueMap, String key) {
		String[] obj = valueMap.get(key);
		if(obj != null){
			try{
				return obj[0].charAt(0);
			}catch(Exception e){
				logger.error("필드값 파싱중 에러발생. Boolean => {}", obj[0]);
			}
		}
		return Character.MIN_VALUE;
	}
	
	protected Timestamp getTimestamp(Map<String, String[]> valueMap, String key) {
		String[] obj = valueMap.get(key);
		if(obj != null){
			try{
				return new Timestamp(DateFormat.getDateTimeInstance().parse(obj[0]).getTime());
			}catch(Exception e){
				logger.error("필드값 파싱중 에러발생. Boolean => {}", obj[0]);
			}
		}
		return new Timestamp(0);
	}
	
	protected Date getDate(Map<String, String[]> valueMap, String key) {
		return getTimestamp(valueMap, key);
	}
	
	protected String notNull(String value, String defaultValue){
		if(value == null){
			return defaultValue;
		}else{
			return value;
		}
	}
	
}
