package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("message_info")
public class MessageInfo2 extends MessageInfo{
	@DBField(column="sender_name")
	public String senderName;
	@DBField(column="receiver_name")
	public String receiverName;
	@DBField(column="referencer_name")
	public String referencerName;
}
