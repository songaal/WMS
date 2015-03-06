package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("project_info")
public class ProjectInfo2 extends ProjectInfo{
	
	@DBField(column="pm_name")
	public String pmName; //웹스퀘어드 담당자명
	@DBField(column="client_name")
	public String clientName; //고객사명
	@DBField(column="client_person_name")
	public String clientPersonName; //고객담당자명
	@DBField(column="client_cell_phone")
	public String clientCellPhone;
	@DBField(column="client_phone")
	public String clientPhone;
	@DBField(column="client_email")
	public String clientEmail;
	
	@DBField(column="reseller_name")
	public String resellerName; //리셀러사명
	@DBField(column="reseller_person_name")
	public String resellerPersonName; //리셀러담당자명
	@DBField(column="reseller_cell_phone")
	public String resellerCellPhone;
	@DBField(column="reseller_phone")
	public String resellerPhone;
	@DBField(column="reseller_email")
	public String resellerEmail;
}
