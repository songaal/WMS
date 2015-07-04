<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.bean.MessageInfo" %>
<%@ page import="co.fastcat.wms.dao.MessageDAO" %>
<%@ page import="co.fastcat.wms.bean.UserReport2" %>
<%@ page import="co.fastcat.wms.dao.UserReportDAO" %>

<%@include file="../inc/session.jsp"%>
<%
	MessageDAO messageDAO = new MessageDAO();

	String action = request.getParameter("action");
	Map<String, String[]> paramMap = request.getParameterMap();
	MessageInfo info = new MessageInfo();
	info.map(paramMap);
	info.sender = myUserInfo.serialId;//보내는 사람은 항상 자신으로..
	info.sendDate = new java.sql.Timestamp(System.currentTimeMillis());
	
	if ("sendMessage".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			if(messageDAO.create(info) != null){
				//out.println("{\"result\": true}");
				response.sendRedirect("/WMS/message/index.jsp?viewType=send");
				return;
			}
		}
		//out.println("{\"result\": false}");
		response.sendRedirect(pageFrom);
		
	} else if ("submitWorkCheck".equals(action)) {
		//업무시작/마감 보고.
		if(request.getMethod().equalsIgnoreCase("POST")){
			
			//info.sender 로 UserReport select 하여 보고대상자 찾기.
			UserReportDAO reportDAO = new UserReportDAO();
			UserReport2 userReport = reportDAO.select(info.sender);
			if(userReport != null){
				info.receiver = userReport.reportTo;
				info.referencer = userReport.referenceTo;
				logger.debug("submitWorkCheck to : {}, ref : {}", userReport.reportTo, userReport.referenceTo);
			}else{
				//이런 경우는 에러이나 일단 전송이 되도록 한다. 
				info.receiver = "W001";
			}
			if(messageDAO.create(info) != null){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
	}
	
%>

