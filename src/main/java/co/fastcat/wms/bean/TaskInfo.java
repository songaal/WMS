package co.fastcat.wms.bean;

import java.sql.Date;
import java.sql.Timestamp;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("task_list")
public class TaskInfo extends DAOBean{

	@DBField(column="tid", type=DBField.Type.Int, paramType=DBField.ParamType.auto, pk=true)
	public int id = -1;
	
	@DBField(column="user_sid")
	public String userSid;
	
	@DBField(column="regdate", type=DBField.Type.Timestamp, expression="NOW()", paramType=DBField.ParamType.nullparm)
	public Timestamp regdate;
	
	@DBField(column="taskdate", type=DBField.Type.Date)
	public Date taskdate;	
	
	@DBField(column="content")
	public String content;
	
	@DBField(column="issue")
	public String issue;
	
	@DBField(column="flag", type=DBField.Type.Int)
	public int flag;	
}
