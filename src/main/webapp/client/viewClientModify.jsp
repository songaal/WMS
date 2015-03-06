<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@include file="../inc/session.jsp"%>
<%
	ClientDAO dao = new ClientDAO();
	request.setCharacterEncoding("utf-8");

	String id = request.getParameter("cid");
	
	ClientInfo info = dao.select(id);
	
%>
<form id="updateForm" method="post" action="doClient.jsp">
	<input type="hidden" name="action" /> 
	<input type="hidden" name="cid" value="<%=id%>" />
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>
			<tr>
				<th>회사명</th>
				<td><input type="text" name="clientName" value="<%=info.clientName%>"></td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td><input type="text" name="phone" value="<%=WebUtil.getValue(info.phone) %>" /></td>
			</tr>
			<tr>
				<th>주소</th>
				<td><input type="text" name="address" value="<%=WebUtil.getValue(info.address) %>" /></td>
			</tr>
			<tr>
				<th>메모</th>
				<td><textarea class="mid" name="memo"><%=WebUtil.getValue(info.memo) %></textarea></td>
			</tr>
		</tbody>
	</table>
</form>
