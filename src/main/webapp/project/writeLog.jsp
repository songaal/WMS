<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.bean.ProjectLogInfo" %>
<%@ page import="co.fastcat.wms.dao.ProjectLogDAO" %>

<%@include file="../inc/session.jsp"%>
<%
	ProjectLogDAO projectLogDAO = new ProjectLogDAO();

	String action = request.getParameter("action");
	Map<String, String[]> paramMap = request.getParameterMap();
	ProjectLogInfo projectLog = new ProjectLogInfo();
	projectLog.map(paramMap);
	if("writeLog".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")) {
			projectLog.userId = myUserInfo.serialId;
			if(projectLogDAO.create(projectLog) != null) {
				
				String pid = request.getParameter("projectId");
				
				String referer = request.getHeader("Referer");
				
				if(referer==null || "".equals(referer)) {
					referer = "/WMS/project/info.jsp?pid="+pid;
				}
				
				response.sendRedirect(referer);
				return;
			}
		}
	} else if("updateLog".equals(action)){
out.print("updateLog".equals(action));
		if(request.getMethod().equalsIgnoreCase("POST")) {
			
			projectLogDAO.modify(projectLog);
			
			String referer = request.getHeader("Referer");
			
			if(referer==null || "".equals(referer)) {
				referer = "/WMS/project/info.jsp?pid="+projectLog.projectId;
			}
			response.sendRedirect(referer);
			return;
		}
	}
%>
