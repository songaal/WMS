<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	request.setCharacterEncoding("utf-8");
	String receiver = WebUtil.getValue(request.getParameter("receiver"));
	String title = WebUtil.getValue(request.getParameter("title"));
	String message = WebUtil.getValue(request.getParameter("message"));
	
%>
<div class="container ">
	<div class="row">
		<div class="span12">
		<h2 id="body-copy">업무연락</h2>
		</div>

		<!-- 왼쪽 리스트 -->
		<div class="span3 bs-docs-sidebar">
			<ul class="nav nav-list bs-docs-sidenav">
				<li><a href="index.jsp?viewType=receive"><i class="icon-chevron-right"></i> 받은메시지</a></li>
				<li><a href="index.jsp?viewType=send"><i class="icon-chevron-right"></i> 보낸메시지</a></li>
				<li class="active"><a href="write.jsp"><i class="icon-chevron-right"></i> 메시지작성</a></li>
			</ul>
		</div>
		
		<!-- 메인내용 -->
		<div class="span9">
		
			<h4>메시지작성</h4>
			<form id="messageForm" action="doMessage.jsp" method="POST">
			<input type="hidden" name="action" value="sendMessage" />
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="150" />
					<col width="*" />
				</colgroup>
				<tbody>
				<tr>
					<th>받는사람</th>
					<td>
						<select id="receiverSelect" name="receiver" class="required">
						</select>
					</td>
				</tr>
				<tr>
					<th>참조인</th>
					<td>
						<select id="referencerSelect" name="referencer" class="">
						</select>
					</td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" id="messageTitle" name="title" class="input-xxlarge" value="<%=title %>" placeholder="생략가능"></td>
				</tr>
				<tr>
					<td colspan="2"><textarea id="messageTextarea"></textarea>
						<textarea name="message" class="hide required" min-length="5"><%=message %></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2"><button class="btn btn-primary" type="button" onClick="sendMessage()">보내기</button></td>
				</tr>
				</tbody>
			</table>
			</form>
		</div>
		
	</div>
</div>

<%@include file="../inc/footer.jsp"%>
<script>
selectUser = "<%=receiver %>";
</script>

