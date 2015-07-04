package co.fastcat.wms.bean;

import java.sql.Date;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("project_info")
public class ProjectInfo extends DAOBean{
	
	public static String TYPE_ALL = "A"; //구분 없이 모두 보기.
	public static String TYPE_OUT_PROJECT = "O"; //외부 프로젝트
	public static String TYPE_IN_PROJECT = "I"; //내부 개발 프로젝트
	
	public static String STATUS_ALL = "A"; //구분 없이 모두 보기.
	public static String STATUS_ONGOING = "B"; //진행중.
	public static String STATUS_DONE = "C"; //완료
	public static String STATUS_MAINTAIN = "D"; //유지보수
	public static String STATUS_DUMP = "E"; //계약종료.
	
	@DBField(column="id", pk=true, type=DBField.Type.Int, paramType=DBField.ParamType.auto)
	public int pid; //프로젝트 번호
	@DBField(column="pm_id")
	public String pmId; //웹스퀘어드 담당자
	@DBField(column="sales_id", type=DBField.Type.Int)
	public int salesId; //
	@DBField(column="client_id", type=DBField.Type.Int)
	public int clientId; //고객사 아이디.
	@DBField(column="client_person_id", type=DBField.Type.Int)
	public int clientPersonId; //고객사 아이디.
	@DBField(column="reseller_id", type=DBField.Type.Int)
	public int resellerId; //리셀러사 아이디.
	@DBField(column="reseller_person_id", type=DBField.Type.Int)
	public int resellerPersonId; //리셀러사 아이디.
	@DBField(column="name")
	public String name; //프로젝트명
	@DBField(column="description")
	public String description;
	@DBField(column="startdate", type=DBField.Type.Date)
	public Date startDate; //시작일
	@DBField(column="enddate", type=DBField.Type.Date)
	public Date endDate; //종료일
	@DBField(column="status")
	public String status;
	
	@DBField(column="solution")
	public String solution;
	@DBField(column="license")
	public String license;
	
	@DBField(column="mstartdate", type=DBField.Type.Date)
	public Date mStartDate; //유지보수시작일
	@DBField(column="menddate", type=DBField.Type.Date)
	public Date mEndDate; //유지보수종료일
	
	@DBField(column="type")
	public String type; //내부프로젝트 : I, 외부 : O
}
