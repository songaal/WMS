package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("project_maintain")
public class ProjectMaintain2 extends ProjectMaintain{
	
	@DBField(column="user_name")
	public String userName;
	
}
