package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("work_info")
public class WorkInfo2 extends WorkInfo{
	
	@DBField(column="project_name")
	public String projectName;
	
}
