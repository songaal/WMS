<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>
<%
	String type = WebUtil.getValue(request.getParameter("type"), "W");
%>
<div class="container ">
	<div class="row">
		<div class="span12">
		<h2 id="body-copy">업무일정</h2>
		</div>
		<div class="span3 bs-docs-sidebar">
			<ul class="nav nav-list bs-docs-sidenav">
				<li class="<%=type.equals("W")?"active":""%>"><a href="index.jsp?type=W"><i class="icon-chevron-right"></i>업무일정</a></li>
				<li class="<%=type.equals("P")?"active":""%>"><a href="index.jsp?type=P"><i class="icon-chevron-right"></i>개인일정</a></li>
			</ul>
		</div>
		<%
		if(type.equals("W")){
		%>
		<div class="span9" id='calendar'></div>
		<%
		}else if(type.equals("P")){
		%>
		<div class="span9">
		<iframe src="http://www.google.com/calendar/embed?src=<%=myUserInfo.userId %>%40websqrd.com&ctz=Asia/Seoul" style="border: 0; width:100%; height:600px" frameborder="0" scrolling="no"></iframe>
		</div>
		<%
		}
		%>
	</div>
</div>

<%@include file="../inc/footer.jsp"%>



