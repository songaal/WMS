package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("project_history")
public class ProjectHistory2 extends ProjectHistory{
	
	@DBField(column="user_name")
	public String userName;
	
	@DBField(column="project_name")
	public String projectName;
}
