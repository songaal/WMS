<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@include file="../inc/session.jsp"%>
<script src="/WMS/assets/js/project.js"></script>
<%
	ProjectMaintainDAO pmDAO = new ProjectMaintainDAO();
	request.setCharacterEncoding("utf-8");

	String mid = request.getParameter("mid");
	ProjectMaintain2 pmInfo = pmDAO.selectMeeting(mid);

	if ( pmInfo == null )
		return;
	
	String comment = pmInfo.comment;
	String maintainList = pmInfo.maintainList;
	String result = pmInfo.result;
		
	if ( comment == null ) comment = "";
	if ( maintainList == null ) maintainList = "";
	if ( result == null ) result = "";		
		
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	
	String strMaintainDate = "";
	if ( pmInfo.maintainDate != null )	
		strMaintainDate = sdf.format(pmInfo.maintainDate);
	
	String strDoneDate = "";
	if ( pmInfo.doneDate != null )	
		strDoneDate = sdf.format(pmInfo.doneDate);
		
%>
<form id="maintModifyFrm" method="post" action="doMaintain.jsp">
	<input type="hidden" name="action" />
	<input type="hidden" name="pid" value="<%=pmInfo.pid %>" />
	<input type="hidden" name="mid" value="<%=mid %>" />
	<input type="hidden" name="userId" value="<%=myUserInfo.serialId %>" />
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>			
			<tr>
				<th>점검일자</th>
				<td>
				<div class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="maintainDate" type="text" value="<%=strMaintainDate%>">					
					<span class="add-on"><i class="icon-calendar"></i></span>
				</div>
				</td>
			</tr>
			<tr>
				<th>완료일자</th>
				<td>
				<div class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="doneDate" type="text" value="<%=strDoneDate%>">
					<span class="add-on"><i class="icon-calendar"></i></span>
				</div>
				</td>
			</tr>
			<tr>
				<th>점검내용</th>
				<td><textarea name="maintainList" class="mid"><%=maintainList%></textarea></td>
			</tr>
			<tr>
				<th>처리내용</th>
				<td><textarea name="result" class="mid"><%=result%></textarea></td>
			</tr>
			<tr>
				<th>코멘트</th>
				<td><textarea name="comment" class="mid"><%=comment%></textarea></td>
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
