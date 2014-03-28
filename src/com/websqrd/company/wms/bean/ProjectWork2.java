package com.websqrd.company.wms.bean;

import java.sql.Date;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_work")
public class ProjectWork2 extends ProjectWork{
	@DBField(column="user_name")
	public String userName;
	
	@DBField(column="project_name")
	public String projectName;
	
}
