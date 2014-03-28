package com.websqrd.company.wms.bean;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;
/**
 * 개인별 휴가 통계정보.
 * */
@DBTable("rest_info")
public class RestInfo extends DAOBean{
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id;
	@DBField(column="user_sid")
	public String userSID;
	
	@DBField(column="remain", type=DBField.Type.Float)
	public float remain;
	@DBField(column="get_year", type=DBField.Type.Float)
	public float getYear;
	@DBField(column="get_special", type=DBField.Type.Float)
	public float getSpecial;
	@DBField(column="spent_half", type=DBField.Type.Float)
	public float spentHalf;
	@DBField(column="spent_month", type=DBField.Type.Float)
	public float spentMonth;
	@DBField(column="spent_vacation", type=DBField.Type.Float)
	public float spentVacation;
	@DBField(column="spent_etc", type=DBField.Type.Float)
	public float spentETC;
}
