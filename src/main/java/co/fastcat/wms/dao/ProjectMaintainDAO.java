package co.fastcat.wms.dao;

import java.util.List;

import co.fastcat.wms.bean.DAOBean;
import co.fastcat.wms.bean.ProjectMaintain;
import co.fastcat.wms.bean.ProjectMaintain2;


public class ProjectMaintainDAO extends Mapper<ProjectMaintain>{
	
	public ProjectMaintainDAO(){ }
	
	@Override
	public ProjectMaintain createBean() {
		return new ProjectMaintain();
	}
	
	public List<ProjectMaintain> select(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by A.maintain_date desc";
		return select(where, orderby);
	}
	//해당타입리스트
	public List<DAOBean> selectProject(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by A.maintain_date desc";
		
		String join = "left join user_info C on A.user_id = C.serial_id";
		String joinSelect = "C.user_name as user_name";
		
		return select(where, orderby, join, joinSelect, ProjectMaintain2.class);
	}
	
	public ProjectMaintain2 selectMeeting(String mId){
		String where = "where A.id = '" + mId + "'";
		String orderby = null;
		
		String join = "left join user_info C on A.user_id = C.serial_id";
		String joinSelect = "C.user_name as user_name";
		
		select(where, orderby, join, joinSelect, ProjectMaintain2.class);
		
		List<DAOBean> list = select(where, orderby, join, joinSelect, ProjectMaintain2.class);
		if(list != null && list.size() > 0){
			return (ProjectMaintain2) list.get(0);
		}
		
		return null;
	}
	

}
