<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.ClientInfo" %>
<%@ page import="co.fastcat.wms.dao.ClientDAO" %>
<%@include file="../inc/session.jsp"%>
<%
	ClientDAO clientDAO = new ClientDAO();
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action");
	String type = request.getParameter("type");
	Map<String, String[]> paramMap = request.getParameterMap();
	ClientInfo info = new ClientInfo();
	info.map(paramMap);
	
	if ("insert".equals(action)) {
		clientDAO.create(info);
	} else if ("modify".equals(action)) {
		List<String> excludeColumn = new ArrayList<String>();
		//등록일과 타입은 변경되지 않는다.
		excludeColumn.add("regdate");
		excludeColumn.add("type");
		clientDAO.modify(info, excludeColumn);
	} else if ("delete".equals(action)) {
		clientDAO.delete(info);
	}
	
	response.sendRedirect(request.getHeader("referer"));
%>


