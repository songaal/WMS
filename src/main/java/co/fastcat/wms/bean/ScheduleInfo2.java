package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("schedule_info")
public class ScheduleInfo2 extends ScheduleInfo{
	
	@DBField(column="user_name")
	public String userName; //이름
}
