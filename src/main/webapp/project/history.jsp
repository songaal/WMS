<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.ProjectHistoryDAO" %>
<%@ page import="co.fastcat.wms.bean.ProjectHistory2" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>

<%@include file="../inc/header.jsp"%>

<%
	String pid = request.getParameter("pid");
	String status = request.getParameter("status");
	
	ProjectHistoryDAO dao = new ProjectHistoryDAO();
	List<DAOBean> list = dao.selectProject(pid);
%>

<!-- 추가폼 -->
<div class="modal hide" id="insertModal" tabindex="-1" role="dialog"
	aria-labelledby="insertModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="insertModalLabel">회의록추가</h3>
	</div>
	<div class="modal-body">
		<form id="projectForm" method="post" action="doMaintain.jsp">
			<input type="hidden" name="action" />
			<input type="hidden" name="pid" value="<%=pid %>" />
			<input type="hidden" name="statusFilter" value="<%=status %>" />
			<input type="hidden" name="userId" value="<%=myUserInfo.serialId %>" />
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					
					<tr>
						<th>점검일자</th>
						<td>
						<div class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="maintainDate" type="text">
							<span class="add-on"><i class="icon-th"></i></span>
						</div>
						</td>
					</tr>
					<tr>
						<th>완료일자</th>
						<td>
						<div class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="doneDate" type="text">
							<span class="add-on"><i class="icon-th"></i></span>
						</div>
						</td>
					</tr>
					<tr>
						<th>점검내용</th>
						<td><textarea name="maintainList" class="mid"></textarea></td>
					</tr>
					<tr>
						<th>처리내용</th>
						<td><textarea name="result" class="mid"></textarea></td>
					</tr>
					<tr>
						<th>코멘트</th>
						<td><textarea name="comment" class="mid"></textarea></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onClick="insertProjectMaintain()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 추가폼 -->

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
			
			<%@include file="incProjectSubmenu.jsp" %>
			
			<br/>
			<br/>
			
			<table class="table table-bordered table-hover table-condensed">
				<colgroup>
					<col width="150">
					<col width="100">
					<col width="100">
					<col width="*">
				</colgroup>
				<tbody>
				<tr>
					<th>날자</th>
					<th>구분</th>
					<th>담당자</th>
					<th>내용</th>
				</tr>
				<%
				if(list.size() == 0){
				%>
				<tr>
				<td colspan="4">히스토리 내역이 없습니다.</td>
				</tr>
				<%				
				}
				%>
				<%
				Date prevDate = null;
				String anchor = "";
				for(int i=0; i<list.size(); i++){
					ProjectHistory2 info = (ProjectHistory2) list.get(i);
					anchor = "/WMS/project/";
					
					if ( info.type.equals("회의록")) {
						anchor = anchor + "meetings.jsp?pid=";	
					} else if ( info.type.equals("요청") ) {
						anchor = anchor + "request.jsp?pid=";	
					} else if ( info.type.equals("정기점검")) {
						anchor = anchor + "maint.jsp?pid=";
					} else if ( info.type.equals("작업")) {
						anchor = anchor + "work.jsp?pid=";
					} else if ( info.type.equals("작업내역")) {
						anchor = "/WMS/todo/index.jsp?wid="+info.wid+"&pid=";
					} else {
						anchor = anchor + "info.jsp?pid=";
					}
					
					anchor = anchor + info.pid + "&status=B#" + info.wid+"";	
					
					if(info.projectName==null) {
						anchor="";
					}
					
					if(WebUtil.isPrevYear(info.regdate, prevDate)){
						String dateStr = WebUtil.toHangulYearMonthString(info.regdate);
					%>
						<tr class="info">
						<td colspan="4"><strong><%=dateStr.substring(0, 5) %></strong></td>
						</tr>
					<%
					}
					
					if(WebUtil.isPrevMonth(info.regdate, prevDate)){
						String dateStr = WebUtil.toHangulYearMonthString(info.regdate);
					%>
						<tr class="warning">
						<td colspan="4"><strong><%=dateStr.substring(6) %></strong></td>
						</tr>
					<%
					}
					
					prevDate = info.regdate;
				%>
				<tr>
					<td><%=WebUtil.toDateStringWithYoil(info.regdate) %></td>
					<td><%=WebUtil.getValue(info.type) %></td>
					<td><%=info.userName %></td>
					<td>
					<%if(!"".equals(anchor)) {%>
						<a href="<%=anchor %>"><%=WebUtil.getMultiLineValue(info.memo) %></a>
					<% } else { %>
						<%=WebUtil.getMultiLineValue(info.memo) %>
					<% } %>
					</td>
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



