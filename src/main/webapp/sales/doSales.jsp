<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.SalesDAO" %>
<%@ page import="co.fastcat.wms.bean.SalesInfo" %>
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


