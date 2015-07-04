package co.fastcat.wms.dao;

import java.util.List;

import co.fastcat.wms.bean.ApprovalInfo;
import co.fastcat.wms.bean.DAOBean;
import co.fastcat.wms.bean.RestData;
import co.fastcat.wms.bean.RestData2;


public class RestDataDAO extends Mapper<RestData>{
	
	public RestDataDAO(){ }
	
	@Override
	public RestData createBean() {
		return new RestData();
	}
	
	public RestData2 select(String id){
		String where = "where id = '"+ id +"'";
		String orderby = null;
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as user_name";
		String join = "left join user_info B on A.user_sid = B.serial_id";
		
		List<DAOBean> list = select(where, orderby, join, joinSelect, RestData2.class);
		if(list.size() > 0){
			return (RestData2) list.get(0);
		}else{
			return null;
		}
	}
	
	//상신 결제상태
	public List<RestData> selectApproval(String userSID, String status, String type){
		if(userSID == null){
			return null;
		}
		String where = "where user_sid = '" + userSID + "' and aprv_status='" + status + "' and type = '" + type + "'";
		String orderby = "order by regdate desc";
		return select(where, orderby);
	}
		
	//발급 히스토리.
	public List<RestData> selectIssue(String userSID){
		return selectUserType(userSID, RestData.TYPE_ISSUE);
	}
	//사용 히스토리.
	public List<RestData> selectSpent(String userSID){
		return selectUserType(userSID, RestData.TYPE_SPEND);
	}
	public List<RestData> selectUserType(String userSID, String type){
		if(userSID == null){
			return null;
		}
		String where = "where user_sid = '" + userSID + "' and aprv_status='" + ApprovalInfo.STATUS_APRVD + "' and type = '" + type + "'";
		String orderby = "order by apply_date desc";
		return select(where, orderby);
	}
	
	public boolean updateApprovalStatus(String id, String aprvStatus){
		String set = "set aprv_status = '"+ aprvStatus +"'";
		String where = "where id = "+id;
		return update(set, where) > 0;
	}
}
