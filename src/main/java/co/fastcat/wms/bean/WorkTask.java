package co.fastcat.wms.bean;

import java.sql.Date;
import java.sql.Timestamp;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("work_task")
public class WorkTask extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id;
	@DBField(column="wid", type=DBField.Type.Int)
	public int wid;
	@DBField(column="pid", type=DBField.Type.Int)
	public int pid;
	@DBField(column="sid", type=DBField.Type.Int)
	public int sid;
	@DBField(column="user_sid")
	public String userSID;
	@DBField(column="memo")
	public String memo;
	@DBField(column="regdate", type=DBField.Type.Timestamp)
	public Timestamp regdate; //등록일
	@DBField(column="status", type=DBField.Type.Int)
	public int status;
	@DBField(column="time")
	public String time;
	@DBField(column="seq", type=DBField.Type.Int)
	public int seq;
	@DBField(column="duedate", type=DBField.Type.Date)
	public Date duedate; //등록일
	
}
