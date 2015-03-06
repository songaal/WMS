package com.websqrd.company.wms.bean;

import java.sql.Date;
import java.sql.Timestamp;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("user_info")
public class UserInfo extends DAOBean{
	
	public static String AUTH_USER = "U"; // 일반 사용자.
	public static String AUTH_SALES = "S"; // 영업
	public static String AUTH_MANAGER = "M"; // 총무
	public static String AUTH_ADMIN = "A"; //사이트관리자
	public static String AUTH_APPROVAL = "P"; //결제권.
	
	public static String TYPE_WEBSQRD = "W"; //회사직원
	
	@DBField(column="serial_id", pk=true)
	public String serialId; //사번
	@DBField(column="user_id")
	public String userId; //아이디
	@DBField(column="passwd", expression="PASSWORD(?)")
	public String passwd; //암호.	
	@DBField(column="user_name")
	public String userName; //이름
	@DBField(column="user_type")
	public String userType; //관리자, 사용자여부 char(1)
	@DBField(column="part")
	public String part; //소속팀
	@DBField(column="title")
	public String title; //직급
	@DBField(column="enter_date", type=DBField.Type.Date)
	public Date enterDate; //입사일
	@DBField(column="avg_grade", type=DBField.Type.Int)
	public int avgGrade;
	@DBField(column="type")
	public String type; //외부/내부
	
}
