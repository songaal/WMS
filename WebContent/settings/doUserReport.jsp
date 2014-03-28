<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@include file="../inc/session.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	UserReportDAO dao = new UserReportDAO();
	
	Map<String, String[]> paramMap = request.getParameterMap();
	UserReport userReport = new UserReport();
	userReport.map(paramMap);
	
	String action = request.getParameter("action");
	
	out.println("action = "+action);
	
	if("modify".equals(action)){
		out.println("userInfo.serialId = "+userReport.userSID);
		if(userReport.userSID != null){
			int updated = dao.modify(userReport);
			if(updated == 1){
				//성공
			}else{
				//실패
			}
		}
	}
	
	response.sendRedirect("report.jsp");
	
%>




