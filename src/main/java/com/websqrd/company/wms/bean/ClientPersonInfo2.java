package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("client_person")
public class ClientPersonInfo2 extends ClientPersonInfo{
	
	@DBField(column="client_name")
	public String clientName; //소속회사명
}
