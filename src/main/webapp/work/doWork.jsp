<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.bean.WorkList" %>
<%@ page import="co.fastcat.wms.dao.WorkTaskDAO" %>
<%@ page import="co.fastcat.wms.bean.WorkInfo" %>
<%@ page import="co.fastcat.wms.dao.WorkDAO" %>

<%@include file="../inc/session.jsp"%>
<%
	WorkDAO workDAO = new WorkDAO();
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action");
	Map<String, String[]> paramMap = request.getParameterMap();
	WorkInfo info = new WorkInfo();
	info.map(paramMap);
	info.userSID = myUserInfo.serialId;
	
	if ("addWorkProject".equals(action)) {
		String wid = workDAO.createWithSeq(info);
		out.println("{\"wid\": \""+wid+"\"}");
		return;
		
	} else if ("deleteWorkProject".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			if(workDAO.deleteWithSeq(info) > 0){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
		
	} else if ("moveWorkProject".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			int from = WebUtil.getIntValue(request.getParameter("from"));
			int to = WebUtil.getIntValue(request.getParameter("to"));
			if(workDAO.moveSeq(info.userSID, info.regdate, info.id, from, to)){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
	} else if ("initWorkQueue".equals(action)) {
		String wid = workDAO.createWithSeq(info);
		new WorkTaskDAO().migrateUndoneWorks(myUserInfo.serialId, wid);
		out.println("{\"wid\": \""+wid+"\"}");
		return;
		
	} else if ("addWeekWorkProject".equals(action)) {
		WorkList workList = new WorkList();
		info.map(paramMap);
		info.userSID = myUserInfo.serialId;
		//주간 프로젝트 추가.
		//해당 날짜의 해당 사람의 해당 프로젝트 데이터를 초기화한다.
		//해당 주간의 월~금까지 빈 데이터를 insert. 만약 존재하면 ignore.
		//workList.createWeekWorkList(workList);
		out.println("{\"result\": true}");
		return;
		
	}
	
%>

