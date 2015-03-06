package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_history")
public class ProjectHistory2 extends ProjectHistory{
	
	@DBField(column="user_name")
	public String userName;
	
	@DBField(column="project_name")
	public String projectName;
}
