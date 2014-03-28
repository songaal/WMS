<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@include file="../inc/session.jsp"%>

<%
	String todayStr = WebUtil.toDateString(new Date());

	String rid = request.getParameter("rid");
	String statusFilter = request.getParameter("statusFilter"); //좌측리스트에 사용되는 상태필터값.
	ProjectRequestDAO projectDAO = new ProjectRequestDAO();
	ProjectRequest2 info = projectDAO.selectRequest(rid);
%>

<form id="requestForm" method="post" action="/WMS/project/doRequest.jsp">
	<input type="hidden" name="action" value="modifyByWork"/>
	<input type="hidden" name=pid value="-1"/>
	<input type="hidden" name=rid value="<%=rid %>"/>
	<input type="hidden" name="selectUserId" value="<%=info.userId %>" />
	<input type="hidden" name="status" value="<%=info.status %>"/>
	<input type="hidden" name="todayStr" value="<%=todayStr %>"/>
	<input type="hidden" name="doneDate" />
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>
			
			<tr>
				<th>요청일</th>
				<td>
				<div class="input-append date" data-date="<%=WebUtil.toDateString(info.regdate) %>" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="regdate" type="text" value="<%=WebUtil.toDateString(info.regdate) %>" required>
					<span class="add-on"><i class="icon-calendar"></i></span>
				</div>
				</td>
			</tr>
			
			<tr>
				<th>요청자</th>
				<td>
				<input class="input-large" size="10" name="clientPname" type="text" placeholder="이름 직함" required minLength="3" value="<%=WebUtil.getValue((info.clientPersonName==null)?info.clientPname:"") %>"/>
				</td>
			</tr>
			<tr>
				<th>요청방법</th>
				<td>
				<select name="method" required>
					<option value="">:: 선택 ::</option>
					<option value="이메일" <%="이메일".equals(info.method)?"selected":"" %> >이메일</option>
					<option value="전화" <%="전화".equals(info.method)?"selected":"" %> >전화</option>
					<option value="구두" <%="구두".equals(info.method)?"selected":"" %> >구두</option>
					<option value="기타" <%="기타".equals(info.method)?"selected":"" %> >기타</option>
				</select>
				</td>
			</tr>
			<tr>
				<th>제목</th>
				<td><input type="text" name=title class="input-large" required minLength="4" maxLength="20" placeholder="고객사 및 요청제목" value="<%=info.title %>"/></td>
			</tr>
			<tr>
				<th>요청내용</th>
				<td><textarea name=content class="mid" required minLength="4"><%=WebUtil.getValue(info.content) %></textarea></td>
			</tr>
			<tr>
				<th>처리담당자</th>
				<td><select name="userId" required></select></td>
			</tr>
			<tr>
				<th>처리기한</th>
				<td>
				<div class="input-append date" data-date="<%=WebUtil.toDateString(info.dueDate) %>" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="dueDate" type="text" value="<%=WebUtil.toDateString(info.dueDate) %>" required>
					<span class="add-on"><i class="icon-calendar"></i></span>
				</div>
				</td>
			</tr>
			<tr>
				<th>처리내용</th>
				<td><textarea name=result class="mid"><%=WebUtil.getValue(info.result) %></textarea></td>
			</tr>
			
		</tbody>
	</table>
</form>
<script>
$(function() {
	$('.date').datepicker().on('changeDate', function(ev) {
		$(this).blur();
		$(this).datepicker('hide');
	});
});
</script>