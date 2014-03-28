package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("rest_data")
public class RestData2 extends RestData{
	
	@DBField(column="user_name")
	public String userName;
	
}
