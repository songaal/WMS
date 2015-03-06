<%@page import="java.sql.Date"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>

<%@include file="../inc/session.jsp"%>
<%
	out.println(request.getParameter("action"));

	request.setCharacterEncoding("utf-8");
	String action = request.getParameter("action");
	String pid = request.getParameter("pid");
	String statusFilter = request.getParameter("statusFilter");
	Map<String, String[]> paramMap = request.getParameterMap();
	
	ProjectWorkDAO projectWorkDAO = new ProjectWorkDAO();
		
	ProjectWork info = new ProjectWork();
	info.map(paramMap);
	
	if ("insert".equals(action)) {
		//입력시에만 히스토리에 남긴다.
		ProjectHistoryDAO projectHistoryDAO = new ProjectHistoryDAO();
		ProjectHistory history = new ProjectHistory();
		history.pid = info.pid;
		
		history.wid = Integer.parseInt(projectWorkDAO.create(info));		
		
		if ( info.content.length() > 256 )
			history.memo = info.content.substring(0,255);
		else
			history.memo = info.content;
		
		history.type = "작업내역";
		history.regdate = info.regdate;
		history.userId = info.userId;
		
		projectHistoryDAO.create(history);
		
	}else if ("insertAjax".equals(action)) {
		String key = projectWorkDAO.create(info);
		if(key != null){
			out.println("{ \"result\": true}");
		}else{
			out.println("{ \"result\": false}");
		}
		return;
	} else if ("modify".equals(action)) {
		projectWorkDAO.modify(info);
	} else if ("modifyByWork".equals(action)) {
		projectWorkDAO.modify(info);
		response.sendRedirect(pageFrom);
		return;
	} else if ("delete".equals(action)) {
		projectWorkDAO.delete(info);		
	} else if ("deleteByWork".equals(action)) {
		projectWorkDAO.delete(info);
		response.sendRedirect(pageFrom);
		return;
	} else if ("complete".equals(action) ){
		projectWorkDAO.complete(request.getParameter("wid"), request.getParameter("pid"));		
	}
	
	if(statusFilter==null) {
		response.sendRedirect("work.jsp?pid="+pid);
	} else {
		response.sendRedirect("work.jsp?pid="+pid+"&status="+statusFilter);
	}

%>
<%!
	
%>

