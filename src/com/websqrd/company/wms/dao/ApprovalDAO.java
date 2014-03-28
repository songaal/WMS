package com.websqrd.company.wms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import com.websqrd.company.wms.bean.ApprovalInfo;
import com.websqrd.company.wms.bean.ApprovalInfo2;
import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.webpage.WebUtil;


public class ApprovalDAO extends Mapper<ApprovalInfo>{
	
	public ApprovalDAO(){ }
	
	@Override
	public ApprovalInfo createBean() {
		return new ApprovalInfo();
	}
	
	public ApprovalInfo2 select(String id){
		String where = "where id = '"+ id +"'";
		String orderby = null;
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as req_user_name" +
				", CONCAT(C.user_name, ' ', C.title) as res_user_name1" +
				", CONCAT(D.user_name, ' ', D.title) as res_user_name2" +
				", CONCAT(E.user_name, ' ', E.title) as res_user_name3";
		String join = "left join user_info B on A.req_user = B.serial_id" +
				" left join user_info C on A.res_user1 = C.serial_id" +
				" left join user_info D on A.res_user2 = D.serial_id" +
				" left join user_info E on A.res_user3 = E.serial_id";
		
		
		List<DAOBean> list = select(where, orderby, join, joinSelect, ApprovalInfo2.class);
		if(list.size() > 0){
			return (ApprovalInfo2) list.get(0);
		}else{
			return null;
		}
	}
	
	//전체
	public List<ApprovalInfo> select(){
		String where = null;
		String orderby = "order by regdate desc, id desc";
		return select(where, orderby);
	}
	
	public ApprovalInfo selectType(String type){
		String where = "where type = '"+type+"'";
		if(type == null){
			return null;
		}
		List<ApprovalInfo> list = select(where, null);
		if(list != null && list.size() > 0){
			return (ApprovalInfo) list.get(0);
		}
		
		return null;
	}

	//결재자용 나의 결제를 기다리는 목록 반환.
	public List<DAOBean> selectApprovalWait(String userSID){
		return selectApprovalWait(userSID, 0);
	}
	//timestamp 는 실시간 alert 하는데 사용된다.
	public List<DAOBean> selectApprovalWait(String userSID, long timestamp){
		String where = null;
		
		if(timestamp > 0){
			String timeStr = WebUtil.toDateTimeString(new java.util.Date(timestamp));
			where = "where A.status = '" + ApprovalInfo.STATUS_WAIT + "'" +
					" and ((A.res_user1 = '"+userSID+"' and A.res_result1 = '"+ ApprovalInfo.STATUS_WAIT +"' and req_datetime >= '"+timeStr+"')" + 
					"		or (A.res_user2 = '"+userSID+"' and A.res_result2 = '"+ ApprovalInfo.STATUS_WAIT +"' and res_datetime1 >= '"+timeStr+"')" + 
					"		or (A.res_user3 = '"+userSID+"' and A.res_result3 = '"+ ApprovalInfo.STATUS_WAIT +"' and res_datetime2 >= '"+timeStr+"'))";
		}else{
			where = "where A.status = '" + ApprovalInfo.STATUS_WAIT + "'" +
					" and ((A.res_user1 = '"+userSID+"' and A.res_result1 = '"+ ApprovalInfo.STATUS_WAIT +"')" + 
					"		or (A.res_user2 = '"+userSID+"' and A.res_result2 = '"+ ApprovalInfo.STATUS_WAIT +"')" + 
					"		or (A.res_user3 = '"+userSID+"' and A.res_result3 = '"+ ApprovalInfo.STATUS_WAIT +"'))";
		}
		
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as req_user_name" +
				", CONCAT(C.user_name, ' ', C.title) as res_user_name1" +
				", CONCAT(D.user_name, ' ', D.title) as res_user_name2" +
				", CONCAT(E.user_name, ' ', E.title) as res_user_name3";
		String join = "left join user_info B on A.req_user = B.serial_id" +
				" left join user_info C on A.res_user1 = C.serial_id" +
				" left join user_info D on A.res_user2 = D.serial_id" +
				" left join user_info E on A.res_user3 = E.serial_id";
		String orderby = "order by A.req_datetime desc";
		return select(where, orderby, join, joinSelect, ApprovalInfo2.class);
	}

	//결재자용 결재완료.(반려포함)
	public List<DAOBean> selectApprovalDone(String userSID){
		//"where A.status != '" + ApprovalInfo.STATUS_WAIT + "'" +
		String where =  
				"where ((A.res_user1 = '"+userSID+"' and A.res_result1 != '"+ ApprovalInfo.STATUS_WAIT +"')" + 
				"		or (A.res_user2 = '"+userSID+"' and A.res_result2 != '"+ ApprovalInfo.STATUS_WAIT +"')" + 
				"		or (A.res_user3 = '"+userSID+"' and A.res_result3 != '"+ ApprovalInfo.STATUS_WAIT +"'))";
		
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as req_user_name" +
				", CONCAT(C.user_name, ' ', C.title) as res_user_name1" +
				", CONCAT(D.user_name, ' ', D.title) as res_user_name2" +
				", CONCAT(E.user_name, ' ', E.title) as res_user_name3";
		String join = "left join user_info B on A.req_user = B.serial_id" +
				" left join user_info C on A.res_user1 = C.serial_id" +
				" left join user_info D on A.res_user2 = D.serial_id" +
				" left join user_info E on A.res_user3 = E.serial_id";
		String orderby = "order by A.req_datetime desc";
		return select(where, orderby, join, joinSelect, ApprovalInfo2.class);
	}
	
