package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("approval_setting")
public class ApprovalSetting2 extends ApprovalSetting{
	
	@DBField(column="res_user_name1")
	public String resUserName1;
	@DBField(column="res_user_name2")
	public String resUserName2;
	@DBField(column="res_user_name3")
	public String resUserName3;
	
}