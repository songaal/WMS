package co.fastcat.wms.bean;

import java.sql.Date;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;
/**
 * 개인의 휴가 사용,발급 건별 정보.
 * */
@DBTable("rest_data")
public class RestData extends DAOBean{
	
	public static String TYPE_ISSUE = "A"; //발급타입
	public static String TYPE_SPEND = "B"; //사용타입
	
	public static String CATEGORY_SPEND_MONTH = "A"; //월차
	public static String CATEGORY_SPEND_VACATION = "B"; //휴가
	public static String CATEGORY_SPEND_HALF = "C"; //반차
	public static String CATEGORY_SPEND_ETC = "D"; //기타
	
	public static String CATEGORY_ISSUE_YEAR = "Y"; //연차
	public static String CATEGORY_ISSUE_SPECIAL = "S"; //특별휴가
	
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id;
	@DBField(column="aprv_status")
	public String status;
	@DBField(column="user_sid")
	public String userSID;
	@DBField(column="type")
	public String type; //발급=A, 사용=B 구분 
	@DBField(column="category")
	public String category; //연차/반차/특별휴가...
	@DBField(column="memo")
	public String memo;
	
	@DBField(column="apply_date", type=DBField.Type.Date)
	public Date applyDate;
	@DBField(column="amount", type=DBField.Type.Float)
	public float amount;
	@DBField(column="regdate", type=DBField.Type.Date)
	public Date regdate;
	
}
