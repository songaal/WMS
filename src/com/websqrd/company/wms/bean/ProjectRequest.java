package com.websqrd.company.wms.bean;

import java.sql.Date;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_request")
public class ProjectRequest extends DAOBean{
	
	public static String STATUS_READY = "A"; //등록
	public static String STATUS_WORKING = "B"; //작업중
	public static String STATUS_DONE = "C"; //완료
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int rid;
	@DBField(column="project_id", type=DBField.Type.Int)
	public int pid;
	
	@DBField(column="user_id")
	public String userId;
	@DBField(column="client_person_id", type=DBField.Type.Int)
	public int clientPersonId;
	@DBField(column="client_pname")
	public String clientPname;
	
	@DBField(column="method")
	public String method;
	@DBField(column="type")
	public String type;
	@DBField(column="title")
	public String title;
	@DBField(column="content")
	public String content;
	
	@DBField(column="regdate", type=DBField.Type.Date)
	public Date regdate; 
	@DBField(column="due_date", type=DBField.Type.Date)
	public Date dueDate; 
	
	@DBField(column="done_date", type=DBField.Type.Date)
	public Date doneDate; 
	
	@DBField(column="status", type=DBField.Type.String, expression="'A'", paramType=DBField.ParamType.nullparm)
	public String status;
	
	public String getStatusString()
	{
		if ( status == null ) return "";
		if ( status.equals(STATUS_READY) ) return "등록";
		if ( status.equals(STATUS_WORKING) ) return "작업중";
		if ( status.equals(STATUS_DONE) ) return "완료";
		return "";
	}
	
}
