package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.ProjectInfo;
import com.websqrd.company.wms.bean.ProjectInfo2;


public class ProjectDAO extends Mapper<ProjectInfo>{
	
	public ProjectDAO(){ }
	
	@Override
	public ProjectInfo createBean() {
		return new ProjectInfo();
	}
	
//	public List<ProjectInfo> select(String status){
//		String where = "where status = '" + status + "'";
//		if(status == null){
//			where = null;
//		}
//		String orderby = "order by id desc";
//		return select(where, orderby);
//	}
	
	public List<ProjectInfo> selectAll(){	
	String orderby = "order by id desc";
	return select("", orderby);
	}
	
	public ProjectInfo get(ProjectInfo bean) {
		String where = "where name='"+bean.name+"'"+
				" and description='"+bean.description+"'"+
				" and solution='"+bean.solution+"'"+
				" and license='"+bean.license+"'"+
				" and startdate='"+bean.startDate+"'";
		String orderby = "order by id desc";
		String limit = "limit 1";
		List<ProjectInfo> list = select(where, orderby, limit);
		
		if(list!=null && list.size() > 0) {
			return list.get(0);
		}
		return null;
	}
	
	public List<ProjectInfo> selectTypeOutAlive(){
		String where = "where type = 'O' and status in ('" + ProjectInfo.STATUS_ONGOING + "', '" + ProjectInfo.STATUS_MAINTAIN + "')";
		String orderby = "order by id desc";
		return select(where, orderby);
	}
	
	public List<ProjectInfo> selectTypeInAlive(){
		String where = "where type = 'I' and status in ('" + ProjectInfo.STATUS_ONGOING + "', '" + ProjectInfo.STATUS_MAINTAIN + "')";
		String orderby = "order by id desc";
		return select(where, orderby);
	}
	
	//외부프로젝트 해당타입리스트
	public List<ProjectInfo> selectTypeOutStatus(String status){
		String where = "where type = 'O' and status = '" + status + "'";
		if(status == null){
			where = "where type = 'O'";
		}
		String orderby = "order by id desc";
		
		return select(where, orderby);
	}
	public List<DAOBean> selectTypeOutStatus2(String status){
		String where = "where A.type = 'O' and A.status = '" + status + "'";
		if(status == null){
			where = "where A.type = 'O'";
		}
		String orderby = "order by A.id desc";
		
		String join = " left join client_info B on A.client_id = B.id"
				+ " left join client_person C on A.client_person_id = C.id"
				+ " left join client_info D on A.reseller_id = D.id"
				+ " left join client_person E on A.reseller_person_id = E.id"
				+ " left join user_info F on A.pm_id = F.serial_id";
		
		String joinSelect = "F.user_name as pm_name, F.serial_id as pm_id" +
				", B.client_name as client_name, C.person_name as client_person_name, C.cell_phone as client_cell_phone, C.phone as client_phone, C.email as client_email" +
				", D.client_name as reseller_name, E.person_name as reseller_person_name, E.cell_phone as reseller_cell_phone, E.phone as reseller_phone, E.email as reseller_email";
		
		return select(where, orderby, join, joinSelect, ProjectInfo2.class);
	}
	
	//내부프로젝트 전체리스트
	public List<ProjectInfo> selectTypeInStatus(String status){
		String where = "where A.type = 'I' and status = '" + status + "'";
		if(status == null){
			where = "where A.type = 'I'";
		}
		String orderby = "order by id desc";
		return select(where, orderby);
	}

	public ProjectInfo2 selectTypeOut(String pId){
		String where = "where A.id = '" + pId + "'";
		String orderby = null;
		
		String join = " left join client_info B on A.client_id = B.id"
				+ " left join client_person C on A.client_person_id = C.id"
				+ " left join client_info D on A.reseller_id = D.id"
				+ " left join client_person E on A.reseller_person_id = E.id"
				+ " left join user_info F on A.pm_id = F.serial_id";
		
		String joinSelect = "F.user_name as pm_name, F.serial_id as pm_id" +
				", B.client_name as client_name, C.person_name as client_person_name, C.cell_phone as client_cell_phone, C.phone as client_phone, C.email as client_email" +
				", D.client_name as reseller_name, E.person_name as reseller_person_name, E.cell_phone as reseller_cell_phone, E.phone as reseller_phone, E.email as reseller_email";
		
		List<DAOBean> list = select(where, orderby, join, joinSelect, ProjectInfo2.class);
		if(list != null && list.size() > 0){
			return (ProjectInfo2) list.get(0);
		}
		
		return null;
	}
	
	public ProjectInfo selectTypeIn(String pId){
		String where = "where id = '" + pId + "'";
		String orderby = null;
		
		List<ProjectInfo> list = select(where, orderby);
		if(list != null && list.size() > 0){
			return list.get(0);
		}
		
		return null;
	}
	

}
