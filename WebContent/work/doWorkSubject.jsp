<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>

<%@include file="../inc/session.jsp"%>
<%
	WorkSubjectDAO workSubjectDAO = new WorkSubjectDAO();
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action");
	Map<String, String[]> paramMap = request.getParameterMap();
	WorkSubject info = new WorkSubject();
	info.map(paramMap);
	info.userSID = myUserInfo.serialId;
	
	if ("addWorkSubject".equals(action)) {
		String sid = workSubjectDAO.createWithSeq(info);
		out.println("{\"sid\": \""+sid+"\"}");
		return;
	} else if ("modifyWorkSubject".equals(action)) {
		
		if(request.getMethod().equalsIgnoreCase("POST")){
			List<String> excludeList = new ArrayList<String>();
			excludeList.add("wid");
			excludeList.add("pid");
			excludeList.add("user_sid");
			excludeList.add("regdate");
			excludeList.add("seq");
			//Update memo, time
			if(workSubjectDAO.modify(info, excludeList) > 0) {
				out.println("{\"result\": true}");
				return;
			}
		}
		
		out.println("{\"result\": \"false\"}");
		
	} else if ("deleteWorkSubject".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			if(workSubjectDAO.deleteWithSeq(info) > 0){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
	} else if ("moveWorkSubject".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			String wid = request.getParameter("wid");
			String sid = request.getParameter("sid");
			int from = WebUtil.getIntValue(request.getParameter("from"));
			int to = WebUtil.getIntValue(request.getParameter("to"));
			
			if(workSubjectDAO.moveSeq(wid, sid, from, to)){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
	}

	
%>

