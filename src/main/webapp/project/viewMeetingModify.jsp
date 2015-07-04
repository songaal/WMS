<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.bean.ProjectMeeting2" %>
<%@ page import="co.fastcat.wms.dao.ProjectMeetingDAO" %>
<%@include file="../inc/session.jsp"%>
<%
	ProjectMeetingDAO pmDAO = new ProjectMeetingDAO();
	request.setCharacterEncoding("utf-8");

	String mid = request.getParameter("mid");
	ProjectMeeting2 pmInfo = pmDAO.selectMeeting(mid);

	if ( pmInfo == null )
		return;
	
	String content = pmInfo.content;
	String nextTodo = pmInfo.nextTodo;
	String nextSchedule = pmInfo.nextSchedule;
	String place = pmInfo.place;
	String websqrdUser = pmInfo.websqrdUser;
	String clientUser = pmInfo.clientUser;
		
	if ( content == null ) content = "";
	if ( nextTodo == null ) nextTodo = "";
	if ( nextSchedule == null ) nextSchedule = "";		
	if ( place == null ) place = "";
	if ( websqrdUser == null ) websqrdUser = "";
	if ( clientUser == null ) clientUser = "";
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	
	String strMeetDate = "";
	if ( pmInfo.meetDate != null )	
		strMeetDate = sdf.format(pmInfo.meetDate);
		
%>
<form id="projectForm" method="post" action="doMeeting.jsp">
			<input type="hidden" name="action" />
			<input type="hidden" name="mid" value="<%=pmInfo.mid %>" />
			<input type="hidden" name="pid" value="<%=pmInfo.pid %>" />		
			<input type="hidden" name="userId" value="<%=myUserInfo.serialId %>" />
			<input type="hidden" name="regdate" value="<%=WebUtil.toDateString(new Date()) %>" />
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					
					<tr>
						<th>회의일자</th>
						<td>
						<div name="mdate" class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="meetDate" type="text" value="<%=strMeetDate%>">
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
						</td>
					</tr>
					<tr>
						<th>장소</th>
						<td><input type="text" name=place class="input-large"  value="<%=place %>"/></td>
					</tr>
					<tr>
						<th>웹스퀘어드참가자</th>
						<td>
						<input class="input-large" name="websqrdUser" type="text" value="<%=websqrdUser%>">
						</td>
					</tr>
					<tr>
						<th>고객참가자</th>
						<td>
						<input class="input-large" name="clientUser" type="text" value="<%=clientUser%>" >
						</td>
					</tr>
					<tr>
						<th>회의내용</th>
						<td><textarea name="content" class="long"> <%=content%> </textarea></td>
					</tr>
					<tr>
						<th>향후작업</th>
						<td><textarea name="nextTodo" class="mid"> <%=nextTodo%> </textarea></td>
					</tr>
					<tr>
						<th>향후일정</th>
						<td><textarea name="nextSchedule" class="mid"> <%=nextSchedule %> </textarea></td>
					</tr>					
				</tbody>
			</table>
		</form>
<script>
$('#mdate').datepicker();

$("#mdate").datepicker().on("changeDate", function(ev) {
	$(this).blur();
	$(this).datepicker('hide');
});

</script>
