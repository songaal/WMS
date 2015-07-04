package co.fastcat.wms.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import co.fastcat.wms.bean.WorkTask;

public class WorkTaskDAO extends Mapper<WorkTask> {

	@Override
	public WorkTask createBean() {
		return new WorkTask();
	}

	public String createWithSeq(WorkTask entry){
		
		String tid = super.create(entry);
		if(tid == null){
			return null;
		}
		
		//입력된 task를 제외한 이후 task들의 위치를 1씩 증가시킨다. 
//		String set ="set seq = seq + 1";
//		String where = "where wid = '"+entry.wid+"' and sid = '"+entry.sid+"' and seq >= "+entry.seq + " and id != '"+tid+"'";
		int seq = max("seq", "where wid = '"+entry.wid+"' and sid = '"+entry.sid+"'") + 1;
		
		String set ="set seq = "+seq;
		String where = "where id = '"+tid+"'";
		super.update(set, where);
		return tid;
		
	}
	
	public int migrateUndoneWorks(String userSID, String wid){
		//1. 체크리스트를 제외하고 status 0인것은 모두 가져온다.
		int count = update("set wid =  "+wid+", pid=-1, sid=-1", "where user_sid = '"+userSID+"' and status = 0 and wid != -1");
		if(count > 0){
			Connection conn = getPool().getConnection();
			Statement stmt = null;
			try{
				stmt = conn.createStatement();
				stmt.execute("select @i := -1");
				stmt.executeUpdate("update "+stub.getBeanInfo().getTableName()+" set seq=(select @i := @i + 1) where wid = "+wid);
			}catch(SQLException e){
				logger.error("", e);
			}catch(Exception e){
				logger.error("", e);
			}finally{
				close(stmt);
				getPool().returnConnection(conn);
			}
		}
		
		return count;
	}
	
	public List<WorkTask> select(int wid, int sid){
		String where = "where wid='"+wid+"' and sid = '"+sid+"'";

		logger.debug("where >> {}", where);
		String orderby = "order by seq asc";
				
		return select(where, orderby);
	}
	
	//특정인의 체크리스트를 가져온다.
	public List<WorkTask> selectCheckList(String userSID, String reqDateStr){
		String where = "where wid='-1' and user_sid = '"+ userSID +"' and ( status = 0 or duedate = '"+reqDateStr+"')";
		String orderby = "order by duedate asc, regdate asc";
				
		return select(where, orderby);
	}
	//특정인의 모든 체크리스트를 가져온다.
	public List<WorkTask> selectCheckList(String userSID){
		String where = "where wid = -1 and user_sid = '"+ userSID +"'";
		String orderby = "order by regdate desc, seq asc";
				
		return select(where, orderby);
	}
	
	
	//특정인의 해당일 작업내용.
//	public List<WorkTask> select(String userSID, Date regdate, int pid, int sid){
//		String start = DateUtil.getDateStr(regdate);
//		String end = DateUtil.getNextDateStr(regdate);
//		String where = "where user_sid='"+userSID+"' and pid = '"+pid+"' and regdate >= '"+start+"' and regdate < '"+end+"'";
//
//		logger.debug("where >> {}", where);
//		String orderby = "order by seq asc";
//				
//		return select(where, orderby);
//	}
	
	public int deleteWithSeq(WorkTask entry) {
		
		int deleted = super.delete(entry);
		
		if(deleted > 0){
			//삭제되었으면 seq보다 큰순위를 -1씩 해준다.
			moveSeq(entry.wid+"", entry.sid+"", null, entry.seq, -1);
//			String set = "set seq = seq - 1";
//			String where = "where wid='"+entry.wid+"' and sid = '"+entry.sid+"' and seq > "+entry.seq;
//			super.update(set, where);
		}
		
		return deleted;
	}
	
