package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.UserReport;
import com.websqrd.company.wms.bean.UserReport2;

public class UserReportDAO extends Mapper<UserReport> {

	@Override
	public UserReport createBean(){
		return new UserReport();
	}
	
	public UserReport2 select(String userSID){
		
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as user_name" +
				", CONCAT(C.user_name, ' ', C.title) as report_to_name" +
				", CONCAT(D.user_name, ' ', D.title) as reference_to_name";
		
		String join = " inner join user_info Z on A.user_sid = Z.serial_id" +
				" left join user_info B on A.user_sid = B.serial_id" +
				" left join user_info C on A.report_to = C.serial_id" +
				" left join user_info D on A.reference_to = D.serial_id";
		
		String orderby = "order by A.user_sid";
		
		String where = "where A.user_sid = '"+userSID+"'";
		List<DAOBean> list = select(where, orderby, join, joinSelect, UserReport2.class);
		if(list.size() > 0){
			return (UserReport2) list.get(0);
		}else{
			return null;
		}
	}

	public List<DAOBean> selectAll(){
		
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as user_name" +
				", CONCAT(C.user_name, ' ', C.title) as report_to_name" +
				", CONCAT(D.user_name, ' ', D.title) as reference_to_name";
		
		String join = "left join user_info B on A.user_sid = B.serial_id" +
				" left join user_info C on A.report_to = C.serial_id" +
				" left join user_info D on A.reference_to = D.serial_id";
		
		String orderby = "order by A.user_sid";
		return select(null, orderby, join, joinSelect, UserReport2.class);
	}

}
