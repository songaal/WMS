<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	String pid = request.getParameter("pid");
	String status = request.getParameter("status");
	
	ProjectMeetingDAO dao = new ProjectMeetingDAO();
	List<DAOBean> list = dao.selectProject(pid);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	String nowDate = sdf.format(new Date());
%>

<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog"
	aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">회의 내용 수정</h3>
	</div>
	<div id="meeting-content" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifyProjectMeeting()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-danger" onclick="deleteProjectMeeting()">삭제</button>
	</div>
</div>
<!--// 수정폼 -->


<!-- 추가폼 -->
<div class="modal hide" id="insertModal" tabindex="-1" role="dialog"
	aria-labelledby="insertModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="insertModalLabel">회의록추가</h3>
	</div>
	<div class="modal-body">
		<form id="projectForm" method="post" action="doMeeting.jsp">
			<input type="hidden" name="action" />
			<input type="hidden" name="pid" value="<%=pid %>" />
			<input type="hidden" name="statusFilter" value="<%=status %>" />
			<input type="hidden" name="userId" value="<%=myUserInfo.serialId %>" />
			<input type="hidden" name="regdate" value="<%=WebUtil.toDateString(new Date()) %>" />
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					
					<tr>
						<th>회의일자</th>
						<td>
						<div class="input-append date required" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="meetDate" type="text" value="<%=nowDate%>" >
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
						</td>
					</tr>
					<tr>
						<th>장소</th>
						<td><input type="text" name=place class="input-large required" /></td>
					</tr>
					<tr>
						<th>웹스퀘어드참가자</th>
						<td>
						<input class="input-large required" name="websqrdUser" type="text">
						</td>
					</tr>
					<tr>
						<th>고객참가자</th>
						<td>
						<input class="input-large required" name="clientUser" type="text">
						</td>
					</tr>
					<tr>
						<th>회의내용</th>
						<td><textarea name="content" class="long required"></textarea></td>
					</tr>
					<tr>
						<th>향후작업</th>
						<td><textarea name="nextTodo" class="mid"></textarea></td>
					</tr>
					<tr>
						<th>향후일정</th>
						<td><textarea name="nextSchedule" class="mid"></textarea></td>
					</tr>					
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onClick="insertProjectMeeting()">저장</button>
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
			
			<p>
			<button class="btn btn-info btn-small" onClick="viewInsertProjectMeeting()">회의록추가</button>
			</p>
				
			<%
			if(list.size() == 0){
			%>
			<table class="table table-bordered table-condensed">
			<tr><td>회의록이 없습니다.</td></tr>
			</table>
			<%				
			}
			%>
			
			<%
			Date prevDate = null;
			for(int i=0; i<list.size(); i++){
				ProjectMeeting2 info = (ProjectMeeting2) list.get(i);
			
				if(WebUtil.isPrevMonth(info.regdate, prevDate)){
				%>
					<p class="project"><%=WebUtil.toHangulYearMonthString(info.regdate) %></p><br/>
				<%
				}
				prevDate = info.regdate;
			%>
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="100">
					<col width="*">
				</colgroup>
				<tbody>
					<tr>
					<th>회의번호</th>
					<td><a name="<%=WebUtil.getValue(info.mid) %>">#<%=WebUtil.getValue(info.mid) %></a></td>
					</tr>
					<tr>
					<th>일자</th>
					<td><%=WebUtil.toDateStringWithYoil(info.meetDate) %></td>
					</tr>
					<tr>
					<th>장소</th>
					<td><%=info.place %></td>
					</tr>
					<tr>
					<th>담당자</th>
					<td><%=info.userName %></td>
					</tr>
					<tr>
					<th>웹스퀘어드참가자</th>
					<td><%=info.websqrdUser%></td>
					</tr>
					<tr>
					<th>참가자</th>
					<td><%=info.clientUser%></td>
					</tr>
					<tr>
					<th>회의내용</th>
					<td><%=WebUtil.getMultiLineValue(info.content) %></td>
					</tr>
					<tr>
					<th>향후작업</th>
					<td><%=WebUtil.getMultiLineValue(info.nextTodo) %></td>
					</tr>
					<tr>
					<th>향후일정</th>
					<td><%=WebUtil.getMultiLineValue(info.nextSchedule) %></td>
					</tr>
					
					<tr>
					<th>수정</th>
					<td>
					<button class="btn btn-info btn-small"
					onClick="javascript:viewModifyMeetingInfo('<%=info.mid%>')">
						회의록 수정 		
					</td>
					</tr>
					
				</tbody>
			</table>
			<%
			}
			%>
			
		</div>
		
	</div>
</div>

<%@include file="../inc/footer.jsp"%>



