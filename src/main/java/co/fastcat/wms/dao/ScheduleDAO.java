package co.fastcat.wms.dao;

import java.util.Date;
import java.util.List;

import co.fastcat.wms.webpage.WebUtil;
import co.fastcat.wms.bean.DAOBean;
import co.fastcat.wms.bean.ScheduleInfo;
import co.fastcat.wms.bean.ScheduleInfo2;


public class ScheduleDAO extends Mapper<ScheduleInfo>{
	
	public ScheduleDAO(){ }
	
	@Override
	public ScheduleInfo createBean() {
		return new ScheduleInfo();
	}
	
	public ScheduleInfo select(String id){
		String where = "where id = '"+ id +"'";
		
		List<ScheduleInfo> list = select(where, null);
		if(list.size() > 0){
			return list.get(0);
		}else{
			return null;
		}
	}
	public List<DAOBean> selectWeek(Date date){
		
		Date[] range = WebUtil.getRangeOfThisWeek(date);
		String startStr = WebUtil.toDashedDateString(range[0]);
		String endStr = WebUtil.toDashedDateString(range[1]);
		
		String where = "where (A.start >= '"+ startStr +"' and A.start < '"+ endStr +"') or (A.end >= '"+ startStr +"' and A.end < '"+ endStr +"')";
		String orderby = "order by A.start";
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as user_name";
		String join = "left join user_info B on A.user_sid = B.serial_id";
		
		return select(where, orderby, join, joinSelect, ScheduleInfo2.class);
		
	}
	
	public List<DAOBean> selectMonth(int year, int month){
		String monthStr = month < 10 ? "0"+month : ""+month;
		String startStr = year+"-"+monthStr+"-01"; //날짜는 1일로 고정.
		
		//다음달.
		if(month == 12){
			year++;
			month = 1;
		}else{
			month++;
		}
		String nextMonthStr = month < 10 ? "0"+month : ""+month;
		String endStr = year+"-"+nextMonthStr+"-01"; //날짜는 1일로 고정.
		
		String where = "where (A.start >= '"+ startStr +"' and A.start < '"+ endStr +"') or (A.end >= '"+ startStr +"' and A.end < '"+ endStr +"')";
		String orderby = "order by A.start";
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as user_name";
		String join = "left join user_info B on A.user_sid = B.serial_id";
		
		return select(where, orderby, join, joinSelect, ScheduleInfo2.class);
	}
	
	public boolean delete(String id, String userSID){
		String where = "where id='"+id+"' and user_sid = '"+userSID+"'"; 
		
		return super.delete(where) > 0;
	}
}