package co.fastcat.wms.dao;

import java.util.List;

import co.fastcat.wms.bean.DAOBean;
import co.fastcat.wms.bean.RestInfo;
import co.fastcat.wms.bean.RestInfo2;


public class RestDAO extends Mapper<RestInfo>{
	
	public RestDAO(){ }
	
	@Override
	public RestInfo createBean() {
		return new RestInfo();
	}
	
	public List<RestInfo> select(){
		String where = null;
		String orderby = "order by user_sid";
		return select(where, orderby);
	}
	
	public RestInfo select(String userSID){
		String where = "where user_sid = '"+userSID+"'";
		
		List<RestInfo> list = select(where, null);
		if(list.size() > 0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	public List<DAOBean> selectAll(){
		String where = null;
		String orderby = "order by user_sid";
		
		String join = " left join user_info B on A.user_sid = B.serial_id";
		
		String joinSelect = "B.user_name, B.enter_date";
			
		return select(where, orderby, join, joinSelect, RestInfo2.class);
	}
	
	public void clean(String userSID) {
		
		String where = "where user_sid='"+userSID+"' ";
		
		delete(where);
	}
}
