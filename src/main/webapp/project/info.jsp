<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>
<%@ page import="co.fastcat.wms.bean.ProjectInfo2" %>

<%@include file="../inc/header.jsp"%>

<%
	String status = WebUtil.getValue(request.getParameter("status"), ProjectInfo.STATUS_ONGOING);
	String pid = request.getParameter("pid");
	ProjectDAO projectDAO = new ProjectDAO();
	ProjectInfo2 info = projectDAO.selectTypeOut(pid);
%>

<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog"
	aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">프로젝트수정</h3>
	</div>
	<div id="project-content" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifyProject()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-danger" onclick="deleteProject()">삭제</button>
	</div>
</div>
<!--// 수정폼 -->

<div class="container ">
	<div class="row">
		<div class="span12">
		<h2 id="body-copy">프로젝트</h2>
		</div>
		<br>
		<!-- 왼쪽 프로젝트 리스트 -->
		<%@include file="incProjectLeft.jsp"%>

		<!-- 메인 내용 -->
		<div class="span9">
		
		<%@include file="incProjectSubmenu.jsp"%>
			
			<p>
				<button onClick="viewModifyProjectInfo('<%=pid %>', '<%=status %>')"
					class="btn btn-info btn-small pull-right">프로젝트수정</button>
			</p>
			<br/>
			<table class="table table-bordered table-hover table-condensed">
				
				<tr>
				<th class="span3">프로젝트명</th>
				<td><%=info.name %></td>
				</tr>
				<tr>
				<th>담당자</th>
				<td><%=info.pmName %></td>
				</tr>
				<tr>
				<th>시작일</th>
				<td><%=WebUtil.toDateString(info.startDate) %></td>
				</tr>
				<tr>
				<th>종료일</th>
				<td><%=WebUtil.toDateString(info.endDate) %></td>
				</tr>
				
				<tr>
				<th>고객사</th>
				<td><%=info.clientName %> <%=info.clientPersonName %></td>
				</tr>
				
				<tr>
				<th>고객연락처</th>
				<td><i class="icon-user"></i> <%=WebUtil.getValue(info.clientCellPhone) %><br/>
				<i class="icon-home"></i> <%=WebUtil.getValue(info.clientPhone) %><br/>
				<i class="icon-envelope"></i> <%=WebUtil.getValue(info.clientEmail) %></td>
				</tr>
				<%
				if(info.resellerName != null){
				%>
				<tr>
				<th>구축업체</th>
				<td><%=WebUtil.getValue(info.resellerName) %> <%=WebUtil.getValue(info.resellerPersonName) %></td>
				</tr>
				<tr>
				<th>구축업체 연락처</th>
				<td><i class="icon-user"> </i><%=WebUtil.getValue(info.resellerCellPhone) %><br/>
				<i class="icon-home"></i> <%=WebUtil.getValue(info.resellerPhone) %><br/>
				<i class="icon-envelope"> </i><%=WebUtil.getValue(info.resellerEmail) %></td>
				</tr>
				<%
				}
				%>
			
				<tr>
				<th>프로젝트내용</th>
				<td><%=WebUtil.getValue(info.description) %></td>
				</tr>
				
				<tr>
				<th>납품솔루션</th>
				<td><%=info.solution%></td>
				</tr>
				<tr>
				<th>라이센스</th>
				<td><%=WebUtil.getValue(info.license) %></td>
				</tr>
				<tr>
				<th>상태</th>
				<td><%=BusinessUtil.getProjectStatus(info.status) %></td>
				</tr>

				<tr>
				<th>유지보수시작</th>
				<td><%=WebUtil.toDateString(info.mStartDate) %></td>
				</tr>
				
				<tr>
				<th>유지보수종료</th>
				<td><%=WebUtil.toDateString(info.mEndDate) %></td>
				</tr>
			</table>
		</div>
		
	</div>
</div>

<%@include file="../inc/footer.jsp"%>



