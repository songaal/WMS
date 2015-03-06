<%-- <%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<!-- 체크리스트 업무. -->
<li id="checkElTemplate" name="taskLi" class="hide">
	<div name="taskDiv" class="clDiv checkbox handleT">
		<input type="hidden" name="tid" /> 
		<input type="checkbox" class="clCheck" /> 
		<input type="text" name="checkTodo" class="input-large" />
		<span name="dueDateStr" class="taskRequestInfo rightPaneText hide"> ~<span name="timeValue">미정</span></span>
		<div name="infoBox" class="">
			<input name="duedate" class="input-small" size="16" type="text" data-date-format="yyyy.mm.dd" value="<%=reqDateStr %>" readonly>
		</div>
	</div>
</li>

<!-- 업무요청큐 추가폼 -->
<div class="modal hide" id="requestModal" tabindex="-1" role="dialog" aria-labelledby="requestModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="requestModalLabel">요청사항추가</h3>
	</div>
	<div class="modal-body">
		<form id="requestForm">
			<input type="hidden" name="action" value="insertAjax"/>
			<input type="hidden" name=pid value="-1"/>
			<input type="hidden" name="myId" value="<%=myUserInfo.serialId %>" />
			<input type="hidden" name="status" value="<%=ProjectRequest.STATUS_READY %>"/>
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					
					<tr>
						<th>요청일</th>
						<td>
						<div class="input-append date" data-date="<%=todayStr %>" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="regdate" type="text" value="<%=todayStr %>" required>
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
						</td>
					</tr>
					
					<tr>
						<th>요청자</th>
						<td>
						<input class="input-large" size="10" name="clientPname" type="text" placeholder="이름 직함" required minLength="3"/>
						</td>
					</tr>
					<tr>
						<th>요청방법</th>
						<td>
						<select name="method" required>
							<option value="">:: 선택 ::</option>
							<option value="이메일">이메일</option>
							<option value="전화">전화</option>
							<option value="구두">구두</option>
							<option value="기타">기타</option>
						</select>
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" name=title class="input-large" required minLength="4" maxLength="20" placeholder="고객사 및 요청제목"/></td>
					</tr>
					<tr>
						<th>요청내용</th>
						<td><textarea name=content class="mid" required minLength="4"></textarea></td>
					</tr>
					<tr>
						<th>처리담당자</th>
						<td><select name="userId" required></select></td>
					</tr>
					<tr>
						<th>처리기한</th>
						<td>
						<div class="input-append date" data-date="<%=todayStr %>" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="dueDate" type="text" value="<%=todayStr %>" required>
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
						</td>
					</tr>
					
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onClick="insertProjectRequest()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 추가폼 -->		


<div>
	<a rel="tooltip" class="wms_tooltip" data-placement="top" data-original-title="며칠안에 잊지말고 점검해야할 사항등을 적어둔다.">
	<i class="icon-check"></i><small>체크리스트</small></a>
	<ul class="subjectList left0">
		<li>
			<div class="bs-docs-subject workQueueSubject">
				<button class="tools icon-plus" onClick="addCheckListClick(this)"></button>
				<ul class="taskList sortableCheckList">
				<%
				
				List<WorkTask> taskList2 = taskDAO.selectCheckList(myUserInfo.serialId, todayStr);
				for(int i=0; i<taskList2.size(); i++){
					WorkTask workTask = taskList2.get(i);
					boolean isLate = false;
					if(workTask.duedate != null){
						isLate = workTask.duedate.before(todayStartTime);
					}
					logger.debug("{} : {}", workTask.duedate, todayStartTime);
				%>
				<li name="taskLi">
					<div name="taskDiv" class="clDiv checkbox handleT <%=workTask.status == 1?"task_done":""%>">
						<input type="hidden" name="tid" value="<%=workTask.id %>"/> 
						<input type="checkbox" class="clCheck"  <%=workTask.status == 1?"checked":""%>/> 
						<span class="taskText rightPaneText <%=isLate?"check_late":""%>"><%=workTask.memo %></span>
						<span name="dueDateStr" class="label"><span name="timeValue"><%=WebUtil.getDueDateDisplayStr(workTask.duedate) %></span></span>
						
						<div name="infoBox" class="hide">
							<input name="duedate" class="input-small duedate" size="16" type="text" data-date-format="yyyy.mm.dd" value="<%=WebUtil.toDateString(workTask.duedate) %>" readonly>
							<!-- <button class="btn" onClick="updateClClick(this)">확인</button>
							<button class="btn" onClick="removeClClick(this)">삭제</button> -->
						</div>
					</div>
				</li>
				<%
				}
				%>
				</ul>
			</div>
		</li>
	</ul>
