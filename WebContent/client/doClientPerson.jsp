<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@include file="../inc/session.jsp"%>
<%
	ClientPersonDAO clientPersonDAO = new ClientPersonDAO();
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action");
	String type = request.getParameter("type");
	Map<String, String[]> paramMap = request.getParameterMap();
	ClientPersonInfo info = new ClientPersonInfo();
	info.map(paramMap);
try {
	if ("insert".equals(action)) {
		clientPersonDAO.create(info);
	} else if ("modify".equals(action)) {
		List<String> excludeColumn = new ArrayList<String>();
		//등록일과 타입은 변경되지 않는다.
		excludeColumn.add("regdate");
		excludeColumn.add("type");
		clientPersonDAO.modify(info, excludeColumn);
	} else if ("delete".equals(action)) {
		clientPersonDAO.delete(info);
	}
} catch (Exception e) {
	out.print(e.getMessage());
}
	response.sendRedirect(request.getHeader("referer"));
%>


