package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.ProjectRequest;
import com.websqrd.company.wms.bean.ProjectRequest2;


public class ProjectRequestDAO extends Mapper<ProjectRequest>{
	
	public ProjectRequestDAO(){ }
	
	@Override
	public ProjectRequest createBean() {
		return new ProjectRequest();
	}
	
	public List<ProjectRequest> select(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by id desc";
		return select(where, orderby);
	}
	//해당타입리스트
	public List<DAOBean> selectProject(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by A.regdate desc";
		
		String join = "left join user_info C on A.user_id = C.serial_id"
				+ " left join client_person D on A.client_person_id = D.id";
		
		String joinSelect = "CONCAT(C.user_name, ' ', C.title) as user_name, D.person_name as client_person_name";
		
		return select(where, orderby, join, joinSelect, ProjectRequest2.class);
	}
	
	public ProjectRequest2 selectRequest(String rId){
		String where = "where A.id = '" + rId + "'";
		String orderby = null;
		
		String join = "left join user_info C on A.user_id = C.serial_id"
				+ " left join client_person D on A.client_person_id = D.id";
		
		String joinSelect = "CONCAT(C.user_name, ' ', C.title) as user_name, D.person_name as client_person_name";
		
		select(where, orderby, join, joinSelect, ProjectRequest2.class);
		
		List<DAOBean> list = select(where, orderby, join, joinSelect, ProjectRequest2.class);
		if(list != null && list.size() > 0){
			return (ProjectRequest2) list.get(0);
		}
		
		return null;
	}
	
	//업무요청큐
	public List<DAOBean> selectRequestQueue(String reqDateStr){
		String where = "where status != '"+ ProjectRequest.STATUS_DONE +"' or due_date = '" + reqDateStr + "'";
		String orderby = "order by A.due_date, A.regdate";
		
		String join = "left join user_info C on A.user_id = C.serial_id"
				+ " left join client_person D on A.client_person_id = D.id";
		
		String joinSelect = "CONCAT(C.user_name, ' ', C.title) as user_name, D.person_name as client_person_name";
		
		return select(where, orderby, join, joinSelect, ProjectRequest2.class);
	}
	
	public List<DAOBean> selectRequestQueueAll(String status){
		String where = "where status = '"+status+"'";
		String orderby = "order by A.regdate desc";
		
		String join = "left join user_info C on A.user_id = C.serial_id"
				+ " left join client_person D on A.client_person_id = D.id";
		
		String joinSelect = "CONCAT(C.user_name, ' ', C.title) as user_name, D.person_name as client_person_name";
		
		return select(where, orderby, join, joinSelect, ProjectRequest2.class);
	}
	

}
