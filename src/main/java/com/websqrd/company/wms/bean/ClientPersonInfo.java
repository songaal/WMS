package com.websqrd.company.wms.bean;

import java.sql.Date;
import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("client_person")
public class ClientPersonInfo extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id; //고객번호
	@DBField(column="client_id", type=DBField.Type.Int)
	public int cid; //고객사번호
	@DBField(column="person_name")
	public String personName; //고객명
	
	@DBField(column="phone")
	public String phone;
	@DBField(column="cell_phone")
	public String cellPhone;
	@DBField(column="email")
	public String email;
	@DBField(column="memo")
	public String memo;
	@DBField(column="type")
	public String type;
	
	@DBField(column="regdate", type=DBField.Type.Date, expression="NOW()", paramType=DBField.ParamType.nullparm)
	public Date regdate; //등록일
	
	public String clientName; //회사명.
	
}
