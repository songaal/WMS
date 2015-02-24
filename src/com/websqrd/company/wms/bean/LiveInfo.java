package com.websqrd.company.wms.bean;

import java.sql.Date;
import java.sql.Timestamp;

import com.websqrd.company.wms.annotation.DBField;
import com.websqrd.company.wms.annotation.DBTable;

@DBTable("live_info")
public class LiveInfo extends DAOBean{
	
	public static final String OK="K"; //정상근무
	public static final String OUTTER="T"; //외근
	public static final String LATE="L"; //지각
	public static final String REST="R"; //휴가
	public static final String HALF_REST="H"; //반차
	public static final String SPECIAL_WORK="S"; //휴일근무
	public static final String NIGHT_WORK="N"; //야간근무
	
	@DBField(column="serialId", pk=true)
	public String serialId; //사번
	@DBField(column="livedate", pk=true, type=DBField.Type.Date)
	public Date liveDate; //해당날짜
	@DBField(column="regtime", type=DBField.Type.Timestamp)
	public Timestamp regTime; //등록시각
	@DBField(column="check_in", type=DBField.Type.Timestamp)
	public Timestamp checkIn; //출근시각	
	@DBField(column="check_out", type=DBField.Type.Timestamp)
	public Timestamp checkOut; //퇴근시각
	@DBField(column="ipaddress")
    public String ipAddress; //출근 아이피
    @DBField(column="status")
	public String status; //상태
	@DBField(column="memo")
	public String memo; //메모/사유
}
