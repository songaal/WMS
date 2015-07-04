<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.dao.UserDAO" %>
<%@include file="../inc/session.jsp"%>
<%
	UserDAO dao = new UserDAO();
	request.setCharacterEncoding("utf-8");

	String serialId = request.getParameter("serialId");
	UserInfo userInfo = dao.select(serialId);
%>
<form id="updateUserForm" method="post" action="doUserSettings.jsp">
	<input type="hidden" name="action"/> 
	<input type="hidden" name="id" value="<%=serialId%>" />
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>
			<tr>
				<th>사번</th>
				<td>
					<input type="hidden" name="serialId" class="uneditable-input" value="<%=userInfo.serialId%>" />
					<span class="input uneditable-input"><%=userInfo.serialId%></span>
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" name="userName" value="<%=userInfo.userName%>" /></td>
			</tr>
			<tr>
				<th>직함</th>
				<td><input type="text" name="title" value="<%=userInfo.title%>" /></td>
			</tr>
			<tr>
				<th>부서</th>
				<td><input type="text" name="part" value="<%=userInfo.part%>" /></td>
			</tr>
			<tr>
				<th>아이디</th>
				<td><input type="text" name="userId" value="<%=userInfo.userId%>" /></td>
			</tr>
			<tr>
				<th>입사일</th>
				<td>
				<input type="text" name="enterDate" class="input-small required" placeholder="입사일"
						maxlength="10" id="enterDatePicker2" data-date-format="yyyy.mm.dd" value="<%=WebUtil.toDateString(userInfo.enterDate)%>" /></td>
			</tr>
			<tr>
				<th>부여권한리스트</th>
				<td><input type="text" name="userType" value="<%=userInfo.userType%>" /> <br>사용자:U, 관리자:A</td>
			</tr>
			<tr>
				<th>타입</th>
				<td><input type="text" name="type" value="<%=userInfo.type%>" /> <br>직원:W, 외부:E, 정지:H</td>
			</tr>
		</tbody>
	</table>
</form>
<script>
$(function() {
	$('#enterDatePicker2').datepicker().on('changeDate', function(ev) {
		$(this).blur();
		$(this).datepicker('hide');
	});
});
</script>
