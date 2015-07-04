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
<%@ page import="co.fastcat.wms.bean.*" %>
<%@ page import="co.fastcat.wms.dao.ProjectDAO" %>

<%@include file="../inc/session.jsp"%>
<%
	ProjectDAO projectDAO = new ProjectDAO();
	request.setCharacterEncoding("utf-8");

	String action = request.getParameter("action");
	Map<String, String[]> paramMap = request.getParameterMap();
	ProjectInfo info = new ProjectInfo();
	info.map(paramMap);
	
	if ("insert".equals(action)) {
		prepareNewInfo(request, info);
		projectDAO.create(info);
		
		info = projectDAO.get(info);
		
		ProjectHistoryDAO projectHistoryDAO = new ProjectHistoryDAO();
		ProjectHistory history = projectHistoryDAO.createBean();
		history.pid = info.pid;
		history.type = "신규";
		history.userId = info.pmId;
		history.memo = "프로젝트 초기 구축";
		
		projectHistoryDAO.create(history);
		
		response.sendRedirect("info.jsp?pid="+info.pid);
		
	} else if ("modify".equals(action)) {
		prepareNewInfo(request, info);
		
		projectDAO.modify(info);
		
		String pid = request.getParameter("pid");
		String statusFilter = request.getParameter("statusFilter");
		response.sendRedirect("info.jsp?pid="+pid+"&status="+statusFilter);
	} else if ("delete".equals(action)) {
		projectDAO.delete(info);
		response.sendRedirect("index.jsp");
	}

	
%>
<%!
	public void prepareNewInfo(ServletRequest request, ProjectInfo info){
		String clientId = request.getParameter("clientId");
		String clientPersonId = request.getParameter("clientPersonId");
		String resellerId = request.getParameter("resellerId");
		String resellerPersonId = request.getParameter("resellerPersonId");
		logger.debug("clientId >> {}", clientId);
		logger.debug("clientPersonId >> {}", clientPersonId);
		logger.debug("resellerId >> {}", resellerId);
		logger.debug("resellerPersonId >> {}", resellerPersonId);
		
		if("NEW".equals(clientId)){
			String newClientName = request.getParameter("newClientName");
			//고객사정보 추가.
			ClientDAO dao = new ClientDAO();
			ClientInfo info2 = new ClientInfo();
			info2.clientName = newClientName;
			info2.regdate = new java.sql.Date(System.currentTimeMillis());
			info2.type = ClientInfo.ClientA;
			String key = dao.create(info2);
			if(key != null){
				//성공적으로 insert 된 것임.
				clientId = key;
				info.clientId = Integer.parseInt(key);
			}
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
		
		if("NEW".equals(resellerId)){
			//정보 추가.
			String newClientName = request.getParameter("newResellerName");
			//고객사정보 추가.
			ClientDAO dao = new ClientDAO();
			ClientInfo info2 = new ClientInfo();
			info2.clientName = newClientName;
			info2.regdate = new java.sql.Date(System.currentTimeMillis());
			info2.type = ClientInfo.ClientB;
			
			String key = dao.create(info2);
			if(key != null){
				//성공적으로 insert 된 것임.
				resellerId = key;
				info.resellerId = Integer.parseInt(key);
			}
			//회사 신규입력이면 직원도 신규이다.
			resellerPersonId = "NEW";
		}
		
		if("NEW".equals(resellerPersonId)){
			//정보 추가.
			String newClientPersonName = request.getParameter("newResellerPersonName");
			String newResellerPersonPhone = request.getParameter("newResellerPersonPhone");
			String newResellerPersonCellPhone = request.getParameter("newResellerPersonCellPhone");
			String newResellerPersonEmail = request.getParameter("newResellerPersonEmail");
			//고객사정보 추가.
			ClientPersonDAO dao = new ClientPersonDAO();
			ClientPersonInfo info2 = new ClientPersonInfo();
			info2.cid = Integer.parseInt(resellerId);
			info2.personName = newClientPersonName;
			info2.phone = newResellerPersonPhone;
			info2.cellPhone = newResellerPersonCellPhone;
			info2.email = newResellerPersonEmail;
			info2.regdate = new java.sql.Date(System.currentTimeMillis());
			info2.type = ClientInfo.ClientB;
			
			String key = dao.create(info2);
			if(key != null){
				//성공적으로 insert 된 것임.
				info.resellerPersonId = Integer.parseInt(key);
			}
		}
	}
%>

