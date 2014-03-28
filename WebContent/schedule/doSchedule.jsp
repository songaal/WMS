<%@page import="org.json.JSONStringer"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@page import="org.json.JSONStringer"%>

<%@include file="../inc/session.jsp"%>
<%
	ScheduleDAO scheduleDAO = new ScheduleDAO();

	String action = request.getParameter("action");
	
	if ("listMonth".equals(action)) {
		int year = WebUtil.getIntValue(request.getParameter("year"));
		int month = WebUtil.getIntValue(request.getParameter("month"));
		
		List<DAOBean> list = scheduleDAO.selectMonth(year, month);
		
		if(list != null) {
			JSONStringer writer = new JSONStringer();
			writer.array();
			
			for(int i=0; i<list.size(); i++){
				ScheduleInfo2 info = (ScheduleInfo2) list.get(i);
				
				String title = info.title +"-"+info.userName;
				
				writer.object()
					.key("id").value(info.id)
					//.key("editable").value(info.userSID.equals(myUserInfo.serialId)) //내일정만 수정가능하다.
					.key("title").value(title)
					.key("start").value(WebUtil.toDateTimeString(info.startTime))
					.key("end").value(WebUtil.toDateTimeString(info.endTime))
					.key("allDay").value(info.allDay == 1)
				.endObject();
			}
			writer.endArray();
			
			out.println(writer.toString());
		}else{
			out.println("{}");
		}
		
		return;
		
	} else if ("insert".equals(action)) {
		Map<String, String[]> paramMap = request.getParameterMap();
		ScheduleInfo info = new ScheduleInfo();
		info.map(paramMap);
		//out.println("{\"result\": true, \"userName\": \""+myUserInfo.userName+" "+myUserInfo.title+"\"}");
		if(request.getMethod().equalsIgnoreCase("POST")){
			info.userSID = myUserInfo.serialId;
			String key = scheduleDAO.create(info);
			if(key != null){
				out.println("{\"result\": true, \"userName\": \""+myUserInfo.userName+" "+myUserInfo.title+"\", \"id\": "+key+"}");
				return;
			}
		}
		out.println("{\"result\": false}");
		
	} else if ("delete".equals(action)) {
		String id = request.getParameter("id");
		if(request.getMethod().equalsIgnoreCase("POST")){
			if(scheduleDAO.delete(id, myUserInfo.serialId)){
				out.println("{\"result\": true}");
				return;
			}
		}
		out.println("{\"result\": false}");
	}
	
%>

