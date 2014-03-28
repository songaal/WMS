package com.websqrd.company.wms.dao;

import java.util.ArrayList;
import java.util.List;

import com.websqrd.company.wms.bean.ClientPersonInfo;
import com.websqrd.company.wms.bean.ClientPersonInfo2;
import com.websqrd.company.wms.bean.DAOBean;


public class ClientPersonDAO extends Mapper<ClientPersonInfo> {

	@Override
	public ClientPersonInfo createBean() {
		return new ClientPersonInfo();
	}

	public List<ClientPersonInfo> select(){
		return select(null, "order by person_name asc");
	}
	
	public List<DAOBean> select2(){
		String where = null;
		String orderby = "order by person_name asc";
		String join = "left join client_info B on A.client_id = B.id";
		String joinSelect = "B.client_name as client_name";
		
		return select(where, orderby, join, joinSelect, ClientPersonInfo2.class);
	}
	
	//고객번호
	public ClientPersonInfo2 select2(String id){
		String where = "where A.id = '"+id+"'";
		String orderby = "order by person_name asc";
		String join = "left join client_info B on A.client_id = B.id";
		String joinSelect = "B.client_name as client_name";
		
		List<DAOBean> list = super.select(where, orderby, join, joinSelect, ClientPersonInfo2.class);
		if(list != null && list.size() > 0){
			return (ClientPersonInfo2) list.get(0);
		}
		return null;
	}
	
	//고객사내의 모든 고객인물
	public List<DAOBean> selectByCompany(String cid){
		String where = "where A.client_id = '"+cid+"'";
		String orderby = "order by person_name asc";
		String join = "left join client_info B on A.client_id = B.id";
		String joinSelect = "B.client_name as client_name";
		
		return super.select(where, orderby, join, joinSelect, ClientPersonInfo2.class);
	}
	
	public List<DAOBean> personSearch(String key){
		String where = "where person_name like '%"+key+"%' or memo like '%"+key+"%' "; 
		List<DAOBean> list = super.select(where, "order by regdate", null, null, ClientPersonInfo2.class);
		if ( list != null && list.size() > 0 )
			return list;
		return new ArrayList<DAOBean>();
	}
}
