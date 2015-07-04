<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.bean.UserReport2" %>
<%@ page import="co.fastcat.wms.dao.UserReportDAO" %>
<%@include file="../inc/session.jsp"%>
<%
	UserReportDAO dao = new UserReportDAO();
	request.setCharacterEncoding("utf-8");

	String userSID = request.getParameter("userSID");
	UserReport2 userInfo = dao.select(userSID);
	if(userInfo == null){
		return;
	}
	
%>
<form id="updateUserForm" method="post" action="doUserReport.jsp">
	<input type="hidden" name="action"/> 
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>
			<tr>
				<th>사번</th>
				<td>
					<input type="hidden" name="userSID" class="uneditable-input" value="<%=userInfo.userSID%>" />
					<span class="input uneditable-input"><%=userInfo.userSID%></span>
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" value="<%=userInfo.userName%>" readonly/></td>
			</tr>
			<tr>
				<th>보고자</th>
				<td><input type="text" name="reportTo" value="<%=WebUtil.getValue(userInfo.reportTo) %>" /></td>
			</tr>
			<tr>
				<th>참조자</th>
				<td><input type="text" name="referenceTo" value="<%=WebUtil.getValue(userInfo.referenceTo) %>" /></td>
			</tr>
			<tr>
				<th>기타참조리스트</th>
				<td><input type="text" name="anotherList" value="<%=WebUtil.getValue(userInfo.anotherList) %>" /></td>
			</tr>
		</tbody>
	</table>
</form>
