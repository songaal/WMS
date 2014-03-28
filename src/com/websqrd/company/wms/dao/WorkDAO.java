package com.websqrd.company.wms.dao;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.WorkInfo;
import com.websqrd.company.wms.bean.WorkInfo2;
import com.websqrd.company.wms.bean.WorkList;
import com.websqrd.company.wms.webpage.DateUtil;
import com.websqrd.company.wms.webpage.WebUtil;

public class WorkDAO extends Mapper<WorkInfo> {

	@Override
	public WorkInfo createBean() {
		return new WorkInfo();
	}

	public String createWithSeq(WorkInfo entry){

		String start = DateUtil.getDateStr(entry.regdate);
		String end = DateUtil.getNextDateStr(entry.regdate);

		String where = "where user_sid='"+entry.userSID+"' and regdate >= '"+start+"' and regdate < '"+end+"'";
		String isExistWhere = where + " and pid = '"+entry.pid+"'";
		if(super.isExist(isExistWhere)){
			//존재하면 입력하지 않는다.
			return "-1";
		}else{
			String wid = super.create(entry);
			String set ="set seq = seq + 1";
			where += " and id != '"+wid+"'";
			super.update(set, where);
			return wid;
		}
		
	}
	
	//해당 프로젝트
	public List<WorkInfo> select(String pid){
		String where = "where pid = '"+pid+"'";
		return select(where, "order by seq asc");
	}
	
	//특정인의 해당일 작업내용.
	public List<DAOBean> select(String userSID, Date regdate, boolean isProjectExist){
		String start = DateUtil.getDateStr(regdate);
		String end = DateUtil.getNextDateStr(regdate);
		String where = "where user_sid='"+userSID+"' and regdate >= '"+start+"' and regdate < '"+end+"'";
		//isProjectExist -1이면 미분류 task들.
		if(isProjectExist){
			where += " and pid != -1";
		}else{
			where += " and pid = -1";
		}
		logger.debug("where >> {}", where);
		String orderby = "order by seq asc";
		String join = " left join project_info B on A.pid = B.id";
		String joinSelect = "B.name as project_name";
				
		return select(where, orderby, join, joinSelect, WorkInfo2.class);
	}
	
	public List<DAOBean> selectWeek(String userSID, Date regdate, boolean isProjectExist){
		List<Date> dateList = WebUtil.getListOfThisWeek(regdate);
		Date startDate = dateList.get(0);
		Date endDate = dateList.get(dateList.size() - 1);
		
		String start = DateUtil.getDateStr(startDate);
		String end = DateUtil.getNextDateStr(endDate);
		String where = "where user_sid='"+userSID+"' and regdate >= '"+start+"' and regdate < '"+end+"'";
		if(isProjectExist){
			where += " and pid != -1";
		}else{
			where += " and pid = -1";
		}
		logger.debug("where >> {}", where);
		String orderby = "order by regdate asc, seq asc";
		String join = " left join project_info B on A.pid = B.id";
		String joinSelect = "B.name as project_name";
				
		return select(where, orderby, join, joinSelect, WorkInfo2.class);
	}
	
	public int deleteWithSeq(WorkInfo entry) {
		String start = DateUtil.getDateStr(entry.regdate);
		String end = DateUtil.getNextDateStr(entry.regdate);
		
		int deleted = super.delete(entry);
		
		if(deleted > 0){
			//삭제되었으면 seq보다 작은 데이터의 순위를 -1씩 해준다.
			String set = "set seq = seq - 1";
			String where = "where user_sid='"+entry.userSID+"' and regdate >= '"+start+"' and regdate < '"+end+"' and seq > "+entry.seq;
			
			super.update(set, where);
		}
		
		return deleted;
	}

	public boolean moveSeq(String userSID, Date regdate, int wid, int from, int to) {
		if(from < 0 || to < 0)
			return false;
		
		String start = DateUtil.getDateStr(regdate);
		String end = DateUtil.getNextDateStr(regdate);
		
		String set = null;
		String where = null;
		
		if(from < to){
			set = "set seq = seq - 1";
			where = "where user_sid='"+userSID+"' and regdate >= '"+start+"' and regdate < '"+end+"' and seq > "+from+" and seq <= "+to;
		}else{
			set = "set seq = seq + 1";
			where = "where user_sid='"+userSID+"' and regdate >= '"+start+"' and regdate < '"+end+"' and seq >= "+to+" and seq < "+from;
		}
		super.update(set, where);
		
		set = "set seq = " + to;
		where = "where id = '"+wid+"'";
		
		return super.update(set, where) > 0;
	}
	
}
