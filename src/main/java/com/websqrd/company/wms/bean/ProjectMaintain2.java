package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_maintain")
public class ProjectMaintain2 extends ProjectMaintain{
	
	@DBField(column="user_name")
	public String userName;
	
}
