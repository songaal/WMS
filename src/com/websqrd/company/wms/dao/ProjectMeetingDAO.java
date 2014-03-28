package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.ProjectMeeting;
import com.websqrd.company.wms.bean.ProjectMeeting2;


public class ProjectMeetingDAO extends Mapper<ProjectMeeting>{
	
	public ProjectMeetingDAO(){ }
	
	@Override
	public ProjectMeeting createBean() {
		return new ProjectMeeting();
	}
	
	public List<ProjectMeeting> select(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by id desc";
		return select(where, orderby);
	}
	
	//해당타입리스트
	public List<DAOBean> selectProject(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by A.regdate desc, id desc ";
		
		String join = "left join user_info C on A.user_id = C.serial_id";
		String joinSelect = "C.user_name as user_name";
		
		return select(where, orderby, join, joinSelect, ProjectMeeting2.class);
	}
	
	public ProjectMeeting2 selectMeeting(String mId){
		String where = "where A.id = '" + mId + "'";
		String orderby = null;
		
		String join = "left join user_info C on A.user_id = C.serial_id";
		String joinSelect = "C.user_name as user_name";
		
		select(where, orderby, join, joinSelect, ProjectMeeting2.class);
		
		List<DAOBean> list = select(where, orderby, join, joinSelect, ProjectMeeting2.class);
		if(list != null && list.size() > 0){
			return (ProjectMeeting2) list.get(0);
		}
		
		return null;
	}
	

}
