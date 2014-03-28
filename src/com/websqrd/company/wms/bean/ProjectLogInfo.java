package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_logs")
public class ProjectLogInfo extends DAOBean {
	
	public static final int LOG_ENVIRONMENT = 1;
	public static final int LOG_DEVELOPMENT = 2;
	public static final int LOG_ETCETERA = 3;
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int pid; 
	@DBField(column="project_id", type=DBField.Type.Int)
	public int projectId; //프로젝트 번호
	@DBField(column="type", type=DBField.Type.Int)
	public int type;
	@DBField(column="ver", type=DBField.Type.String)
	public String ver;
	@DBField(column="user_id", type=DBField.Type.String) 
	public String userId;
	@DBField(column="log_text", type=DBField.Type.String)
	public String logText;
}

//create table project_logs (id int auto_increment , project_id int, type int,ver varchar(30),user_id varchar(128), log_text mediumtext, primary key(id), unique (project_id, type, ver), index(user_id));