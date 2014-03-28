package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("work_list")
public class WorkList2 extends WorkList{
	
	@DBField(column="project_name")
	public String projectName;
	
}
