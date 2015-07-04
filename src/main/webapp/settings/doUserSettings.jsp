<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.RestDAO" %>
<%@ page import="co.fastcat.wms.dao.UserDAO" %>
<%@ page import="co.fastcat.wms.dao.UserReportDAO" %>
<%@ page import="co.fastcat.wms.bean.RestInfo" %>
<%@ page import="co.fastcat.wms.bean.UserReport" %>
<%@include file="../inc/session.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	UserDAO dao = new UserDAO();
	
	Map<String, String[]> paramMap = request.getParameterMap();
	UserInfo userInfo = new UserInfo();
	userInfo.map(paramMap);
	
	String action = request.getParameter("action");
	
	out.println("action = "+action);
	
	if("create".equals(action)){
		/* UserInfo userInfo = new UserInfo();
		userInfo.userType = request.getParameter("userType");
		userInfo.type = request.getParameter("type");
		userInfo.serialId = "W"+request.getParameter("serialId");
		userInfo.userName = request.getParameter("userName");
		userInfo.passwd = userInfo.serialId;//처음 생성시에 암호는 사번과 동일.
		userInfo.title = request.getParameter("title");
		userInfo.part = request.getParameter("part");
		userInfo.userId = request.getParameter("userId");
		if(WebUtil.isNotEmpty(request.getParameter("enterDate"))){
			userInfo.enterDate = WebUtil.getSQLDateValue(request.getParameter("enterDate"));
		} */
		
		userInfo.serialId = "W"+userInfo.serialId;
		userInfo.passwd = userInfo.serialId;//처음 생성시에 암호는 사번과 동일.
		
		if(userInfo.serialId != null && userInfo.userName != null){
			//사용자 생성 
			String key = dao.create(userInfo);
			logger.info("[사용자생성] id={}, serialId={}, userName={}", new Object[]{key, userInfo.serialId, userInfo.userName});
			if(key != null){
				//성공
				/*
				* 1. 기본적으로 휴가정보 생성.	
				*/
				RestDAO restDAO = new RestDAO();
				RestInfo restInfo = new RestInfo();
				restInfo.userSID = userInfo.serialId;
				key = restDAO.create(restInfo);
				logger.info("[휴가정보생성] id={}, serialId={}", new Object[]{key, userInfo.serialId});
				/*
				* 2. 기본적으로 보고정보 생성.	
				*/
				UserReportDAO userReportDAO = new UserReportDAO();
				UserReport userReport = new UserReport();
				userReport.userSID = userInfo.serialId;
				key = userReportDAO.create(userReport);
				logger.info("[보고정보생성] id={}, serialId={}", new Object[]{key, userInfo.serialId});
			}else{
				//실패
				logger.error("[사용자생성] 실패! id={}, serialId={}, userName={}", new Object[]{key, userInfo.serialId, userInfo.userName});
			}
		}
		
	}else if("modify".equals(action)){
		/* UserInfo userInfo = new UserInfo();
		userInfo.userType = request.getParameter("userType");
		userInfo.type = request.getParameter("type");
		userInfo.serialId = request.getParameter("serialId");
		userInfo.userName = request.getParameter("userName");
		userInfo.title = request.getParameter("title");
		userInfo.part = request.getParameter("part");
		userInfo.userId = request.getParameter("userId");
		if(WebUtil.isNotEmpty(request.getParameter("enterDate"))){
			userInfo.enterDate = WebUtil.getSQLDateValue(request.getParameter("enterDate"));
		} */
		
		out.println("userInfo.serialId = "+userInfo.serialId+", userInfo.userName="+userInfo.userName);
		if(userInfo.serialId != null && userInfo.userName != null){
			//사용자 수정.
			List<String> excludeColumns = new ArrayList<String>();
			excludeColumns.add("passwd");
			int updated = dao.modify(userInfo, excludeColumns);
			logger.info("[사용자정보수정] updated={}, serialId={}, userName={}", new Object[]{updated, userInfo.serialId, userInfo.userName});
			if(updated == 1){
				//성공
			}else{
				//실패
			}
		}
		
	}else if("delete".equals(action)){
		/* UserInfo userInfo = new UserInfo();
		userInfo.userType = request.getParameter("userType");
		userInfo.type = request.getParameter("type");
		userInfo.serialId = request.getParameter("serialId");
		userInfo.userName = request.getParameter("userName");
		userInfo.title = request.getParameter("title");
		userInfo.part = request.getParameter("part");
		userInfo.userId = request.getParameter("userId");
		if(WebUtil.isNotEmpty(request.getParameter("enterDate"))){
			userInfo.enterDate = WebUtil.getSQLDateValue(request.getParameter("enterDate"));
		} */
		
		if(userInfo.serialId != null){
			//사용자 삭제
			int deleted = dao.delete(userInfo);
			logger.info("[사용자삭제] deleted={}, serialId={}, userName={}", new Object[]{deleted, userInfo.serialId, userInfo.userName});
			
			RestDAO restDAO = new RestDAO();
			restDAO.clean(userInfo.serialId);
				
			if(deleted == 1){
				//성공
			}else{
				//실패
			}
		}
	}
	
	
	response.sendRedirect("index.jsp");
	
%>




