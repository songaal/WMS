<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@include file="../inc/session.jsp"%>
<%
	UserDAO dao = new UserDAO();
	List<UserInfo> list = dao.select();
%>
[
<%
	for(int i=0; list != null && i< list.size(); i++){
		UserInfo info = list.get(i);
		
%>
		{"name": "<%=info.userName %> <%=info.title %>", "value": "<%=info.serialId %>"}
<%	
		if(i < list.size() - 1){
			out.println(",");	
		}
	}
%>
]


