<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.UserReportDAO" %>
<%@ page import="co.fastcat.wms.bean.UserReport" %>
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




