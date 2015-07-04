package co.fastcat.wms.bean;

import java.sql.Timestamp;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("approval_info")
public class ApprovalInfo extends DAOBean{
	
	public static String STATUS_WAIT = "W"; //결재대기
	public static String STATUS_APRVD = "A"; //승인
	public static String STATUS_REJECT = "R"; //반려

	public static String TYPE_REST = "A"; //휴가
	public static String TYPE_REST_SPEND = "A"; //휴가사용
	public static String TYPE_REST_ISSUE = "a"; //휴가발급
	public static String TYPE_CHARGE = "B"; //비용청구
	public static String TYPE_BOOK = "C"; //도서
	public static String TYPE_COMMON = "D"; //일반결재
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int id;
	@DBField(column="aprv_type")
	public String type;
	@DBField(column="aprv_id", type=DBField.Type.Int)
	public int aprvId;
	
	@DBField(column="req_user")
	public String reqUser;
	
	@DBField(column="req_datetime", type=DBField.Type.Timestamp)
	public Timestamp reqDatetime;
	
	@DBField(column="res_user1")
	public String resUser1;
	@DBField(column="res_user2")
	public String resUser2;
	@DBField(column="res_user3")
	public String resUser3;
	
	@DBField(column="res_datetime1", type=DBField.Type.Timestamp)
	public Timestamp resDatetime1;
	@DBField(column="res_datetime2", type=DBField.Type.Timestamp)
	public Timestamp resDatetime2;
	@DBField(column="res_datetime3", type=DBField.Type.Timestamp)
	public Timestamp resDatetime3;
	
	@DBField(column="res_result1")
	public String resResult1;
	@DBField(column="res_result2")
	public String resResult2;
	@DBField(column="res_result3")
	public String resResult3;
	
	@DBField(column="result_memo1")
	public String resultMemo1;
	@DBField(column="result_memo2")
	public String resultMemo2;
	@DBField(column="result_memo3")
	public String resultMemo3;
	
	@DBField(column="status")
	public String status;
	
	@DBField(column="res_user_count", type=DBField.Type.Int)
	public int resUserCount;
	@DBField(column="res_user_step", type=DBField.Type.Int)
	public int resUserStep;
}
