<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	RestDataDAO historyDAO = new RestDataDAO();
	List<RestData> issueList = historyDAO.selectIssue(myUserInfo.serialId);
	List<RestData> spentList = historyDAO.selectSpent(myUserInfo.serialId);
%>

<div class="container ">
	<div class="row">
		<div class="span12">
			<h2 id="body-copy">개인설정</h2>
		</div>
		<!-- 좌측메뉴 -->
		<%@include file="leftMenu.jsp"%>
		<!--// 좌측메뉴 -->
		
		<!-- 메인내용 -->
		<div class="span9">
			<h4 id="body-copy">휴가</h4>
			<p>휴가히스토리</p>
			<div class="btn-group pagination-centered">
				<a class="btn btn-small" href="rest.jsp">정보</a>
				<button class="btn btn-small active">히스토리</button>
			</div>
			<p><%=myUserInfo.part%> <strong><%=myUserInfo.userName%></strong> <%=myUserInfo.title%></p>
			
			<div class="row">
			<div class="span6">
				<h4>발급내역</h4>
				<table class="table table-hover table-bordered">
					<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>휴가종류</th>
					<th>일수</th>
					<th>내용</th>
					</tr>
					<%
						float total = 0.0f;
						for(int i=0; i<issueList.size(); i++){
							RestData history = issueList.get(i);
							total += history.amount;
						}
					%>
					<tr class="info">
					<td colspan="3"><strong>총계</strong></td>
					<td><%=total%></td>
					<td></td>
					</tr>
					<%
						for(int i=0; i<issueList.size(); i++){
									RestData history = issueList.get(i);
					%>
					<tr>
					<td><%=issueList.size() - i%></td>
					<td><%=WebUtil.toDateString(history.applyDate)%></td>
					<td><%=BusinessUtil.getRestCategoryName(history.category)%></td>
					<td><%=history.amount%></td>
					<td><%=WebUtil.getValue(history.memo) %></td>
					</tr>
					<%
						}
					%>
					
				</table>
			</div>
			
			<div class="span6">
				<h4>사용내역</h4>
				<table class="table table-hover table-bordered">
					<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>휴가종류</th>
					<th>일수</th>
					<th>내용</th>
					<%
						total = 0.0f;
						for(int i=0; i<spentList.size(); i++){
							RestData history = spentList.get(i);
							total += history.amount;
						}
					%>
					<tr class="info">
					<td colspan="3"><strong>총계</strong></td>
					<td><%=total%></td>
					<td></td>
					</tr>
					<%
						for(int i=0; i<spentList.size(); i++){
							RestData history = spentList.get(i);
					%>
					<tr>
					<td><%=spentList.size() - i %></td>
					<td><%=WebUtil.toDateString(history.applyDate) %></td>
					<td><%=BusinessUtil.getRestCategoryName(history.category) %></td>
					<td><%=history.amount %></td>
					<td><%=WebUtil.getValue(history.memo) %></td>
					</tr>
					<%
					}
					%>
				</table>
			</div>
			</div>
		</div>
	</div>

</div>

<%@include file="../inc/footer.jsp"%>



