<%@page import="java.sql.Timestamp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.ApprovalSettingDAO" %>
<%@ page import="co.fastcat.wms.dao.RestDataDAO" %>
<%@ page import="co.fastcat.wms.dao.ApprovalDAO" %>
<%@ page import="co.fastcat.wms.bean.ApprovalSetting" %>
<%@ page import="co.fastcat.wms.bean.RestData" %>
<%@ page import="co.fastcat.wms.bean.ApprovalInfo" %>
<%@include file="../inc/session.jsp"%>
<%--
 * 휴가사용 결재요청
 --%>
<%
	request.setCharacterEncoding("UTF-8");
	RestDataDAO dao = new RestDataDAO();
	RestData data = new RestData();
	Map<String, String[]> paramMap = request.getParameterMap();
	data.map(paramMap);
	data.userSID = myUserInfo.serialId;
	data.type = RestData.TYPE_SPEND;
	data.status = ApprovalInfo.STATUS_WAIT;
	data.regdate = new java.sql.Date(System.currentTimeMillis());
	
	String action = request.getParameter("action");
	
	if("request".equals(action)){
		if(request.getMethod().equalsIgnoreCase("POST")){
	String id = dao.create(data);
	
	if(id != null) {
		ApprovalSettingDAO settingDAO = new ApprovalSettingDAO();
		ApprovalSetting setting = settingDAO.selectType(ApprovalInfo.TYPE_REST);
		
		ApprovalDAO approvalDAO = new ApprovalDAO();
		ApprovalInfo ainfo = new ApprovalInfo();
		ainfo.type = ApprovalInfo.TYPE_REST_SPEND;
		ainfo.aprvId = Integer.parseInt(id); 
		ainfo.reqUser = myUserInfo.serialId;
		ainfo.reqDatetime = new Timestamp(System.currentTimeMillis());
		ainfo.resUser1 = setting.resUser1;
		ainfo.resUser2 = setting.resUser2;
		ainfo.resUser3 = setting.resUser3;
	
		ainfo.resUserCount = setting.resUserCount;
		ainfo.resUserStep = 1;
		
		ainfo.resResult1 = ApprovalInfo.STATUS_WAIT;
		ainfo.status = ApprovalInfo.STATUS_WAIT;
		
		if(approvalDAO.create(ainfo) != null){
	out.println("{\"result\": true}");
	return;
		}
	}
		}
		out.println("{\"result\": false}");
	}
%>




