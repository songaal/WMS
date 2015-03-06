package com.websqrd.company.wms.bean;

import java.sql.Date;
import java.sql.Timestamp;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("work_list")
public class WorkList extends DAOBean{
	
	@DBField(column="user_sid", pk=true)
	public String userSID;
	@DBField(column="pid", pk=true, type=DBField.Type.Int)
	public int pid;
	@DBField(column="regdate", pk=true, type=DBField.Type.Date)
	public Date regdate; //등록일
	@DBField(column="content")
	public String content;
	
}