</div>

<div>
	<a rel="tooltip" class="wms_tooltip" data-placement="top" data-original-title="외부에서 요청된 장애처리, 고객지원등의 업무요청들을 공유한다.">
	<i class="icon-download"></i><small>업무요청큐</small></a>
	<ul class="subjectList left0">
		<li>
			<div class="bs-docs-subject workQueueSubject">
				<button class="tools icon-plus" onClick="viewInsertProjectRequest()"></button>
				<ul class="taskList">
				<%
				ProjectRequestDAO requestDAO = new ProjectRequestDAO();
				List<DAOBean> requestList = requestDAO.selectRequestQueue(todayStr);
				for(int i=0; i<requestList.size(); i++){
					ProjectRequest2 requestInfo = (ProjectRequest2) requestList.get(i);
					boolean isLate = false;
					if(requestInfo.dueDate != null){
						isLate = requestInfo.dueDate.before(todayStartTime);
					}
					String content = WebUtil.getValue(requestInfo.content);
					if(content.length() > 50){
						content = content.substring(0, 50) + " ..";
					}
				%>
				<li>
					<input type="hidden" name="rid" value="<%=requestInfo.rid %>"/> 
					<a href="#" class="wms_popover" rel="popover" data-placement="left" data-original-title="<%=WebUtil.getValue(requestInfo.title) %>"
					data-content="<%=content %> &lt;br/>요청자: <%=WebUtil.getValue((requestInfo.clientPersonName==null)?requestInfo.clientPname:"") %> &lt;br/>요청일: <%=WebUtil.getDueDateDisplayStr(requestInfo.regdate) %> &lt;br/>&lt;br/>&lt;a href='request.jsp?rid=<%=requestInfo.rid %>&status=<%=requestInfo.status %>' class='btn btn-mini'>자세히&lt;/a>">
					<span class="taskText rightPaneText <%=isLate?"check_late":"" %>"><%=requestInfo.title %></span></a>
					<br/><span class="rightPaneText"><%=requestInfo.userName %></span> <span class="label"><%=WebUtil.getDueDateDisplayStr(requestInfo.dueDate) %></span>
				</li>
				<%
				}
				%>
				</ul>
			</div>
		</li>
	</ul>
</div>

<div>
	<i class="icon-calendar"></i><small>금주일정</small>
	<ul class="nav ckecklist">
		<%
		ScheduleDAO scheduleDAO = new ScheduleDAO();
		
		List<DAOBean> scheduleList = scheduleDAO.selectWeek(today);
		for(int i=0;i < scheduleList.size(); i++){
			ScheduleInfo2 info2 = (ScheduleInfo2) scheduleList.get(i);
			Calendar cal = Calendar.getInstance();
			cal.setTime(info2.startTime);
			String time = "";
			
			if(info2.allDay == 0){
				time = " "+WebUtil.toMiniTimeString(info2.startTime);
			}
			
			String classStr = "";
			if(WebUtil.isTheSameDay(today, info2.startTime)){
				classStr = "schedule_today";
			}
		%>
		<li class="<%=classStr %>">
			<span class="<%=classStr %>">
				[<%=WebUtil.getShortYoilString(cal) %>]<%=time %> <%=info2.title %> - <%=info2.userName %>
			</span>
		</li>
		<%
		}
		%>
	</ul>
</div>

<div>
	<i class="icon-calendar"></i><small>차주일정</small>
	<ul class="nav ckecklist">
		<%
		Calendar nextCal = Calendar.getInstance();
		nextCal.add(Calendar.DATE, 7);
		
		List<DAOBean> scheduleList2 = scheduleDAO.selectWeek(nextCal.getTime());
		for(int i=0;i < scheduleList2.size(); i++){
			ScheduleInfo2 info2 = (ScheduleInfo2) scheduleList2.get(i);
			Calendar cal = Calendar.getInstance();
			cal.setTime(info2.startTime);
			String time = "";
			
			if(info2.allDay == 0){
				time = " "+WebUtil.toMiniTimeString(info2.startTime);
			}
		%>
		<li class="">[<%=WebUtil.getShortYoilString(cal) %>]<%=time %> <%=info2.title %> - <%=info2.userName %></li>
		<%
		}
		%>
	</ul>
</div>
<!--// 보조내용 -->





 --%>