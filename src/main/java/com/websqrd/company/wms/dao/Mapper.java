package com.websqrd.company.wms.dao;

import com.websqrd.company.wms.DAOHandler;
import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.DAOBeanInfo.FieldColumnType;
import com.websqrd.tool.db.DBConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Field;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public abstract class Mapper<T extends DAOBean> {
	protected static Logger logger = LoggerFactory.getLogger(Mapper.class);
	public static String PoolName = "WMS";
	
	protected T stub;
	
	public Mapper(){
		stub = createBean();
	}
	public DBConnectionPool getPool(){
		return DAOHandler.getInstance().getConnectionPool(PoolName);
	}
	
	protected void close(PreparedStatement pstmt) {
		if(pstmt != null){
			try {
				pstmt.close();
			} catch (SQLException e) {
			}
		}
		
	}
	
	protected void close(Statement stmt) {
		if(stmt != null){
			try {
				stmt.close();
			} catch (SQLException e) {
			}
		}
		
	}
	
	abstract public T createBean();
	
	public String create(T entry){
		return create(entry, false);
	}
	public String create(T entry, boolean ignore){
		String[] columnParam = getInsertFieldListString(stub);
		String sql = "insert "+(ignore?"ignore ":"")+"into "+ stub.getBeanInfo().getTableName() 
				+ "("+ columnParam[0] + ") values ("+ columnParam[1] +")";
		logger.debug("insert SQL >> {}", sql);
		
		List<FieldColumnType> fieldColumnList = stub.getBeanInfo().getFieldColumnTypeList();
		
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = conn.prepareStatement(sql);
			int paramIdx = 1;
			for (int i = 0; i < fieldColumnList.size(); i++) {
				FieldColumnType fct = fieldColumnList.get(i);
				//insert시 자동증가 필드는 입력하지 않는다.
				if(DBField.ParamType.auto.equals(fct.paramType)) {
					continue;
				}
				DBField.Type type = fct.type;
				String columnName = fct.column;
				Object value = fct.field.get(entry);
				
				if(!DBField.ParamType.nullparm.equals(fct.paramType)) {
					logger.trace("set pstmt {} {} >> {}", new Object[]{paramIdx, columnName, value});
					setPstmtValue(pstmt, paramIdx++, type, value);
				}
			}
			if(pstmt.executeUpdate() > 0){
				try{
					rs = pstmt.getGeneratedKeys();
		            if (rs.next()) {
			            return rs.getString(1);
		            }
	            } catch(Throwable t1) {
				}

	            return "";

			}else{
				return null;
			}
			
		} catch (Exception e) {
			logger.error("", e);
			return null;
		}finally{
			close(pstmt);
			close(rs);
			getPool().returnConnection(conn);
		}
		
	}
	
	public boolean isExist(String where){
		String sql = "select id from "+ stub.getBeanInfo().getTableName()
			+ " " + where;
		logger.debug("isExist SQL = {}", sql);
		
		Connection conn = getPool().getConnection();
		Statement stmt = null;
		ResultSet rs = null;
		try{
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			if(rs.next()){
				return true;
			}
		}catch(SQLException e){
			logger.error("", e);
		}catch(Exception e){
			logger.error("", e);
		}finally{
			close(stmt);
			close(rs);
			getPool().returnConnection(conn);
		}
		return false;
	}
	
	public int update(String set, String where, String[] values){
		String sql = "update "+ stub.getBeanInfo().getTableName()
				+ " " + set 
				+ " " + where;
		logger.debug("Update SQL = {}", sql);
		
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.prepareStatement(sql);
			
			for (int i = 0; i < values.length; i++) {
				pstmt.setString(i+1, values[i]);
			}
			return pstmt.executeUpdate();
		}catch(SQLException e){
			logger.error("", e);
			return -1;
		}catch(Exception e){
			logger.error("", e);
			return -2;
		}finally{
			close(pstmt);
			getPool().returnConnection(conn);
		}
	}
	
	public int update(String set, String where){
		String sql = "update "+ stub.getBeanInfo().getTableName()
				+ " " + set 
				+ " " + where;
		logger.debug("Update SQL = {}", sql);
		
		Connection conn = getPool().getConnection();
		Statement stmt = null;
		try{
			stmt = conn.createStatement();
			return stmt.executeUpdate(sql);
		}catch(SQLException e){
			logger.error("", e);
			return -1;
		}catch(Exception e){
			logger.error("", e);
			return -2;
		}finally{
			close(stmt);
			getPool().returnConnection(conn);
		}
	}
	
	public int modify(T entry){
		return modify(entry, new ArrayList<String>());
	}
	public int modify(T entry, List<String> excludeColumns){
		String[] columnParam = getUpdateFieldListString(stub, excludeColumns);
		String sql = "update "+ stub.getBeanInfo().getTableName()
				+ " set "+ columnParam[0] 
				+ " where " + columnParam[1];
			
		logger.debug("Modify SQL = {}", sql);
		
		List<FieldColumnType> fieldColumnList = stub.getBeanInfo().getFieldColumnTypeList();
		int pkCount = stub.getBeanInfo().getPkCount();
		int pkParamIdx = fieldColumnList.size() - pkCount + 1 - excludeColumns.size();
				
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		try{
			pstmt = conn.prepareStatement(sql);
			
			int paramIdx = 1;
			for (int i = 0; i < fieldColumnList.size(); i++) {
				FieldColumnType fct = fieldColumnList.get(i);
				DBField.Type type = fct.type;
				String columnName = fct.column;
				Field field = fct.field;
				Object value = field.get(entry);
				if(fct.isPk){
					logger.trace("set PK pstmt {} {} >> {}", new Object[]{pkParamIdx, columnName, value});
					setPstmtValue(pstmt, pkParamIdx++, type, value);
				}else{
					if(excludeColumns.contains(columnName)){
						//제외필드는 업데이트 하지 않는다.
						continue;
					}
					logger.trace("set pstmt {} {} >> {}", new Object[]{paramIdx, columnName, value});
					setPstmtValue(pstmt, paramIdx++, type, value);
				}
				
			}
			return pstmt.executeUpdate();
		}catch(SQLException e){
			logger.error("", e);
			return -1;
		}catch(Exception e){
			logger.error("", e);
			return -2;
		}finally{
			close(pstmt);
			getPool().returnConnection(conn);
		}
		
	}
	
	public int delete(T entry){
		String[] columnParam = getUpdateFieldListString(stub);
		String sql = "delete from "+ stub.getBeanInfo().getTableName() 
				+ " where " + columnParam[1];
			
		logger.debug("DELETE SQL = {}", sql);
		
		List<FieldColumnType> fieldColumnList = stub.getBeanInfo().getFieldColumnTypeList();
				
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = conn.prepareStatement(sql);
			
			int pkParamIdx = 1;
			for (int i = 0; i < fieldColumnList.size(); i++) {
				FieldColumnType fct = fieldColumnList.get(i);
				DBField.Type type = fct.type;
				String columnName = fct.column;
				Field field = fct.field;
				Object value = field.get(entry);
				if(fct.isPk){
					logger.debug("set PK pstmt {} {} >> {}", new Object[]{pkParamIdx, columnName, value});
					setPstmtValue(pstmt, pkParamIdx++, type, value);
				}
				
			}
			return pstmt.executeUpdate();
		}catch(SQLException e){
			logger.error("", e);
			return -1;
		}catch(Exception e){
			logger.error("", e);
			return -2;
		}finally{
			close(pstmt);
			close(rs);
			getPool().returnConnection(conn);
		}
		
	}
	
	public int delete(String where){
		String sql = "delete from "+ stub.getBeanInfo().getTableName() 
				+ " " + where;
			
		logger.debug("DELETE SQL = {}", sql);
		
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = conn.prepareStatement(sql);
			
			return pstmt.executeUpdate();
		}catch(SQLException e){
			logger.error("", e);
			return -1;
		}catch(Exception e){
			logger.error("", e);
			return -2;
		}finally{
			close(pstmt);
			close(rs);
			getPool().returnConnection(conn);
		}
		
	}
	
	
	
	
	public static void setPstmtValue(PreparedStatement pstmt, int parameterIndex, DBField.Type type, Object value){
		try {
			if(type == DBField.Type.String){
				pstmt.setString(parameterIndex, (String)value);
			} else if(type == DBField.Type.Int){
				pstmt.setInt(parameterIndex, (Integer)value);
			} else if(type == DBField.Type.Long){
				pstmt.setLong(parameterIndex, (Long)value);
			} else if(type == DBField.Type.Float){
				pstmt.setFloat(parameterIndex, (Float)value);
			} else if(type == DBField.Type.Double){
				pstmt.setDouble(parameterIndex, (Double)value);
			} else if(type == DBField.Type.Timestamp){
				pstmt.setTimestamp(parameterIndex, (Timestamp)value);
			} else if(type == DBField.Type.Date){
				pstmt.setDate(parameterIndex, (Date)value);
			} else if(type == DBField.Type.DateTime){
				pstmt.setTimestamp(parameterIndex, new Timestamp(((java.util.Date)value).getTime()));
			}
		} catch (SQLException e) {
			logger.error("", e);
		}
	}
	
	public int count(String where){
		String sql = "select count(1) from " + stub.getBeanInfo().getTableName();
		sql = sql + " " + where;
		logger.debug("select COUNT SQL >> {}", sql);
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				return rs.getInt(1);
			}
		}catch(SQLException e){
			logger.error("", e);
		}finally{
			close(pstmt);
			close(rs);
			getPool().returnConnection(conn);
		}
		
		return -1;
	}
	
	public int max(String field, String where){
		String sql = "select max("+field+") from " + stub.getBeanInfo().getTableName();
		sql = sql + " " + where;
		logger.debug("select MAX SQL >> {}", sql);
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				return rs.getInt(1);
			}
		}catch(SQLException e){
			logger.error("", e);
		}finally{
			close(pstmt);
			close(rs);
			getPool().returnConnection(conn);
		}
		
		return -1;
	}
	
	
	public List<T> select(String where, String orderby){
		return select(where, orderby, null);
	}
	
	public List<T> select(String where, String orderby, String limit){
		String sql = "select " + getSelectFieldListString(stub);
		sql += " from " + stub.getBeanInfo().getTableName();
		
		if(where != null){
			sql += " " + where;
		}
		
		if(orderby != null){
			sql += " " + orderby;
		}
		
		if(limit != null) {
			sql += " " + limit;
		}
		
		logger.debug("select SQL >> {}", sql);
		List<T> result = new ArrayList<T>();
		String str = getPool().getStatusString();
		logger.debug("Conn status : {}", str);
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				
				T entry = createBean();
				entry.map(rs);
				result.add(entry);
			}
		}catch(SQLException e){
			logger.error("", e);
		}finally{
			close(pstmt);
			close(rs);
			getPool().returnConnection(conn);
		}
		return result;
	}
	public List<DAOBean> select(String where, String orderby, String join, String joinSelect, Class<? extends T> beanClass){
		return select(where,orderby,join,joinSelect,null,beanClass);
	}
	
	public List<DAOBean> select(String where, String orderby, String join, String joinSelect, String limit, Class<? extends T> beanClass){
		String mainTableAlias = "A";
		String sql = "select " + getSelectFieldListString(stub, mainTableAlias);
		
		if(joinSelect != null){
			sql += "," + joinSelect;
		}
		sql += " from " + stub.getBeanInfo().getTableName() + " " + mainTableAlias;
		
		if(join != null){
			sql += " " + join;
		}
		if(where != null){
			sql += " " + where;
		}
		
		if(orderby != null){
			sql += " " + orderby;
		}
		
		if(limit != null) {
			sql += " " + limit;
		}
		
		logger.debug("JOIN select SQL >> {}", sql);
		List<DAOBean> result = new ArrayList<DAOBean>();
		String str = getPool().getStatusString();
		logger.debug("Conn status : {}", str);
		Connection conn = getPool().getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try{
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				
				//T entry = createBean();
				DAOBean bean = null;
				try {
					bean = beanClass.newInstance();
				} catch (Exception e) {
					logger.error("", e);
				}
				bean.map(rs);
				result.add(bean);
//				result.add(entry);
			}
		}catch(SQLException e){
			logger.error("", e);
		}finally{
			close(pstmt);
			close(rs);
			getPool().returnConnection(conn);
		}
		return result;
	}
	
	protected String getSelectFieldListString(T bean){
		return getSelectFieldListString(bean, null);
	}
	
	protected String getSelectFieldListString(T bean, String label){
		StringBuilder sb = new StringBuilder(); 
		List<FieldColumnType> fieldColumnTypeList = bean.getBeanInfo().getFieldColumnTypeList();
		
		for (int i = 0; i < fieldColumnTypeList.size(); i++) {
			FieldColumnType fct = fieldColumnTypeList.get(i);
			if(sb.length() > 0){
				sb.append(", ");
			}
			if(label != null){
				sb.append(label).append(".");
			}
			sb.append(fct.column);
		}
		return sb.toString();
	}
	
	//0 : 필드리스트
	//1 : ?,?.. 파라미터리스트
	protected String[] getInsertFieldListString(T bean){
		StringBuilder sb = new StringBuilder(); 
		StringBuilder sb2 = new StringBuilder();
		List<FieldColumnType> fieldColumnTypeList = bean.getBeanInfo().getFieldColumnTypeList();
		
		for (int i = 0; i < fieldColumnTypeList.size(); i++) {
			FieldColumnType fct = fieldColumnTypeList.get(i);
			//auto increment필드이면 insert시 제외한다.
			
			String expression = fct.expression;
			
			if(DBField.ParamType.auto.equals(fct.paramType)) {
				continue;
			}
			
			if(sb.length() > 0){
				sb.append(", ");
				sb2.append(", ");
			}
			
			sb.append(fct.column);
			sb2.append(expression);
			
		}
		return new String[]{sb.toString(), sb2.toString()};
	}
	
	//0: pk 컬럼을 제외한 필드리스트 = ?
	//1: pk 필드리스트 = ?
	protected String[] getUpdateFieldListString(T bean){
		return getUpdateFieldListString(bean, new ArrayList<String>());
	}
	protected String[] getUpdateFieldListString(T bean, List<String> excludeColumns){
		StringBuilder sb = new StringBuilder(); 
		StringBuilder sb2 = new StringBuilder(); 
		List<FieldColumnType> fieldColumnTypeList = bean.getBeanInfo().getFieldColumnTypeList();
		
		for (int i = 0; i < fieldColumnTypeList.size(); i++) {
			FieldColumnType fct = fieldColumnTypeList.get(i);
			if(!fct.isPk){
				if(excludeColumns.contains(fct.column)){
					//제외필드는 업데이트 제외.
					continue;
				}
				
				if(sb.length() > 0){
					sb.append(", ");
				}
				sb.append(fct.column).append(" = ?");
			}else{
				if(sb2.length() > 0){
					sb2.append(" AND ");
				}
				sb2.append(fct.column).append(" = ?");
			}
		}
		return new String[]{sb.toString(), sb2.toString()}; //select 절
	}
	
	protected void close(ResultSet rs) {
		if(rs != null){
			try {
				rs.close();
			} catch (SQLException e) {
			}
		}
	}
	
}
