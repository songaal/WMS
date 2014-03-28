<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@include file="../inc/session.jsp"%>
<%
	SalesDAO salesDAO = new SalesDAO();
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action");
	Map<String, String[]> paramMap = request.getParameterMap();
	SalesInfo info = new SalesInfo();
	info.map(paramMap);
	
	if ("insert".equals(action)) {
		salesDAO.create(info);
	} else if ("modify".equals(action)) {
		List<String> excludeColumn = new ArrayList<String>();
		excludeColumn.add("reporter");
		salesDAO.modify(info, excludeColumn);
	} else if ("delete".equals(action)) {
		salesDAO.delete(info);
	}

	response.sendRedirect("index.jsp");
%>


