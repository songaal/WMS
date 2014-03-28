<%@page import="java.sql.Timestamp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@include file="../inc/session.jsp"%>
<%
	try {
		request.setCharacterEncoding("UTF-8");

		Map<String, String[]> paramMap = request.getParameterMap();
		Iterator itr = paramMap.keySet().iterator();

		while (itr.hasNext()) {
			String key = (String) itr.next();
			String[] value = paramMap.get(key);
			if (value != null) {
				//out.print(key + ":");
				for (int i = 0; i < value.length; i++) {
					//out.print(value[i]);
					//out.print(",");
				}
				//out.println();
			}
		}

		if (paramMap.size() == 0)
			out.println("there is no parameter");

		String tid = request.getParameter("tid");
		String action = request.getParameter("action");

		TaskInfo tInfo = new TaskInfo();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String strContent = request.getParameter("content");
		String strIssue = request.getParameter("issue");
		if (strContent == null)
			strContent = "";
		if (strIssue == null)
			strIssue = "";
		tInfo.taskdate = new java.sql.Date(sdf.parse(request.getParameter("taskdate")).getTime());
		tInfo.content = strContent;
		tInfo.issue = strIssue;
		tInfo.userSid = request.getParameter("userId");

		if (action.equals("updateInsert")) {

			TaskInfoDAO tDAO = new TaskInfoDAO();

			if (tid.equals("-1")) {// insert						
				try {
					tDAO.create(tInfo);
				} catch (Exception e) {
					out.println(e);
				}
			} else {//update
				try {
					tInfo.id = Integer.parseInt(tid);
					tInfo.flag = 0;
					tDAO.modify(tInfo);
				} catch (Exception e) {
					out.println(e);
				}
			}
		} else if (action.equals("checkEditable")) {
			TaskInfoDAO tDAO = new TaskInfoDAO();
			TaskInfo data = tDAO.select2(tInfo.userSid, tInfo.taskdate);
			out.clear();
			if (data == null) {
				try {
					String id = tDAO.create(tInfo);
					out.println("{\"result\":\"0\", \"tid\": " + id + " }");
				} catch (Exception e) {
					out.println("{\"result\":\"1\", \"err\":\"" + e.getMessage() + "\"}");
				}
			} else
				out.println("{\"result\":\"" + data.flag + "\", \"tid\":\"" + data.id + "\"}");

		} else if (action.equals("setEdit")) {
			try {
				TaskInfoDAO tDAO = new TaskInfoDAO();
				tInfo.flag = 1;

				if (tid.equals("-1") || tid == null) {// insert	
					tInfo.id = Integer.parseInt(tDAO.create(tInfo));
					tDAO.modify(tInfo);
				} else {
					tInfo.id = Integer.parseInt(tid);
					tDAO.modify(tInfo);
				}
				out.clear();
				out.println("{\"result\":\"0\", \"tid\": " + tInfo.id + " }");
			} catch (Exception e) {
				out.println("{\"result\":\"1\", \"err\":\"" + e.getMessage() + "\"}");
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
	}
%>




