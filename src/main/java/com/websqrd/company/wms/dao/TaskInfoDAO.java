package com.websqrd.company.wms.dao;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.websqrd.company.wms.bean.ApprovalInfo;
import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.TaskInfo;


public class TaskInfoDAO extends Mapper<TaskInfo>{
	
	public TaskInfoDAO(){ }
	
	@Override
	public TaskInfo createBean() {
		return new TaskInfo();
	}
	
	public List<TaskInfo> select(){
		String where = null;
		String orderby = "order by user_sid";
		return select(where, orderby);
	}
	
	
	public TaskInfo select2(String userSID, Date taskDate){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
		String strTaskDate = sdf.format(taskDate);
		String where = "where user_sid = '"+userSID+"' and taskDate = '" + strTaskDate +"'";
		
		List<TaskInfo> list = select(where, "");
		if(list.size() > 0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	public List<DAOBean> selectAll(){
		String where = null;
		String orderby = "order by user_sid";
		
		String join = " left join user_info B on A.user_sid = B.serial_id";
		
		String joinSelect = "B.user_name, B.enter_date";
			
		return select(where, orderby, join, joinSelect, TaskInfo.class);
	}
	
	public void clean(String userSID) {
		
		String where = "where user_sid='"+userSID+"' ";
		
		delete(where);
	}
}
