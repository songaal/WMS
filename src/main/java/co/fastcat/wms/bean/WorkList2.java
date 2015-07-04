package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("work_list")
public class WorkList2 extends WorkList{
	
	@DBField(column="project_name")
	public String projectName;
	
}
