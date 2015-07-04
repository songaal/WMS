package co.fastcat.wms.bean;

import java.util.Date;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("schedule_info")
public class ScheduleInfo extends DAOBean{
	
	@DBField(column="id", type=DBField.Type.Int, paramType=DBField.ParamType.auto, pk=true)
	public int id;
	@DBField(column="user_sid")
	public String userSID;
	@DBField(column="start", type=DBField.Type.DateTime)
	public Date startTime;
	@DBField(column="end", type=DBField.Type.DateTime)
	public Date endTime;
	@DBField(column="all_day", type=DBField.Type.Int)
	public int allDay;
	@DBField(column="title")
	public String title;
}
