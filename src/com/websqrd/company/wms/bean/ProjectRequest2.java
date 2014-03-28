package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;

public class ProjectRequest2 extends ProjectRequest {
	@DBField(column="user_name")
	public String userName;
	@DBField(column="client_person_name")
	public String clientPersonName;
}
