package co.fastcat.wms.dao;

import java.util.Date;
import java.util.List;

import co.fastcat.wms.bean.DAOBean;
import co.fastcat.wms.bean.WorkList2;
import co.fastcat.wms.webpage.DateUtil;
import co.fastcat.wms.webpage.WebUtil;
import co.fastcat.wms.bean.WorkList;

public class WorkListDAO extends Mapper<WorkList> {

	@Override
	public WorkList createBean() {
		return new WorkList();
	}
	
	//주간 프로젝트 업무들 초기화 
	public void createWeekWorkList(WorkList entry){
		Date regdate = entry.regdate;
		List<Date> dateList = WebUtil.getListOfThisWeek(regdate);
		
		for (int i = 0; i < dateList.size(); i++) {
			if(i >= 5){
				continue;//토,일요일 건너뜀.
			}
			Date date = dateList.get(i);
			entry.regdate = new java.sql.Date(date.getTime());
			super.create(entry, true);
		}
		
	}
	//해당 프로젝트
	public List<WorkList> select(String pid){
		String where = "where pid = '"+pid+"'";
		return select(where, "order by seq asc");
	}
	
	//특정인의 해당일 작업내용.
	public List<DAOBean> select(String userSID, Date regdate){
		String start = DateUtil.getDateStr(regdate);
		String end = DateUtil.getNextDateStr(regdate);
		String where = "where A.user_sid='"+userSID+"' and A.regdate >= '"+start+"' and A.regdate < '"+end+"'";
		//isProjectExist -1이면 미분류 task들.
		logger.debug("where >> {}", where);
		String orderby = null;//"order by seq asc";
		String join = " left join project_info B on A.pid = B.id" +
				" left join client_info C on B.client_id = C.id";
		String joinSelect = "CONCAT(B.name, ' ', C.client_name) as project_name";
				
		return select(where, orderby, join, joinSelect, WorkList2.class);
	}
	
	public List<Integer> selectWeekProjectList(String userSID, Date regdate){
		List<Date> dateList = WebUtil.getListOfThisWeek(regdate);
		Date startDate = dateList.get(0);
		Date endDate = dateList.get(dateList.size() - 1);
		String start = DateUtil.getDateStr(startDate);
		String end = DateUtil.getNextDateStr(endDate);
		String where = "where user_sid='"+userSID+"' and regdate >= '"+start+"' and regdate < '"+end+"'";
		String sql = "select distinct pid from " + stub.getBeanInfo().getTableName();
		sql = sql + " " + where; 
		
		return null;
	}
	public List<DAOBean> selectWeek(String userSID, Date regdate){
		List<Date> dateList = WebUtil.getListOfThisWeek(regdate);
		Date startDate = dateList.get(0);
		Date endDate = dateList.get(dateList.size() - 1);
		
		String start = DateUtil.getDateStr(startDate);
		String end = DateUtil.getNextDateStr(endDate);
		String where = "where A.user_sid='"+userSID+"' and A.regdate >= '"+start+"' and A.regdate < '"+end+"'";
		logger.debug("where >> {}", where);
		String orderby = "order by A.regdate desc";
		String join = " left join project_info B on A.pid = B.id"+
				" left join client_info C on B.client_id = C.id";
		String joinSelect = "CONCAT(B.name, ' ', C.client_name) as project_name";
				
		return select(where, orderby, join, joinSelect, WorkList2.class);
	}
	
	
}
