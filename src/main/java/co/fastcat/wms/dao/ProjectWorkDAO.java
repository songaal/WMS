package co.fastcat.wms.dao;

import java.util.List;

import co.fastcat.wms.bean.DAOBean;
import co.fastcat.wms.bean.ProjectWork2;
import co.fastcat.wms.bean.ProjectWork;


public class ProjectWorkDAO extends Mapper<ProjectWork>{
	
	public ProjectWorkDAO(){ }
	
	@Override
	public ProjectWork createBean() {
		return new ProjectWork();
	}
	
	public List<ProjectWork> select(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by id desc";
		return select(where, orderby);
	}
	
	public List<ProjectWork> select(){		
		String orderby = "order by id desc";
		return select("", orderby);
	}
	
	public List<DAOBean> select2(){
		String orderby = "order by A.id desc";
		String join = " left join user_info on A.user_id = user_info.serial_id left join project_info on A.project_id = project_info.id ";
		String joinSelect = " user_info.user_name user_name, project_info.name project_name  ";
		return select("", orderby, join, joinSelect, ProjectWork2.class);
	}
	
	public List<DAOBean> select2ASC(){		
		String orderby = "order by A.id";
		String join = " left join user_info on A.user_id = user_info.serial_id left join project_info on A.project_id = project_info.id ";
		String joinSelect = " user_info.user_name user_name, project_info.name project_name  ";
		return select("", orderby, join, joinSelect, ProjectWork2.class);
	}
	
	public List<DAOBean> selectType(String type){		
		String where = " where A.status = '" + type + "'";
		if ( type.equals("Z") )
			where = "";
		String orderby = "order by A.id desc";
		String join = " left join user_info on A.user_id = user_info.serial_id left join project_info on A.project_id = project_info.id ";
		String joinSelect = " user_info.user_name user_name, project_info.name project_name  ";
		return select(where, orderby, join, joinSelect, ProjectWork2.class);
	}
	
	public List<DAOBean> selectTypeASC(String type){		
		String where = " where A.status = '" + type + "'";
		if ( type.equals("Z") )
			where = "";
		String orderby = "order by A.id";
		String join = " left join user_info on A.user_id = user_info.serial_id left join project_info on A.project_id = project_info.id ";
		String joinSelect = " user_info.user_name user_name, project_info.name project_name  ";
		return select(where, orderby, join, joinSelect, ProjectWork2.class);
	}
	
	public ProjectWork selectWork(String wid){
		String where = "where id = '" + wid + "'";		
		List<ProjectWork> list = select(where, "");
		if ( list.size() == 0  || list == null )
			return null;
		return list.get(0);
	}
	
	public int complete(String work_id, String project_id){
		String set = "set status = ? , done_date = now() ";
		String where = " where id = " + work_id + " and project_id = " + project_id;
		String[] values = new String[]{"C"};
		
		return update(set, where, values);		
	}
	
	public boolean isWorkExists(String project_id, String request_id) {
		String where = "where project_id = '" + project_id + "' and request_id = '" + request_id + "'" ;
		String orderby = "order by id desc";
		List<ProjectWork> list = select(where, orderby);
		
		if ( list.size() == 0 )
			return false;
		else
			return true;
	}
	
}
