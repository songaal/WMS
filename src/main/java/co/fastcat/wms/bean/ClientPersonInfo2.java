package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("client_person")
public class ClientPersonInfo2 extends ClientPersonInfo{
	
	@DBField(column="client_name")
	public String clientName; //소속회사명
}
