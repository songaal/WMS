<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.UserInfo" %>
<%@ page import="co.fastcat.wms.dao.UserDAO" %>
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


