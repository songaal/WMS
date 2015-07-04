package co.fastcat.wms.bean;

import java.sql.Date;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("work_list")
public class WorkList extends DAOBean{
	
	@DBField(column="user_sid", pk=true)
	public String userSID;
	@DBField(column="pid", pk=true, type=DBField.Type.Int)
	public int pid;
	@DBField(column="regdate", pk=true, type=DBField.Type.Date)
	public Date regdate; //등록일
	@DBField(column="content")
	public String content;
	
}
