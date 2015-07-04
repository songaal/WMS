package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("File_List")
public class FileInfo2 extends FileInfo{
		
	@DBField(column="project_name")
	public String projectName;
	
	@DBField(column="user_name")
	public String userName;
}
