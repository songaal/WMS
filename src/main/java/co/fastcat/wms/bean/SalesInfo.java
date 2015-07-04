package co.fastcat.wms.bean;

import java.sql.Date;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("sales_info")
public class SalesInfo extends DAOBean{

	@DBField(column="id", type=DBField.Type.Int, paramType=DBField.ParamType.auto, pk=true)
	public int id = -1;
	@DBField(column="regdate", type=DBField.Type.Date)
	public Date regdate;
	@DBField(column="company")
	public String company;
	@DBField(column="memo")
	public String memo;
	@DBField(column="person")
	public String person;
	@DBField(column="contact")
	public String contact;
	@DBField(column="method")
	public String method;
	@DBField(column="reporter")
	public String reporter;
	@DBField(column="budget")
	public String budget;
	@DBField(column="startday")
	public String startDay;
	@DBField(column="result")
	public String result;
	@DBField(column="resultmemo")
	public String resultMemo;
	@DBField(column="resultdate", type=DBField.Type.Date)
	public Date resultDate;
	
}
