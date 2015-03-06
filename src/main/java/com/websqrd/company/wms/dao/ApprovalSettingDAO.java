package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.ApprovalSetting;


public class ApprovalSettingDAO extends Mapper<ApprovalSetting>{
	
	public ApprovalSettingDAO(){ }
	
	@Override
	public ApprovalSetting createBean() {
		return new ApprovalSetting();
	}
	//전체
	public List<ApprovalSetting> select(){
		String where = null;
		String orderby = "order by regdate desc, id desc";
		return select(where, orderby);
	}
	
	public ApprovalSetting selectType(String type){
		String where = "where type = '"+type+"'";
		if(type == null){
			return null;
		}
		List<ApprovalSetting> list = select(where, null);
		if(list != null && list.size() > 0){
			return (ApprovalSetting) list.get(0);
		}
		
		return null;
	}
	
	/**
	 * @aprvType 결재타입 A=휴가, B=비용 , C=도서
	 * @param step 단계. 1,2,3
	 * */
	public boolean hasApprovalAuth(String userSID, String aprvType, int step){
		String where = "where type = '"+aprvType+"'" + 
				" and res_user"+step+" = '"+ userSID +"'";
		
		List<ApprovalSetting> list = select(where, null);
		if(list != null && list.size() > 0){
			return true;
		}
		
		return false;
	}

}
