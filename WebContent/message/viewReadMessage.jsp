<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@include file="../inc/session.jsp"%>
<%
	MessageDAO messageDAO = new MessageDAO();

	String messageId = request.getParameter("id");
	String viewType = request.getParameter("viewType");
	MessageInfo2 messageInfo = null;
	
	if(viewType.equals("send")){
		messageInfo = messageDAO.readSend(myUserInfo.serialId, messageId);
	}else if(viewType.equals("receive")){
		messageInfo = messageDAO.readReceive(myUserInfo.serialId, messageId);
	}
	
%>

<table class="table table-hover table-condensed table-striped">
	<colgroup>
		<col width="160">
		<col width="">
	</colgroup>
	<tbody>
		<tr>
			<th>보낸사람</th>
			<td><%=messageInfo.senderName %><input type="hidden" name="sender" value="<%=messageInfo.sender %>" /></td>
		</tr>
		<tr>
			<th>보낸시각</th>
			<td><%=WebUtil.toDateTimeString(messageInfo.sendDate)%></td>
		</tr>
		<tr>
			<th>받는사람</th>
			<td><%=messageInfo.receiverName %><input type="hidden" name="receiver" value="<%=messageInfo.receiver %>" /></td>
		</tr>
		<tr>
			<th>읽은시각</th>
			<td><%=WebUtil.toDateTimeString(messageInfo.receiveDate)%></td>
		</tr>
		<tr>
			<th>참조인</th>
			<td><%=WebUtil.getValue(messageInfo.referencerName)%></td>
		</tr>
		<tr>
			<th>제목</th>
			<%
			String title = messageInfo.title;
			if(title == null || title.length() == 0){
				title = "제목없음";
			}
			%>
			<td id="titleText"><%=title %></td>
		</tr>
		<tr>
			<td colspan="2" id="messageHtml"><%=WebUtil.getValue(messageInfo.message) %></td>
		</tr>
	</tbody>
</table>
