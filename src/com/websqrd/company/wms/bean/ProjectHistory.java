package com.websqrd.company.wms.bean;

import java.sql.Date;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_history")
public class ProjectHistory extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int mid;
	@DBField(column="project_id", type=DBField.Type.Int)
	public int pid;
	@DBField(column="work_id", type=DBField.Type.Int)
	public int wid;
	
	@DBField(column="type")
	public String type;
	
	@DBField(column="regdate", type=DBField.Type.Date, expression="NOW()", paramType=DBField.ParamType.nullparm)
	public Date regdate;
	@DBField(column="user_id")
	public String userId;
	@DBField(column="memo")
	public String memo;
	
}
