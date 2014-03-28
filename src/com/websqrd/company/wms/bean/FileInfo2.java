package com.websqrd.company.wms.bean;

import java.sql.Date;
import java.sql.Timestamp;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("File_List")
public class FileInfo2 extends FileInfo{
		
	@DBField(column="project_name")
	public String projectName;
	
	@DBField(column="user_name")
	public String userName;
}
