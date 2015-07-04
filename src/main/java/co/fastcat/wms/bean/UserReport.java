package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("user_report")
public class UserReport extends DAOBean{
	
	@DBField(column="user_sid", pk=true)
	public String userSID;
	@DBField(column="report_to")
	public String reportTo;
	@DBField(column="reference_to")
	public String referenceTo;
	@DBField(column="another_list")
	public String anotherList;
	
}
