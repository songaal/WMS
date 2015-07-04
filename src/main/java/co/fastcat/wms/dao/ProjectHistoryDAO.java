package co.fastcat.wms.dao;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import co.fastcat.wms.bean.DAOBean;
import co.fastcat.wms.bean.ProjectHistory;
import co.fastcat.wms.bean.ProjectHistory2;


public class ProjectHistoryDAO extends Mapper<ProjectHistory>{
	
	public ProjectHistoryDAO(){ }
	
	@Override
	public ProjectHistory createBean() {
		return new ProjectHistory();
	}
	
	public List<DAOBean> selectLimit(int start, int length) {
		String join = "left join user_info C on A.user_id = C.serial_id left join project_info P on A.project_id=P.id";
		String joinSelect = "C.user_name as user_name, P.name as project_name";
		String orderby = "order by A.regdate desc";
		String limit = "limit "+start+","+length;
		return select("", orderby,join, joinSelect, limit, ProjectHistory2.class);
	}
	
	public List<DAOBean> selectByDate(Date date, int dayBefore) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.DAY_OF_MONTH, -dayBefore);
		c.set(Calendar.HOUR,0);
		c.set(Calendar.MINUTE,0);
		c.set(Calendar.SECOND, 0);
		String dateFrom = sdf.format(c.getTime());
		String dateTo = sdf.format(date);
		
		String join = "left join user_info C on A.user_id = C.serial_id";
		String joinSelect = "C.user_name as user_name, '' as project_name";
		
		String where = "where A.regdate >='"+dateFrom+"' AND A.regdate <='"+dateTo+"' ";
		String orderby = "order by A.regdate desc";
		
		return select(where, orderby, join, joinSelect, ProjectHistory2.class);
	}
	
	public List<ProjectHistory> select(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by A.regdate desc";
		return select(where, orderby);
	}
	//해당타입리스트
	public List<DAOBean> selectProject(String pid){
		String where = "where project_id = '" + pid + "'";
		String orderby = "order by A.regdate desc";
		
		String join = "left join user_info C on A.user_id = C.serial_id";
		String joinSelect = "C.user_name as user_name, '' as project_name";
		
		return select(where, orderby, join, joinSelect, ProjectHistory2.class);
	}
	
	public ProjectHistory2 selectMeeting(String mId){
		String where = "where A.id = '" + mId + "'";
		String orderby = null;
		
		String join = "left join user_info C on A.user_id = C.serial_id";
		String joinSelect = "C.user_name as user_name, '' as project_name";
		
		select(where, orderby, join, joinSelect, ProjectHistory2.class);
		
		List<DAOBean> list = select(where, orderby, join, joinSelect, ProjectHistory2.class);
		if(list != null && list.size() > 0){
			return (ProjectHistory2) list.get(0);
		}
		
		return null;
	}
	

}
