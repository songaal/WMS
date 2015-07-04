<%@page import="java.sql.Date"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.dao.ProjectHistoryDAO" %>
<%@ page import="co.fastcat.wms.dao.ClientDAO" %>
<%@ page import="co.fastcat.wms.dao.ClientPersonDAO" %>
<%@ page import="co.fastcat.wms.dao.ProjectMeetingDAO" %>
<%@ page import="co.fastcat.wms.bean.*" %>

<%@include file="../inc/session.jsp"%>
<%
	request.setCharacterEncoding("utf-8");
	String action = request.getParameter("action");
	String pid = request.getParameter("pid");
	String statusFilter = request.getParameter("statusFilter");
	Map<String, String[]> paramMap = request.getParameterMap();
	
	ProjectMeetingDAO projectMeetingDAO = new ProjectMeetingDAO();
	ProjectMeeting info = new ProjectMeeting();
	info.map(paramMap);
		
	if ("insert".equals(action)) {
		ProjectHistory history = new ProjectHistory();
		prepareNewInfo(request, info);
		history.wid = Integer.parseInt(projectMeetingDAO.create(info));
		
		//회의록 입력시에 히스토리를 남긴다. 
		ProjectHistoryDAO projectHistoryDAO = new ProjectHistoryDAO();
		
		history.pid = info.pid;
		
		if ( info.content.length() > 256 )
			history.memo = info.content.substring(0,255);
		else
			history.memo = info.content;
		
		history.type = "회의록";
		history.regdate = info.regdate;
		history.userId = info.userId;
				
		projectHistoryDAO.create(history);
		
	} else if ("modify".equals(action)) {
		prepareNewInfo(request, info);
		projectMeetingDAO.modify(info);
	} else if ("delete".equals(action)) {
		projectMeetingDAO.delete(info);
	}

	response.sendRedirect("meetings.jsp?pid="+pid+"&status="+statusFilter);
%>
<%!
	public void prepareNewInfo(ServletRequest request, ProjectMeeting info){
		String clientId = request.getParameter("clientId");
		String clientPersonId = request.getParameter("clientPersonId");
		logger.debug("clientId >> {}", clientId);
		logger.debug("clientPersonId >> {}", clientPersonId);
		
		if("NEW".equals(clientId)){
			String newClientName = request.getParameter("newClientName");
			//고객사정보 추가.
			ClientDAO dao = new ClientDAO();
			ClientInfo info2 = new ClientInfo();
			info2.clientName = newClientName;
			info2.regdate = new java.sql.Date(System.currentTimeMillis());
			info2.type = ClientInfo.ClientA;
			String key = dao.create(info2);
			//회사 신규입력이면 직원도 신규이다.
			clientPersonId = "NEW";
		}
		
		if("NEW".equals(clientPersonId)){
			//정보 추가.
			String newClientPersonName = request.getParameter("newClientPersonName");
			String newClientPersonPhone = request.getParameter("newClientPersonPhone");
			String newClientPersonCellPhone = request.getParameter("newClientPersonCellPhone");
			String newClientPersonEmail = request.getParameter("newClientPersonEmail");
			//고객사정보 추가.
			ClientPersonDAO dao = new ClientPersonDAO();
			ClientPersonInfo info2 = new ClientPersonInfo();
			info2.cid = Integer.parseInt(clientId);
			info2.personName = newClientPersonName;
			info2.phone = newClientPersonPhone;
			info2.cellPhone = newClientPersonCellPhone;
			info2.email = newClientPersonEmail;
			info2.regdate = new java.sql.Date(System.currentTimeMillis());
			info2.type = ClientInfo.ClientA;
			
			String key = dao.create(info2);
			if(key != null){
				//성공적으로 insert 된 것임.
				//info.clientPersonId = Integer.parseInt(key);
			}
		}
	
	}
%>

