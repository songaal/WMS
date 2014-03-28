<%@page import="java.sql.Date"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>

<%@include file="../inc/session.jsp"%>
<%
	request.setCharacterEncoding("utf-8");
	String action = request.getParameter("action");
	String pid = request.getParameter("pid");
	String statusFilter = request.getParameter("statusFilter");
	Map<String, String[]> paramMap = request.getParameterMap();
	
	ProjectRequestDAO projectRequestDAO = new ProjectRequestDAO();
	
	
	ProjectRequest info = new ProjectRequest();
	info.map(paramMap);
	
	if ("insert".equals(action)) {
		//입력시에만 히스토리에 남긴다.
		ProjectHistoryDAO projectHistoryDAO = new ProjectHistoryDAO();
		ProjectHistory history = new ProjectHistory();
		history.pid = info.pid;
		
		prepareNewInfo(request, info);		
		history.wid = Integer.parseInt(projectRequestDAO.create(info));		
		
		if ( info.content.length() > 256 )
			history.memo = info.content.substring(0,255);
		else
			history.memo = info.content;
		
		history.type = "요청";
		history.regdate = info.regdate;
		history.userId = info.userId;
		
		projectHistoryDAO.create(history);
		
	}else if ("insertAjax".equals(action)) {
		String key = projectRequestDAO.create(info);
		if(key != null){
			out.println("{ \"result\": true}");
		}else{
			out.println("{ \"result\": false}");
		}
		return;
	} else if ("modify".equals(action)) {
		prepareNewInfo(request, info);		
		projectRequestDAO.modify(info);
		response.sendRedirect(pageFrom);
		return ;
	} else if ("modifyByWork".equals(action)) {
		projectRequestDAO.modify(info);
		response.sendRedirect(pageFrom);
		return;
	} else if ("delete".equals(action)) {
		projectRequestDAO.delete(info);
	} else if ("deleteByWork".equals(action)) {
		projectRequestDAO.delete(info);
		response.sendRedirect(pageFrom);
		return;
	} else if ("appendWork".equals(action)) {
		ProjectWork pw = new ProjectWork();
		ProjectWorkDAO pwDAO = new ProjectWorkDAO();
		String project_id = request.getParameter("project_id");
		String request_id = request.getParameter("rid");
		
		if ( pwDAO.isWorkExists(project_id, request_id) == false )
		{
			pw.map(paramMap);
			pw.rid = Integer.parseInt(request_id);
			pw.pid = Integer.parseInt(project_id);						
			ProjectHistoryDAO projectHistoryDAO = new ProjectHistoryDAO();
			ProjectHistory history = new ProjectHistory();
			history.pid = pw.pid;
			history.wid = Integer.parseInt(pwDAO.create(pw));		
			if ( info.content.length() > 256 )
				history.memo = info.content.substring(0,255);
			else
				history.memo = info.content;
			
			history.type = "작업";			
			history.userId = info.userId;
			
			projectHistoryDAO.create(history);
			
			out.println("{\"result\":0\"}");
		}
		else
			{
			out.clear();
			out.println("{\"result\":1, \"errmsg\":\"이미 존재하는 작업입니다. \"}");		
			}
		
		response.sendRedirect(pageFrom);
		return;
		
	}

	if(statusFilter==null) {
		response.sendRedirect("request.jsp?pid="+pid);
	} else {
		response.sendRedirect("request.jsp?pid="+pid+"&status="+statusFilter);
	}
%>
<%!
	public void prepareNewInfo(ServletRequest request, ProjectRequest info){
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
				info.clientPersonId = Integer.parseInt(key);
			}
		}
	
	}
%>

