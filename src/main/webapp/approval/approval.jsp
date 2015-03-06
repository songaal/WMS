<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>
<%
	String showType = WebUtil.getValue(request.getParameter("showType"), "notYet");
	boolean isDone = showType.equals("done");//완료인지.
	
	ApprovalDAO dataDAO = new ApprovalDAO();
	List<DAOBean> list = null;
	if(showType.equals("notYet")){
		list = dataDAO.selectApprovalWait(myUserInfo.serialId);
	}else if(showType.equals("done")){
		list = dataDAO.selectApprovalDone(myUserInfo.serialId);	
	}
%>

<!-- 결재 읽기폼 -->
<div class="modal hide" id="readModal" tabindex="-1" role="dialog" aria-labelledby="readModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">결재사항</h3>
	</div>
	<div id="message-content" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>

<div class="container ">
	<div class="row">
		<div class="span12">
		<h2 id="body-copy">결재</h2>
		</div>

		<!-- 왼쪽 리스트 -->
		<div class="span3 bs-docs-sidebar">
			<ul class="nav nav-list bs-docs-sidenav">
				<li class=""><a href="index.jsp?showType=notYet"><i class="icon-chevron-right"></i> 진행중</a></li>
				<li class=""><a href="index.jsp?showType=done"><i class="icon-chevron-right"></i> 결재완료</a></li>
			</ul>
			<ul class="nav nav-list bs-docs-sidenav">
				<li class="<%=showType.equals("notYet")?"active":"" %>"><a href="approval.jsp?showType=notYet"><i class="icon-chevron-right"></i> 결재할목록</a></li>
				<li class="<%=isDone?"active":"" %>"><a href="approval.jsp?showType=done"><i class="icon-chevron-right"></i> 결재완료목록</a></li>
			</ul>
		</div>
		
		<!-- 메인내용 -->
		<div class="span9">
			<h4><%=isDone?"결재완료목록":"결재할목록" %></h4>
			<table class="table table-bordered table-hover table-condensed">
				<colgroup>
					<col width="*" />
					<col width="100" />
					<col width="150" />
					<col width="120"/>
					<col width="120" />
					<col width="180" />
					<col width="120" />
				</colgroup>
				<thead>
				<tr>
					<th>번호</th>
					<th>결재단계</th>
					<th>요청자</th>
					<th>결재종류</th>
					<th>최종결과</th>
					<th>상신시간</th>
					<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
				<%
				if(list.size() == 0){
				%>
					<tr><td colspan="7">결재내역이 없습니다.</td></tr>
				<%
				}
					for(int i=0; i<list.size(); i++) {
						ApprovalInfo2 data = (ApprovalInfo2) list.get(i);
				%>
				<tr id="tr_<%=data.id%>">
					<td><%=list.size() -i%></td>
					<td><%=data.resUserStep%> / <%=data.resUserCount%></td>
					<td><%=WebUtil.getValue(data.reqUserName)%></td>
					<td><%=BusinessUtil.getApprovalTypeName(data.type)%></td>
					<td><%=BusinessUtil.getApprovalResultDisplayName(data.status)%></td>
					<td><%=WebUtil.toDateTimeString(data.reqDatetime)%></td>
					<td><button onClick="viewDetail('<%=data.type%>', <%=data.id%>, <%=data.aprvId%>, '<%=showType %>')">상세보기</button></td>
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



