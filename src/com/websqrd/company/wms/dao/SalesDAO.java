package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.SalesInfo;


public class SalesDAO extends Mapper<SalesInfo>{
	
	public SalesDAO(){ }
	
	@Override
	public SalesInfo createBean() {
		return new SalesInfo();
	}
	//전체
	public List<SalesInfo> select(){
		String where = null;
		String orderby = "order by regdate desc, id desc";
		return select(where, orderby);
	}
	//타입별. 진행.계약.취소...
	public List<SalesInfo> selectType(String type){
		String where = null;
		if(type != null){
			where = "where result = '"+type+"'";
		}
		String orderby = "order by regdate desc, id desc";
		return select(where, orderby);
	}
	
	public SalesInfo select(String salesId){
		String where = "where id = '" + salesId + "'";
		List<SalesInfo> list = select(where, null);
		if(list != null && list.size() > 0){
			return (SalesInfo) list.get(0);
		}
		
		return null;
	}
	

}
