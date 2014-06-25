package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.EventInfo;
import com.websqrd.company.wms.bean.MemoInfo;

public class EventDAO extends Mapper<EventInfo> {

	@Override
	public EventInfo createBean(){
		return new EventInfo();
	}
	
	public EventInfo selectOne(String serialId){
		String where = "where user_sid = '" + serialId + "'";
		List<EventInfo> list = super.select(where, null);
		if(list != null && list.size() > 0){
			return list.get(0);
		}
		return null;
	}
	
	public boolean update(EventInfo eventInfo){
		return super.update("set content = ?", "where user_sid = ?", new String[]{eventInfo.content, eventInfo.userSID}) > 0;
	}
}
