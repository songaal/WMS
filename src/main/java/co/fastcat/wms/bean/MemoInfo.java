package co.fastcat.wms.bean;

import java.sql.Timestamp;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("memo_info")
public class MemoInfo extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id;
	@DBField(column="user_sid")
	public String userSID;
	@DBField(column="content")
	public String content;
	@DBField(column="regdate", type=DBField.Type.Timestamp)
	public Timestamp regdate; //등록일
}
