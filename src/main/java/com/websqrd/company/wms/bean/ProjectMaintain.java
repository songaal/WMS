package com.websqrd.company.wms.bean;

import java.sql.Date;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_maintain")
public class ProjectMaintain extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int mid;
	@DBField(column="project_id", type=DBField.Type.Int)
	public int pid;
	
	@DBField(column="maintain_date", type=DBField.Type.Date)
	public Date maintainDate;
	@DBField(column="done_date", type=DBField.Type.Date)
	public Date doneDate;

	@DBField(column="user_id")
	public String userId;
	@DBField(column="maintain_list")
	public String maintainList;
	@DBField(column="result")
	public String result;
	@DBField(column="comment")
	public String comment;
	
	@DBField(column="task_id", type=DBField.Type.Int)
	public int taskId;
	
}
