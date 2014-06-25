<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>

<%@include file="../inc/session.jsp"%>
<%
	MessageDAO messageDAO = new MessageDAO();
	Map<String, String[]> paramMap = request.getParameterMap();

	String action = request.getParameter("action");
	String content = request.getParameter("content");
	String taskdate = request.getParameter("taskdate");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	if("newEvent".equalsIgnoreCase(action)){
		
		EventInfo eventInfo = new EventInfo();
		eventInfo.map(paramMap);
		eventInfo.userSID = myUserInfo.serialId;
		eventInfo.regdate = new java.sql.Timestamp(System.currentTimeMillis());
		
		EventDAO eventDAO = new EventDAO();
		eventDAO.create(eventInfo);
		
	} else if("updateTask".equalsIgnoreCase(action)){
		TaskInfo taskInfo = new TaskInfo();
		
		taskInfo.taskdate = new java.sql.Date(sdf.parse(taskdate).getTime());
		taskInfo.userSid = myUserInfo.serialId;
		taskInfo.regdate = new java.sql.Timestamp(System.currentTimeMillis());
		taskInfo.content = content;
		
		TaskInfoDAO taskInfoDAO = new TaskInfoDAO();
		try {
			String set = "set content = ?";
			String where = "where user_sid='"+myUserInfo.serialId+"' and taskdate = '"+taskdate+"'";
			if(taskInfoDAO.update(set, where, new String[]{content}) == 0) {
				taskInfoDAO.create(taskInfo);
			}
		} catch (Exception e) {
			System.out.println(e);
		}
		
	} else if("updateMemo".equalsIgnoreCase(action)){
		MemoInfo memoInfo = new MemoInfo();
		memoInfo.map(paramMap);
		memoInfo.userSID = myUserInfo.serialId;
		memoInfo.regdate = new java.sql.Timestamp(System.currentTimeMillis());
		
		MemoDAO memoDAO = new MemoDAO();
			
		if(memoDAO.update(memoInfo)){
			//OK
		}else{
			memoDAO.create(memoInfo);
		}
		
	} else if ("checkOut".equalsIgnoreCase(action)) {
		Date date = sdf.parse(taskdate);
		LiveDAO liveDAO = new LiveDAO();
		LiveInfo liveInfo = liveDAO.select(myUserInfo.serialId, date);
		if(liveInfo != null){
			long now = System.currentTimeMillis();
			//로그인된 세션 myUserInfo 정보를 이용한다.
			liveInfo.checkOut = new java.sql.Timestamp(now);
			if(BusinessUtil.isWorkLate()){
				liveInfo.status += LiveInfo.NIGHT_WORK;
			}
			liveDAO.modify(liveInfo);
		}
	}
	
	response.sendRedirect("/WMS/my/index.jsp?date="+taskdate);
	
%>

