package co.fastcat.wms.bean;

import java.sql.Date;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("project_work")
public class ProjectWork extends DAOBean{
	
	public static String STATUS_READY = "A"; //등록
	public static String STATUS_WORKING = "B"; //작업중
	public static String STATUS_DONE = "C"; //완료
	
	public static String STATUS_READY_STRING = "등록"; //등록
	public static String STATUS_WORKING_STRING = "진행"; //작업중
	public static String STATUS_DONE_STRING = "완료"; //완료
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int wid;
	@DBField(column="project_id", type=DBField.Type.Int)
	public int pid;
	
	@DBField(column="request_id", type=DBField.Type.Int)
	public int rid;
	
	@DBField(column="user_id")
	public String userId;
	
	@DBField(column="content")
	public String content;
	
	@DBField(column="issue")
	public String issue;
	
	@DBField(column="regdate", type=DBField.Type.Date, expression="NOW()", paramType=DBField.ParamType.nullparm)
	public Date regdate;		
	
	@DBField(column="done_date", type=DBField.Type.Date)
	public Date doneDate;
	
	@DBField(column="status", type=DBField.Type.String, expression="'A'", paramType=DBField.ParamType.nullparm)
	public String status;
	
	public String getStatusString()
	{
		if ( status.equals(STATUS_READY) )
			return STATUS_READY_STRING;
		else if ( status.equals(STATUS_WORKING) ) 
			return STATUS_WORKING_STRING;
		else if ( status.equals(STATUS_DONE) ) 
			return STATUS_DONE_STRING;
		else 
			return "";
	}
}
