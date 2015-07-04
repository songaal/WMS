package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;


public class UserReport2 extends UserReport{

	@DBField(column="user_name")
	public String userName;
	@DBField(column="report_to_name")
	public String reportToName;
	@DBField(column="reference_to_name")
	public String referenceToName;
	
}
