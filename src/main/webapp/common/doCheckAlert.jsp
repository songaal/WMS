<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.MessageInfo2" %>
<%@ page import="co.fastcat.wms.dao.ApprovalDAO" %>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>
<%@ page import="co.fastcat.wms.dao.MessageDAO" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>
<%@ page import="co.fastcat.wms.bean.ApprovalInfo2" %>
<%@include file="../inc/session.jsp"%>
<%
	Object timestampObj = session.getAttribute("MSG_CHECK_TIME");
	long timestamp = 0;
	if(timestampObj == null){
		timestamp = System.currentTimeMillis();
		session.setAttribute("MSG_CHECK_TIME", timestamp);
	}else{
		timestamp = (Long) timestampObj;
	}
	
	ApprovalDAO approvalDAO = new ApprovalDAO();
	
	MessageDAO messageDAO = new MessageDAO();
	List<DAOBean> newMessageList = messageDAO.selectUnreadAll(myUserInfo.serialId, timestamp);
	List<DAOBean> approvalResList = null;
	//if(myUserInfo.userType.contains(UserInfo.AUTH_APPROVAL)){
		//결재권한이 있는 사람만 확인.
		approvalResList = approvalDAO.selectApprovalWait(myUserInfo.serialId, timestamp);
	//}
	List<DAOBean> approvalDoneList = approvalDAO.selectMyApprovalList(myUserInfo.serialId, true, timestamp);
	
	boolean hasAlert = false;
	String alertText = "";
	
	int count = 1;
	for(int i=0; newMessageList != null && i< newMessageList.size(); i++){
		hasAlert = true;
		MessageInfo2 message = (MessageInfo2) newMessageList.get(i);
		if(i > 0){
			alertText += "\n";
		}
		alertText += (count++ +". "+message.senderName +"로부터 ["+ BusinessUtil.getTitleValue(message.title)+"] 업무연락이 도착했습니다.");
	}
	
	for(int i=0; approvalResList != null && i< approvalResList.size(); i++){
		if(hasAlert){
			alertText += "\n---------\n";
		}
		hasAlert = true;
		ApprovalInfo2 approvalInfo = (ApprovalInfo2) approvalResList.get(i);
		if(i > 0){
			alertText += "\n";
		}
		alertText += (count++ +". "+ approvalInfo.reqUserName+"의 "+ BusinessUtil.getApprovalTypeName(approvalInfo.type) +" 결재요청이 도착했습니다.");
	}
	
	for(int i=0; approvalDoneList != null && i< approvalDoneList.size(); i++){
		if(hasAlert){
			alertText += "\n---------\n";
		}
		hasAlert = true;
		ApprovalInfo2 approvalInfo = (ApprovalInfo2) approvalDoneList.get(i);
		if(i > 0){
			alertText += "\n";
		}
		alertText += (count++ +". "+ BusinessUtil.getApprovalTypeName(approvalInfo.type) +" 결재가 "+ BusinessUtil.getApprovalResultName(approvalInfo.status)+"되었습니다.");
	}
	
	
	if(hasAlert){
		
		//update check time
		timestamp = System.currentTimeMillis();
		session.setAttribute("MSG_CHECK_TIME", timestamp);
				
		//For Json validity
		//1. replace single back-slash quote with double back-slash
		//2. replace double quote with character '\"' 
		//4. replace linefeed with character '\n' 
		alertText = alertText.replaceAll("\\\\", "\\\\\\\\").replaceAll("\"", "\\\\\"").replaceAll("\t", "\\\\t").replaceAll("\r\n", "\\\\n").replaceAll("\n", "\\\\n").replaceAll("\r", "\\\\n");
%>
{ "result" : true, "message": "<%=alertText %>" }
<%
	}else{
%>
{ "result" : false }
<%		
	}

	
%>