	//상신자용 완료목록
	public List<DAOBean> selectMyApprovalList(String userSID, boolean isDone){
		return selectMyApprovalList(userSID, isDone, 0);
	}
	//timestamp 는 실시간 alert 하는데 사용된다.
	public List<DAOBean> selectMyApprovalList(String userSID, boolean isDone, long timestamp){

		String where = "where req_user = '"+ userSID +"'";
		
		if(timestamp > 0){
			String timeStr = WebUtil.toDateTimeString(new java.util.Date(timestamp));
			where += (" and A.status !='" + ApprovalInfo.STATUS_WAIT + "' and IFNULL(res_datetime3, IFNULL(res_datetime2, res_datetime1)) >= '"+timeStr+"'");
		}else{
			if(isDone){
				where += (" and A.status !='" + ApprovalInfo.STATUS_WAIT + "'");
			}else{
				where += (" and A.status ='" + ApprovalInfo.STATUS_WAIT + "'");
			}
		}
				
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as req_user_name" +
				", CONCAT(C.user_name, ' ', C.title) as res_user_name1" +
				", CONCAT(D.user_name, ' ', D.title) as res_user_name2" +
				", CONCAT(E.user_name, ' ', E.title) as res_user_name3";
		String join = "left join user_info B on A.req_user = B.serial_id" +
				" left join user_info C on A.res_user1 = C.serial_id" +
				" left join user_info D on A.res_user2 = D.serial_id" +
				" left join user_info E on A.res_user3 = E.serial_id";
		String orderby = "order by A.req_datetime desc";
		return select(where, orderby, join, joinSelect, ApprovalInfo2.class);
	}
	
	//휴가결재 
	//id = 결재 아이디
	//step 결재단계
	public int updateApproval(String id, int step, String memo, boolean hasNext){
		String set = "set res_result"+step+" = ?, res_datetime"+step+" = ?, result_memo"+step+" = ?";
		if(hasNext){
			set += ", res_user_step = res_user_step + 1";
			set += (", res_result"+ (step + 1) +" = ?");
		}else{
			//최종이면
			set +=", status = ?";
		}
		String where = "where id = "+id;
		String sql = "update "+ stub.getBeanInfo().getTableName()
				+ " " + set 
				+ " " + where;
		logger.debug("updateApproval SQL = {}", sql);
		Connection conn = getPool().getConnection();
		PreparedStatement stmt = null;
		try{
			stmt = conn.prepareStatement(sql);
			int parameterIndex = 1;
			stmt.setString(parameterIndex++, ApprovalInfo.STATUS_APRVD);
			stmt.setTimestamp(parameterIndex++, new Timestamp(System.currentTimeMillis()));
			stmt.setString(parameterIndex++, memo);
			if(hasNext){
				//다음 결재자는 대기상태.
				stmt.setString(parameterIndex++, ApprovalInfo.STATUS_WAIT);
			}else{
				stmt.setString(parameterIndex++, ApprovalInfo.STATUS_APRVD);
			}
			return stmt.executeUpdate();
		}catch(SQLException e){
			logger.error("", e);
			return -1;
		}catch(Exception e){
			logger.error("", e);
			return -2;
		}finally{
			close(stmt);
			getPool().returnConnection(conn);
		}
	}
	public int updateReject(String id, int step, String memo){
		String set = "set res_result"+step+" = ?, res_datetime"+step+" = ?, result_memo"+step+" = ?, status = ?";
		String where = "where id = "+id;
		String sql = "update "+ stub.getBeanInfo().getTableName()
				+ " " + set 
				+ " " + where;
		logger.debug("updateReject SQL = {}", sql);
		Connection conn = getPool().getConnection();
		PreparedStatement stmt = null;
		try{
			stmt = conn.prepareStatement(sql);
			int parameterIndex = 1;
			stmt.setString(parameterIndex++, ApprovalInfo.STATUS_REJECT);
			stmt.setTimestamp(parameterIndex++, new Timestamp(System.currentTimeMillis()));
			stmt.setString(parameterIndex++, memo);
			stmt.setString(parameterIndex++, ApprovalInfo.STATUS_REJECT);
			return stmt.executeUpdate();
		}catch(SQLException e){
			logger.error("", e);
			return -1;
		}catch(Exception e){
			logger.error("", e);
			return -2;
		}finally{
			close(stmt);
			getPool().returnConnection(conn);
		}
	}
}