	public boolean moveSeq(String wid, String sid, String tid, int from, int to) {
		//from이 -1이면 신규유입, to가 -1이면 삭제.
		
		//움직인 위치가 같다면 즉시 true리턴.
		if(from == to){
			return true;
		}
		
		String set = null;
		String where = null;
		if(to == -1){
			//삭제. from 초과는 -1
			set = "set seq = seq - 1";
			where = "where wid='"+wid+"' and sid = '"+sid+"' and seq > "+from;
		}else if(from == -1){
			//신규유입. to 이상은 +1
			set = "set seq = seq + 1";
			where = "where wid='"+wid+"' and sid = '"+sid+"' and seq >= "+to;
		}else if(from < to){
			//move down
			set = "set seq = seq - 1";
			where = "where wid='"+wid+"' and sid = '"+sid+"' and seq > "+from+" and seq <= "+to;
		}else if(from > to){
			//move up
			set = "set seq = seq + 1";
			where = "where wid='"+wid+"' and sid = '"+sid+"' and seq >= "+to+" and seq < "+from;
		}
		super.update(set, where);
		
		set = "set seq = " + to;
		where = "where id = '"+tid+"'";
		
		if(to >= 0){
			//삭제가 아닐경우에만 update한다.
			return super.update(set, where) > 0;
		}else{
			return true;
		}
	}
	
	public boolean moveToAnotherSeq(String oldWid, String oldSid, String newWid, String newSid, String pid, String tid, int from, int to) {
		
		//1. 기존 sid내의 task들의 seq를 수정한다.
		if(moveSeq(oldWid, oldSid, tid, from, -1)){
			
			//2. task를 신규 sid와 신규 wid, seq로 update한다.
			String set = "set wid='"+ newWid +"', pid='"+ pid +"', sid='"+ newSid +"'";
			String where = "where id = '"+tid+"'";
			if(update(set, where) > 0){
				
				//3. 신규 sid내의 task들의 seq를 수정한다.
				if(moveSeq(newWid, newSid, tid, -1, to)){
					return true;
				}
			}
		}
		
		return false;
		
	}
	
	
	public int toggleTaskDone(String tid, boolean isCheckDone) {
		
		String set = "set status = " + (isCheckDone ? 1 : 0);
		String where = "where id = '"+tid+"'";
		return super.update(set, where);
		
	}
	
//	public int toggleTaskDone(String userSID, String tid, boolean isCheckDone) {
//		
//		if(moveCheckListSeq(userSID, tid, from, -1)){
//			String set = "set status = " + (isCheckDone ? 1 : 0) +" and seq = -1";
//			String where = "where id = '"+tid+"'";
//			return super.update(set, where);
//		}else{
//			return -1;
//		}
//			
//		
//	}
	
	//오늘것은 완료도 보여주므로 정렬이 어렵네..
	//체크리스트는 wid 가 -1이다.
	public boolean moveCheckListSeq(String userSID, String tid, int from, int to) {
		//움직인 위치가 같다면 즉시 true리턴.
		if(from == to){
			return true;
		}
		
		String set = null;
		String where = "where wid = -1 and user_sid = '"+ userSID +"' and status = 0";
		
		if(to == -1){
			//삭제. from 초과는 -1
			set = "set seq = seq - 1";
			where += " and seq > "+from;
		}else if(from == -1){
			//신규유입. to 이상은 +1
			set = "set seq = seq + 1";
			where += " and seq >= "+to;
		}else if(from < to){
			//move down
			set = "set seq = seq - 1";
			where += " and seq > "+from+" and seq <= "+to;
		}else if(from > to){
			//move up
			set = "set seq = seq + 1";
			where += " and seq >= "+to+" and seq < "+from;
		}
		super.update(set, where);
		
		set = "set seq = " + to;
		where = "where id = '"+tid+"'";
		
		if(to >= 0){
			//삭제가 아닐경우에만 update한다.
			return super.update(set, where) > 0;
		}else{
			return true;
		}
	}
}
