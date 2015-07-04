package co.fastcat.wms.dao;

import java.util.List;

import co.fastcat.wms.bean.DAOBean;
import co.fastcat.wms.bean.FileInfo;
import co.fastcat.wms.bean.FileInfo2;


public class FileInfoDAO extends Mapper<FileInfo>{
	
	public FileInfoDAO(){ }
	
	@Override
	public FileInfo createBean() {
		return new FileInfo();
	}
	
	public List<FileInfo> select(){
		String where = null;
		String orderby = "order by id";
		return select(where, orderby);
	}	
	
	public List<FileInfo> selectUserFile(String user_id){
		String where = "where user_sid = '" + user_id+"'";
		String orderby = "order by id";
		return select(where, orderby);
	}
	
	public List<DAOBean> selectUser(String user_id){
		String where = "where user_sid = '" + user_id+"'";
		String orderby = "order by id";
		String join = " left join project_info pInfo on A.project_id = pInfo.id left join user_info uInfo on A.user_sid = uInfo.serial_id ";
		String joinSelect = " pInfo.name as project_name, uInfo.user_name as user_name ";
		
		return select(where, orderby, join, joinSelect, FileInfo2.class);
	}
	
	public List<DAOBean> selectUserNProjectId(String user_id, String project_id){
		String where = "where user_sid = '" + user_id+"' and project_id = '" + project_id + "'" ;
		String orderby = "order by id";
		String join = " left join project_info pInfo on A.project_id = pInfo.id left join user_info uInfo on A.user_sid = uInfo.serial_id ";
		String joinSelect = " pInfo.name as project_name, uInfo.user_name as user_name ";
		
		return select(where, orderby, join, joinSelect, FileInfo2.class);
	}	
	
	public FileInfo select(String id){		
		String where = "where id = '"+id+"'";
		
		List<FileInfo> list = select(where, "");
		if(list.size() > 0){
			return list.get(0);
		}else{
			return null;
		}
	}
		
	public void clean(String id) {
		
		String where = "where id='"+id+"' ";
		
		delete(where);
	}
}
