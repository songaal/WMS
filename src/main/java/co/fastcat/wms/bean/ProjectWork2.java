package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("project_work")
public class ProjectWork2 extends ProjectWork{
	@DBField(column="user_name")
	public String userName;
	
	@DBField(column="project_name")
	public String projectName;
	
}
