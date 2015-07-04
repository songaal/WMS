package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("rest_data")
public class RestData2 extends RestData{
	
	@DBField(column="user_name")
	public String userName;
	
}
