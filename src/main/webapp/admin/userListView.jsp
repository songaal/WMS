<%@ page contentType="text/html; charset=UTF-8"%>
<%@include file="../inc/header.jsp" %>
<%@page import="java.util.*" %>
<%@page import="com.websqrd.company.wms.*" %>
<%
	//UserInfoHandler userInfoHandler = new UserInfoHandler();
%>
</head>
<body>
<h1>직원리스트</h1>
<a href="addUser.jsp">직원추가</a>
<%
	List<UserInfo> list = null;//userInfoHandler.selectAll();
%>
<ul>
<%
	for(int i=0;i<list.size();i++){
		
		UserInfo userInfo = (UserInfo)list.get(i);
%>
<li><div><%=userInfo.userId %> <%=userInfo.userName %> <%=userInfo.title %> <%=userInfo.part %></div></li>
<%
	}
%>
</ul>
<%@include file="../inc/footer.jsp" %>