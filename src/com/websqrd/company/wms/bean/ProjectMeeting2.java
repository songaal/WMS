package com.websqrd.company.wms.bean;

import java.util.List;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_meeting")
public class ProjectMeeting2 extends ProjectMeeting{
	
	@DBField(column="user_name")
	public String userName;
	public List<String> websqrdNameList;
	public List<String> clientNameList;
}
