<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	String status = WebUtil.getValue(request.getParameter("status"), ProjectInfo.STATUS_ONGOING);
	String pid = request.getParameter("pid");
	String logType = String.valueOf(ProjectLogInfo.LOG_DEVELOPMENT);
	ProjectLogDAO projectLogDAO = new ProjectLogDAO();
	ProjectLogInfo projectLog = projectLogDAO.get(pid, logType);
	
	String logText = "";
	
	if(projectLog!=null) {
		logText = projectLog.logText;
	}
%>

<div class="container ">
	<div class="row">
		<div class="span12">
		<h2 id="body-copy">프로젝트</h2>
		</div>
		<br>
		<!-- 왼쪽 프로젝트 리스트 -->
		<%@include file="incProjectLeft.jsp"%>

		<!-- 메인 내용 -->
		<div class="span9">
			<%@include file="incProjectSubmenu.jsp" %>			
			<% if (projectLog!=null) {%>
			<div id="previewArea">
				<p>
					<button class="btn btn-small pull-right" onclick="toggleArea('previewArea','editArea')">수정</button>
				</p>
				<br/>
				<br/>
				<div id="">
					<div class="logtext">
					<%=logText %>
					</div>
				</div>
			</div>
			<% } %>
			<div id="editArea" style="display:<%=projectLog!=null?"none":""%>">
				<form id="environmentForm" action="writeLog.jsp" method="POST">
					<p>
						<button class="btn btn-info btn-small pull-right">저장</button>
					</p>
					<br/>
					<br/>
					<input type="hidden" name="action" value="<%=projectLog==null?"writeLog":"updateLog" %>"/>
					<input type="hidden" name="pid" value="<%=projectLog!=null?projectLog.pid:"" %>"/>
					<input type="hidden" name="projectId" value="<%=pid%>"/>
					<input type="hidden" name="type" value="<%=logType%>"/>
					<textarea style="width:100%; height:500px" id="logText" name="logText"><%=logText %></textarea>
					<br/>
				</form>
			</div>
		</div>
		
	</div>
</div>

<%@include file="../inc/footer.jsp"%>



