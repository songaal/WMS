<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.ProjectInfo" %>
<%@ page import="co.fastcat.wms.dao.ProjectDAO" %>
<%
	String pid2 = request.getParameter("pid");
%>
<div class="span3 bs-docs-sidebar">
	<ul class="nav nav-tabs">
		<li class="<%=ProjectInfo.STATUS_ONGOING.equals(status)?"active":"" %>"><a href="index.jsp?status=<%=ProjectInfo.STATUS_ONGOING%>">진행중</a></li>
		<li class="<%=ProjectInfo.STATUS_MAINTAIN.equals(status)?"active":"" %>"><a href="index.jsp?status=<%=ProjectInfo.STATUS_MAINTAIN%>">유지보수</a></li>
		<li class="<%=ProjectInfo.STATUS_DONE.equals(status)?"active":"" %>"><a href="index.jsp?status=<%=ProjectInfo.STATUS_DONE%>">완료</a></li>
		<li class="<%=ProjectInfo.STATUS_ALL.equals(status)?"active":"" %>"><a href="index.jsp?status=<%=ProjectInfo.STATUS_ALL%>">전체</a></li>
	</ul>
	<ul class="nav nav-list bs-docs-sidenav">
		<%
		if(pid2 == null){
		%>
		<li class="active">
		<%
		}else{
		%>
		<li>
		<%
		}
		%>
		<a href="index.jsp?status=<%=status%>"><i class="icon-chevron-right"></i> 전체 히스토리</a>
		</li>
		<%
		ProjectDAO projectDAO2 = new ProjectDAO();
		List<ProjectInfo> list2 = null;
		if("".equals(status) || ProjectInfo.STATUS_ALL.equals(status)){
			list2 = projectDAO2.selectTypeOutStatus(null);
		}else{
			list2 = projectDAO2.selectTypeOutStatus(status);
		}
		for(int i=0; i<list2.size(); i++){
			ProjectInfo info2 = list2.get(i);
			String classStr = "";
			if((info2.pid+"").equals(pid2)){
				classStr = "active";
			}
		%>
		<li class="<%=classStr %>">
			<a href="javascript:selectProject('<%=info2.pid %>', '<%=status %>')"><i class="icon-chevron-right"></i> <%=info2.name %></a>
		</li>
		<%
		}
		%>
	</ul>
</div>
	



