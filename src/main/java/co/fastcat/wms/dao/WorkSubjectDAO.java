package co.fastcat.wms.dao;

import java.util.Date;
import java.util.List;

import co.fastcat.wms.bean.WorkSubject;
import co.fastcat.wms.webpage.DateUtil;

public class WorkSubjectDAO extends Mapper<WorkSubject> {

	@Override
	public WorkSubject createBean() {
		return new WorkSubject();
	}

	public String createWithSeq(WorkSubject entry){
		
		String where = "where wid = '"+entry.wid+"'";
		
		String sid = super.create(entry);
		String set ="set seq = seq + 1";
		where += " and id != '"+sid+"'";
		super.update(set, where);
		return sid;
		
	}
	
	public List<WorkSubject> select(int wid){
		String where = "where wid='"+wid+"'";

		logger.debug("where >> {}", where);
		String orderby = "order by seq asc";
				
		return select(where, orderby);
	}
	
	//특정인의 해당일 작업내용.
	public List<WorkSubject> select(String userSID, Date regdate, int pid){
		String start = DateUtil.getDateStr(regdate);
		String end = DateUtil.getNextDateStr(regdate);
		String where = "where user_sid='"+userSID+"' and pid = '"+pid+"' and regdate >= '"+start+"' and regdate < '"+end+"'";

		logger.debug("where >> {}", where);
		String orderby = "order by seq asc";
				
		return select(where, orderby);
	}
	
	public int deleteWithSeq(WorkSubject entry) {
		
		int deleted = super.delete(entry);
		
		if(deleted > 0){
			//삭제되었으면 seq보다 작은 데이터의 순위를 -1씩 해준다.
			String set = "set seq = seq - 1";
			String where = "where wid = '"+entry.wid+"' and seq > "+entry.seq;
			super.update(set, where);
		}
		
		return deleted;
	}

	public boolean moveSeq(String wid, String sid, int from, int to) {
		if(from < 0 || to < 0)
			return false;
		
		String set = null;
		String where = null;
		
		if(from < to){
			set = "set seq = seq - 1";
			where = "where wid = '"+wid+"' and seq > "+from+" and seq <= "+to;
		}else{
			set = "set seq = seq + 1";
			where = "where wid = '"+wid+"' and seq >= "+to+" and seq < "+from;
		}
		super.update(set, where);
		
		set = "set seq = " + to;
		where = "where id = '"+sid+"'";
		
		return super.update(set, where) > 0;
	}
}
