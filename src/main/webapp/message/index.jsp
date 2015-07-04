<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.MessageInfo2" %>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>
<%@ page import="co.fastcat.wms.dao.MessageDAO" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>

<%@include file="../inc/header.jsp"%>

<%
	String viewType = WebUtil.getValue(request.getParameter("viewType"), "receive"); //or "send"
	boolean isReceive = viewType.equals("receive");
	
	MessageDAO messageDAO = new MessageDAO();
	List<DAOBean> list = messageDAO.selectAll(myUserInfo.serialId, viewType);
%>

<!-- 메시지 읽기폼 -->
<div class="modal hide" id="readModal" tabindex="-1" role="dialog" aria-labelledby="readModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="modifyModalLabel"><%=isReceive?"받은메시지":"보낸메시지" %></h3>
	</div>
	<div id="message-content" class="modal-body"></div>
	<div class="modal-footer">
		<%
		if(isReceive) {
		%>
		<button class="btn btn-primary" onClick="replyMessage()">답장보내기</button>
		<%
		}
		%>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>

<div class="container ">
	<div class="row">
		<div class="span12">
		<h2 id="body-copy">업무연락</h2>
		</div>

		<!-- 왼쪽 리스트 -->
		<div class="span3 bs-docs-sidebar">
			<ul class="nav nav-list bs-docs-sidenav">
				<li class="<%=viewType.equals("receive")?"active":"" %>"><a href="index.jsp?viewType=receive"><i class="icon-chevron-right"></i> 받은메시지</a></li>
				<li class="<%=viewType.equals("send")?"active":"" %>"><a href="index.jsp?viewType=send"><i class="icon-chevron-right"></i> 보낸메시지</a></li>
				<li><a href="write.jsp"><i class="icon-chevron-right"></i> 메시지작성</a></li>
			</ul>
		</div>
		
		<!-- 메인내용 -->
		<div class="span9">
		
			<h4><%=viewType.equals("send")?"보낸메시지":"받은메시지" %></h4>
			<table class="table table-bordered table-hover table-condensed">
				<colgroup>
					<col width="100" />
					<col width="150" />
					<col width="150" />
					<col width="320" />
					<col width="150" />
					<col width="150" />
				</colgroup>
				<thead>
				<tr>
					<th>번호</th>
					<th><%=viewType.equals("send")?"받는사람":"보낸사람" %></th>
					<th>참조</th>
					<th>제목</th>
					<th>보낸시각</th>
					<th>확인시각</th>
				</tr>
				</thead>
				<tbody>
				<%
				if(list.size() == 0){
				%>
					<tr><td colspan="5">메시지가 없습니다.</td></tr>
				<%
				}
					
					for(int i=0; i<list.size(); i++) {
						MessageInfo2 messageInfo = (MessageInfo2) list.get(i);
						String title = BusinessUtil.getTitleValue(messageInfo.title);
						String classStr = "";
						if(messageInfo.receiveDate == null){
							classStr = "warning";
						}
				%>
				<tr class="<%=classStr %>">
					<td><%=list.size() -i%></td>
					<td><%=viewType.equals("send")?messageInfo.receiverName:messageInfo.senderName %></td>
					<td><%=WebUtil.getValue(messageInfo.referencerName) %></td>
					<%-- 받은메시지일 경우 읽음으로 표시해주고 보낸메시지는 그대로 둔다. --%>
					<td><a href="#" onClick="readMessage(<%=isReceive?"this":"''" %>, <%=messageInfo.id%>, '<%=viewType %>'); return false;"><%=title %></a></td>
					<td><%=WebUtil.toDateTimeString(messageInfo.sendDate) %></td>
					<td class="receiveDate"><%=WebUtil.toDateTimeString(messageInfo.receiveDate)%></td>
				</tr>
				
				<%
					}
				%>
				</tbody>
			</table>
		</div>
		
	</div>
</div>

<%@include file="../inc/footer.jsp"%>



