package com.websqrd.company.wms.dao;

import java.util.ArrayList;
import java.util.List;

import com.websqrd.company.wms.bean.ClientInfo;

public class ClientDAO extends Mapper<ClientInfo> {

	@Override
	public ClientInfo createBean() {
		return new ClientInfo();
	}

	//고객사 리스트
	public List<ClientInfo> select(){
		return select(null, "order by regdate desc");
	}
		
	//고객사 리스트
	public List<ClientInfo> selectA(){
		return select("where type='A'", "order by regdate desc");
	}
	
	//리셀러 리스트
	public List<ClientInfo> selectB(){
		return select("where type='B'", "order by regdate desc");
	}
	
	public ClientInfo select(String cid){
		String where = "where id = '" + cid +"'";
		List<ClientInfo> list = super.select(where, "order by regdate desc");
		if(list != null && list.size() > 0){
			return list.get(0);
		}
		return null;
	}
	
	public List<ClientInfo> clientSearch(String key){
		String where = "where client_name like '%"+key+"%' or memo like '%"+key+"%' ";
		List<ClientInfo> list = super.select(where, "order by regdate desc");
		if ( list != null && list.size() > 0 )
			return list;
		return new ArrayList<ClientInfo>();
	}
		
}
