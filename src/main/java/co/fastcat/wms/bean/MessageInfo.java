package co.fastcat.wms.bean;

import java.sql.Timestamp;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("message_info")
public class MessageInfo extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id;
	
	@DBField(column="sender")
	public String sender;
	@DBField(column="receiver")
	public String receiver;
	@DBField(column="referencer")
	public String referencer;
	@DBField(column="title")
	public String title;
	@DBField(column="message")
	public String message;
	
	@DBField(column="send_date", type=DBField.Type.Timestamp)
	public Timestamp sendDate;
	@DBField(column="receive_date", type=DBField.Type.Timestamp)
	public Timestamp receiveDate;
	
}
