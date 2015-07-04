<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.UserDAO" %>
<%@include file="../inc/session.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	UserDAO dao = new UserDAO();
	
	String action = request.getParameter("action");
	
	if("updatePasswd".equals(action)){
		if(request.getMethod().equalsIgnoreCase("POST")){
			String oldPasswd = request.getParameter("oldPasswd");
			String newPasswd = request.getParameter("newPasswd");
			if(dao.updatePasswd(myUserInfo.serialId, oldPasswd, newPasswd)){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
	} else if("resetPasswd".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			if(dao.resetPasswd(myUserInfo.serialId)){
				out.println("{\"result\": true}");
				return;
			}
		}
	}
%>




