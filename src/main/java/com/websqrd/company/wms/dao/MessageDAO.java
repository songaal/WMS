package com.websqrd.company.wms.dao;

import java.util.Date;
import java.util.List;

import com.websqrd.company.wms.bean.DAOBean;
import com.websqrd.company.wms.bean.MessageInfo;
import com.websqrd.company.wms.bean.MessageInfo2;
import com.websqrd.company.wms.webpage.WebUtil;


public class MessageDAO extends Mapper<MessageInfo>{
	
	public MessageDAO(){ }
	
	@Override
	public MessageInfo createBean() {
		return new MessageInfo();
	}
	
	public MessageInfo2 readReceive(String userSID, String messageSID){
		
		String where = "where id = '"+messageSID+"' and (receiver = '"+userSID+"' or referencer = '"+userSID+"')";
		
		//중요! 읽은 시간을 업데이트한다.
		String set = "set receive_date = '"+WebUtil.toDateTimeString(new Date())+"'";
		String where2 = where + " and receive_date is null"; //처음시각만 기록하고 다음에 읽을때에는 skip
		super.update(set, where2);
		
		String join = "left join user_info B on A.sender = B.serial_id" +
				" left join user_info C on A.receiver = C.serial_id" +
				" left join user_info D on A.referencer = D.serial_id";
		
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as sender_name, CONCAT(C.user_name, ' ', C.title) as receiver_name, CONCAT(D.user_name, ' ', D.title) as referencer_name";
				
		List<DAOBean> list = select(where, null, join, joinSelect, MessageInfo2.class);
		if(list.size() > 0){
			return (MessageInfo2) list.get(0);
		}else{
			return null;
		}
	}
	public MessageInfo2 readSend(String userSID, String messageSID){
		String where = "where id = '"+messageSID+"' and sender = '"+userSID+"'";
		
		String join = "left join user_info B on A.sender = B.serial_id" +
				" left join user_info C on A.receiver = C.serial_id" +
				" left join user_info D on A.referencer = D.serial_id";
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as sender_name, CONCAT(C.user_name, ' ', C.title) as receiver_name, CONCAT(D.user_name, ' ', D.title) as referencer_name";
				
		List<DAOBean> list = select(where, null, join, joinSelect, MessageInfo2.class);
		if(list.size() > 0){
			return (MessageInfo2) list.get(0);
		}else{
			return null;
		}
	}
	
	//@param type "send" or "receive" 
	public List<DAOBean> selectAll(String userSID, String type){
		String where = null;
		String orderby = "order by user_sid";
		if(type.equals("send")){
			where = "where sender = '"+ userSID +"'";
			orderby = "order by send_date desc";
		}else if(type.equals("receive")){
			where = "where receiver = '"+ userSID +"' or referencer = '"+userSID+"'";
			orderby = "order by send_date desc";
		}
		
		String join = "left join user_info B on A.sender = B.serial_id" +
		" left join user_info C on A.receiver = C.serial_id" +
		" left join user_info D on A.referencer = D.serial_id";
		
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as sender_name, CONCAT(C.user_name, ' ', C.title) as receiver_name, CONCAT(D.user_name, ' ', D.title) as referencer_name";
			
		return select(where, orderby, join, joinSelect, MessageInfo2.class);
	}
	
	public List<DAOBean> selectUnreadAll(String userSID, long timestamp){
		String where = "where (receiver = '"+ userSID +"' or referencer = '"+userSID+"') and send_date >= '"+ WebUtil.toDateTimeString(new Date(timestamp)) +"' and receive_date is null";
		String orderby = null;
		
		String join = "left join user_info B on A.sender = B.serial_id";
		
		String joinSelect = "CONCAT(B.user_name, ' ', B.title) as sender_name, '' as receiver_name";
			
		return select(where, orderby, join, joinSelect, MessageInfo2.class);
	}
	
	
}
