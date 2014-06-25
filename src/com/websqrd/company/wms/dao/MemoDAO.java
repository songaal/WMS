package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.MemoInfo;

public class MemoDAO extends Mapper<MemoInfo> {

	@Override
	public MemoInfo createBean(){
		return new MemoInfo();
	}
	
	public MemoInfo selectOne(String serialId){
		String where = "where user_sid = '" + serialId + "'";
		List<MemoInfo> list = super.select(where, null);
		if(list != null && list.size() > 0){
			return list.get(0);
		}
		return null;
	}
	
	public boolean update(MemoInfo memoInfo){
		return super.update("set content = ?", "where user_sid = ?", new String[]{memoInfo.content, memoInfo.userSID}) > 0;
	}
}
