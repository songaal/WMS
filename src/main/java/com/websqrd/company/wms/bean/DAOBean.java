package com.websqrd.company.wms.bean;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBField.Type;
import com.websqrd.company.wms.bean.DAOBeanInfo.FieldColumnType;
import com.websqrd.company.wms.webpage.WebUtil;

public class DAOBean {
	protected static Logger logger = LoggerFactory.getLogger(DAOBean.class);
	
	protected DAOBeanInfo beanInfo;
	//reflection은 비용이 크므로, cache를 활용한다.
	protected static Map<String, DAOBeanInfo> beanInfoCache = new HashMap<String, DAOBeanInfo>();
	
	public DAOBean(){
		String className = this.getClass().getName();
		beanInfo = beanInfoCache.get(className);
		if(beanInfo == null){
			beanInfo = new DAOBeanInfo(this);
			beanInfoCache.put(className, beanInfo);
		}
//		logger.debug("Bean className = {} >> beanInfo = {}", className, beanInfo);
	}
	
	public DAOBeanInfo getBeanInfo(){
		return beanInfo;
	}
	
	public void map(ResultSet rs) {
		for (int j = 0; j < beanInfo.fieldColumnList.size(); j++) {
			FieldColumnType fct = beanInfo.fieldColumnList.get(j);
			setFieldData(rs, j, fct.type, fct.column);
//			logger.debug("f = {}", fct.field);
		}
	}
	
	private void setFieldData(ResultSet rs, int idx, Type type, String column) {
		try{
			if(type == DBField.Type.String){
				String value = rs.getString(column);
				if(value != null){
					beanInfo.fieldColumnList.get(idx).field.set(this, value);
				}
			}else if(type == DBField.Type.Int){
				int value = rs.getInt(column);
				beanInfo.fieldColumnList.get(idx).field.set(this, value);
			}else if(type == DBField.Type.Long){
				long value = rs.getLong(column);
				beanInfo.fieldColumnList.get(idx).field.set(this, value);
			}else if(type == DBField.Type.Float){
				float value = rs.getFloat(column);
				beanInfo.fieldColumnList.get(idx).field.set(this, value);
			}else if(type == DBField.Type.Double){
				double value = rs.getDouble(column);
				beanInfo.fieldColumnList.get(idx).field.set(this, value);
			}else if(type == DBField.Type.Timestamp){
				Timestamp value = rs.getTimestamp(column);
				if(value != null){
					beanInfo.fieldColumnList.get(idx).field.set(this, value);
				}
			}else if(type == DBField.Type.Date){
				Date value = rs.getDate(column);
				if(value != null){
					beanInfo.fieldColumnList.get(idx).field.set(this, value);
				}
			}else if(type == DBField.Type.DateTime){
				Timestamp ts = rs.getTimestamp(column);
				if(ts != null){
					java.util.Date value = new java.util.Date(ts.getTime());
					beanInfo.fieldColumnList.get(idx).field.set(this, value);
				}
			}else{
				logger.error("알수없는 필드타입입니다. column = {}, type = {}", column, type);
			}
		}catch(Exception e){
			logger.error("", e);
		}
		
	}
	
	public void map(Map<String, String[]> paramMap) {
		for (int j = 0; j < beanInfo.fieldColumnList.size(); j++) {
			FieldColumnType fct = beanInfo.fieldColumnList.get(j);
			String fieldName = fct.field.getName();
			//페이지를 통해 전달받은 값은 []로 되어있다.
			String[] values = paramMap.get(fieldName);
			if(values != null){
				//실제 값.
				String value = values[0];
				setFieldData(j, fct.type, value);
			}
		}
	}
	
	private void setFieldData(int idx, Type type, String val) {
		try{
			if(type == DBField.Type.String){
				beanInfo.fieldColumnList.get(idx).field.set(this, val);
			}else if(type == DBField.Type.Int){
				int value = Integer.parseInt(val);
				beanInfo.fieldColumnList.get(idx).field.set(this, value);
			}else if(type == DBField.Type.Long){
				long value = Long.parseLong(val);
				beanInfo.fieldColumnList.get(idx).field.set(this, value);
			}else if(type == DBField.Type.Float){
				float value = Float.parseFloat(val);
				beanInfo.fieldColumnList.get(idx).field.set(this, value);
			}else if(type == DBField.Type.Double){
				double value = Double.parseDouble(val);
				beanInfo.fieldColumnList.get(idx).field.set(this, value);
			}else if(type == DBField.Type.Timestamp){
				java.util.Date o = WebUtil.parseDatetime(val);
				if(o != null){
					Timestamp value = new Timestamp(o.getTime());
					beanInfo.fieldColumnList.get(idx).field.set(this, value);
				}
			}else if(type == DBField.Type.Date){
				java.util.Date o = WebUtil.parseDate(val);
				if(o != null){
					Date value = new Date(o.getTime());
					beanInfo.fieldColumnList.get(idx).field.set(this, value);
				}
			}else if(type == DBField.Type.DateTime){
				java.util.Date value = WebUtil.parseDatetime(val);
				if(value != null){
					beanInfo.fieldColumnList.get(idx).field.set(this, value);
				}
			}else{
				logger.error("알수없는 필드타입입니다. type = {}, value = {}", type, val);
			}
		}catch(Exception e){
			logger.error("error occurs in set field data {}=>{}", new Object[] {beanInfo.fieldColumnList.get(idx).column, val } ,e);
		}
	}
	
}
