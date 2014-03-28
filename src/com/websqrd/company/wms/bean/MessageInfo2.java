package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("message_info")
public class MessageInfo2 extends MessageInfo{
	@DBField(column="sender_name")
	public String senderName;
	@DBField(column="receiver_name")
	public String receiverName;
	@DBField(column="referencer_name")
	public String referencerName;
}
