<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.dao.WorkTaskDAO" %>
<%@ page import="co.fastcat.wms.bean.WorkTask" %>

<%@include file="../inc/session.jsp"%>
<%
	WorkTaskDAO workTaskDAO = new WorkTaskDAO();
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action");
	Map<String, String[]> paramMap = request.getParameterMap();
	
	
	
	if ("addWorkTask".equals(action)) {
		WorkTask info = new WorkTask();
		info.map(paramMap);
		info.userSID = myUserInfo.serialId;
		
		String tid = workTaskDAO.createWithSeq(info);
		out.println("{\"tid\": \""+tid+"\"}");
	} else if ("modifyWorkTask".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			WorkTask info = new WorkTask();
			info.map(paramMap);
			info.userSID = myUserInfo.serialId;
			
			List<String> excludeList = new ArrayList<String>();
			excludeList.add("wid");
			excludeList.add("pid");
			excludeList.add("sid");
			excludeList.add("user_sid");
			excludeList.add("regdate");
			excludeList.add("status");
			excludeList.add("seq");
			//Update memo, time
			if(workTaskDAO.modify(info, excludeList) > 0) {
				out.println("{\"result\": true}");
				return;
			}
		}
		
		out.println("{\"result\": \"false\"}");
		
	} else if ("deleteWorkTask".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			WorkTask info = new WorkTask();
			info.map(paramMap);
			info.userSID = myUserInfo.serialId;
			
			if(workTaskDAO.deleteWithSeq(info) > 0){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
		
	} else if ("moveWorkTask".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			String wid = request.getParameter("wid");
			String sid = request.getParameter("sid");
			String tid = request.getParameter("tid");
			int from = WebUtil.getIntValue(request.getParameter("from"));
			int to = WebUtil.getIntValue(request.getParameter("to"));
			
			if(workTaskDAO.moveSeq(wid, sid, tid, from, to)){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
	} else if ("moveToAnotherWorkTask".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			String oldWid = request.getParameter("oldWid");
			String oldSid = request.getParameter("oldSid");
			String wid = request.getParameter("wid"); //새롭게 옮긴 wid
			String sid = request.getParameter("sid"); //새롭게 옮긴 sid
			String pid = request.getParameter("pid");
			String tid = request.getParameter("tid");
			int from = WebUtil.getIntValue(request.getParameter("from"));
			int to = WebUtil.getIntValue(request.getParameter("to"));
			logger.debug("ow={}, os={}, w={}, s={}, p={}, t={}, f={}, t={}", new Object[]{oldWid, oldSid, wid, sid, pid, tid, from, to});
			
			if(workTaskDAO.moveToAnotherSeq(oldWid, oldSid, wid, sid, pid, tid, from, to)){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
		
	} else if ("toggleWorkTask".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			String tid = request.getParameter("tid");
			String checkDone = request.getParameter("checkDone");
			boolean isCheckDone =Boolean.parseBoolean(checkDone);
			if(workTaskDAO.toggleTaskDone(tid, isCheckDone) > 0){
				if(isCheckDone){
					out.println("{\"result\": \"done\"}");
				}else{
					out.println("{\"result\": \"not\"}");
				}
				return;
			}
		}
		out.println("{\"result\": not}");
	
	/* } else if ("toggleCheckList".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			String tid = request.getParameter("tid");
			String checkDone = request.getParameter("checkDone");
			boolean isCheckDone =Boolean.parseBoolean(checkDone);
			if(workTaskDAO.toggleCheckListDone(tid, isCheckDone) > 0){
				if(isCheckDone){
					out.println("{\"result\": \"done\"}");
				}else{
					out.println("{\"result\": \"not\"}");
				}
				return;
			}
		}
		out.println("{\"result\": not}"); */
		
	} else if ("addCheckList".equals(action)) {
		//체크리스트
		WorkTask info = new WorkTask();
		info.map(paramMap);
		info.userSID = myUserInfo.serialId;
		
		String tid = workTaskDAO.createWithSeq(info);
		out.println("{\"tid\": \""+tid+"\"}");
	} else if ("moveCheckList".equals(action)) {
		if(request.getMethod().equalsIgnoreCase("POST")){
			String tid = request.getParameter("tid");
			int from = WebUtil.getIntValue(request.getParameter("from"));
			int to = WebUtil.getIntValue(request.getParameter("to"));
			
			if(workTaskDAO.moveCheckListSeq(myUserInfo.serialId, tid, from, to)){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
	}
	
%>

