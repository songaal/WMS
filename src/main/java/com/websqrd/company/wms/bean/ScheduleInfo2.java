package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("schedule_info")
public class ScheduleInfo2 extends ScheduleInfo{
	
	@DBField(column="user_name")
	public String userName; //이름
}
