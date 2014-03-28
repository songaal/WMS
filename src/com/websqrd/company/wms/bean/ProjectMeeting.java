package com.websqrd.company.wms.bean;

import java.sql.Date;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_meeting")
public class ProjectMeeting extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int mid;
	@DBField(column="project_id", type=DBField.Type.Int)
	public int pid;
	
	@DBField(column="meet_date", type=DBField.Type.Date)
	public Date meetDate; 
	@DBField(column="place")
	public String place;
	
	@DBField(column="user_id")
	public String userId;
	@DBField(column="websqrd_user")
	public String websqrdUser;
	@DBField(column="client_user")
	public String clientUser;
	
	@DBField(column="content")
	public String content;
	@DBField(column="next_schedule")
	public String nextSchedule;
	@DBField(column="next_todo")
	public String nextTodo;
	
	@DBField(column="regdate", type=DBField.Type.Date)
	public Date regdate; 
	
}
