package com.websqrd.company.wms.bean;

import java.sql.Date;
import java.sql.Timestamp;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("File_List")
public class FileInfo extends DAOBean{
		
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id = -1; //파일 번호
	
	@DBField(column="regdate", type=DBField.Type.Date, expression="NOW()", paramType=DBField.ParamType.nullparm)
	public Date regdate;
	
	@DBField(column="project_id")
	public String projectId;
		
	@DBField(column="user_sid")
	public String userSid;
	
	@DBField(column="fileName")
	public String fileName;	
		
	@DBField(column="storeName")
	public String storeName;	
	
	@DBField(column="descript")
	public String desc;
}
