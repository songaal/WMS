package co.fastcat.wms.bean;

import java.util.List;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("project_meeting")
public class ProjectMeeting2 extends ProjectMeeting{
	
	@DBField(column="user_name")
	public String userName;
	public List<String> websqrdNameList;
	public List<String> clientNameList;
}
