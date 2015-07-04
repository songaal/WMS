package co.fastcat.wms.bean;

import java.sql.Timestamp;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("work_subject")
public class WorkSubject extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id;
	@DBField(column="wid", type=DBField.Type.Int)
	public int wid;
	@DBField(column="pid", type=DBField.Type.Int)
	public int pid;
	@DBField(column="user_sid")
	public String userSID;
	@DBField(column="title")
	public String title;
	@DBField(column="regdate", type=DBField.Type.Timestamp)
	public Timestamp regdate; //등록일
	@DBField(column="seq", type=DBField.Type.Int)
	public int seq;
	
}
