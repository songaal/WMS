package co.fastcat.wms.bean;

import java.sql.Date;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("client_info")
public class ClientInfo extends DAOBean{
	public static String ClientA = "A"; //고객사
	public static String ClientB = "B"; //리셀러, 파트너사.
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int cid; //고객사번호
	
	@DBField(column="client_name")
	public String clientName; //고객사명
	
	@DBField(column="phone")
	public String phone;
	@DBField(column="address")
	public String address;
	@DBField(column="memo")
	public String memo;
	@DBField(column="type")
	public String type;
	
	@DBField(column="regdate", type=DBField.Type.Date, expression="NOW()", paramType=DBField.ParamType.nullparm)
	public Date regdate; //등록일
	
}