package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("work_info")
public class WorkInfo2 extends WorkInfo{
	
	@DBField(column="project_name")
	public String projectName;
	
}
