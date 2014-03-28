package com.websqrd.company.wms.bean;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

public class DAOBeanInfo {
	protected static Logger logger = LoggerFactory.getLogger(DAOBeanInfo.class);
			
	protected String tableName;
	private Class<? extends DAOBean> beanClass;
	protected int pkCount;
	protected List<FieldColumnType> fieldColumnList;
	
	public static class FieldColumnType{
		public Field field;
		public String column;
		public DBField.Type type;
		public boolean isPk;
		public DBField.ParamType paramType;
		public String expression;
		
		public FieldColumnType(Field field, String column, DBField.Type type, boolean isPk, DBField.ParamType paramType, String expression){
			this.field = field;
			this.column = column;
			this.type = type;
			this.isPk = isPk;
			this.paramType = paramType;
			this.expression = expression;
		}
	}
	
	public DAOBeanInfo(DAOBean bean){
		beanClass = bean.getClass();
		DBTable dbt = beanClass.getAnnotation(DBTable.class);
		if(dbt == null){
			//error
			//logger.error("DAOBean클래스에 DBTable 어노테이션이 정의되어있지 않습니다. beanClass={}", beanClass);
			//테이블이 없을 경우도 그대로 사용.
			tableName = "";
		}else{
			tableName = dbt.value();
		}
		if(fieldColumnList == null){
			prepareField();
		}
	}
	
	protected synchronized void prepareField(){
		if(fieldColumnList != null){
			return;
		}
		
		fieldColumnList = new ArrayList<FieldColumnType>();
		
		Field[] list = beanClass.getFields();
		
		for (int i = 0; i < list.length; i++) {
			Field f = list[i];
			DBField dbf = f.getAnnotation(DBField.class);
			if(dbf != null){
//				logger.debug("fieldColumn-{} >> {}", f.getName(), dbf);
				if(dbf.pk()){
					pkCount++;
				}
				fieldColumnList.add(new FieldColumnType(f, dbf.column(), dbf.type(), dbf.pk(), dbf.paramType(), dbf.expression()));
				
			}
		}
	}
	
	public String getTableName(){
		return tableName;
	}
	public int getPkCount(){
		return pkCount;
	}
	public List<FieldColumnType> getFieldColumnTypeList(){
		return fieldColumnList;
	}
	
}
