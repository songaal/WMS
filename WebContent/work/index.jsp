<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	String dateStr = request.getParameter("dateStr");
	String isWeekStr = request.getParameter("week");
	boolean isWeek = "true".equals(isWeekStr);
	
	Date reqDate = WebUtil.parseDate(dateStr);//java.util.Date
	if(reqDate == null){
		reqDate = new Date();
	}
	logger.debug("reqDate >> {}", reqDate);
	boolean isToday = WebUtil.isToday(reqDate);
	
	String reqDateStr = WebUtil.toDateString(reqDate);
	Date today = new Date();
	String todayStr = WebUtil.toDateString(today);
	Date todayStartTime = WebUtil.get0Time(today);
%>

<!-- 시작보고폼 -->
<input type="hidden" class="hidden" id="reqDateStr" value="<%=reqDateStr %>" />
<input type="hidden" class="hidden" id="submitWorkReceiver" value="W001" /><!-- //TODO 향후에는 롤에 따라서 변경될수 있도록.. -->
 
<div class="modal hide" id="startWorkModal" tabindex="-1" role="dialog" aria-labelledby="startWorkModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="startWorkModalLabel">업무시작보고</h3>
	</div>
	<div class="modal-body">
		<table class="table table-hover table-condensed table-striped">
			<colgroup>
				<col width="160">
				<col width="">
			</colgroup>
			<tbody>
				<tr>
					<th>특이사항</th>
					<td><textarea class="mid" id="startWorkComment"></textarea></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="submitWorkCheck('start')">보내기</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 시작보고폼 -->
<!-- 마감보고폼 -->
<div class="modal hide" id="finishWorkModal" tabindex="-1" role="dialog" aria-labelledby="finishWorkModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="finishWorkModalLabel">업무마감보고</h3>
	</div>
	<div class="modal-body">
		<table class="table table-hover table-condensed table-striped">
			<colgroup>
				<col width="160">
				<col width="">
			</colgroup>
			<tbody>
				<tr>
					<th>특이사항</th>
					<td><textarea class="mid" id="finishWorkComment"></textarea></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="submitWorkCheck('finish')">보내기</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 마감보고폼 -->


<form id="projectForm" class="hide">
	<input type="hidden" name="userSID" value="<%=myUserInfo.serialId %>"/>
</form>


<li id="projectElTemplate" name="projectLi" class="hide">
	<div class="project handleP">
		<input type="hidden" name="wid" />
		<input type="hidden" name="pid" />
		<strong><a href="#" target="_project"><small>New Project</small></a></strong>
		<button class="tools" onClick="removeProjectClick(this)">삭제</button>
		<button class="tools" onClick="addSubjectClick(this)">주제추가</button>
	</div>
	<ul name="subjectList" class="subjectList">
	</ul>
</li>

<li id="subjectElTemplate" name="subjectLi" class="hide">
	<div class="bs-docs-subject">
		<p class="subject handleS">
			<input type="hidden" name="sid" />
			<small><span class="subjectText"></span></small>
			<span name="infoBox" class="hide input-append">
			<!-- <button onClick='updateSubjectClick(this)'>확인</button> -->
			<button onClick='removeSubjectClick(this)'>삭제</button></span>
		</p>
		<button class="tools icon-plus" onClick="addTaskClick(this)"></button>
		<ul class="taskList">
		</ul>
	</div>
</li>
		
<li id="taskElTemplate" name="taskLi" class="hide">
	<div name="taskDiv" class="taskDiv checkbox handleT">
		<input type="hidden" name="tid" /> 
		<input type="checkbox" class="taskCheck" />
		<div class="taskContents">
			<textarea class="textarea-large"></textarea>
			<span name="timeStr" class="taskTimeInfo hide"><span name="timeValue" class="label">0H</span></span>
			<div name="infoBox" class="input-append">
				<select name="time" class="span3"><option value="">[예상시간]</option><option value="30m" selected>30분</option>
					<option value="1H">1시간</option><option value="2H">2시간</option><option value="3H">3시간</option><option value="4H">4시간</option>
					<option value="5H">5시간</option><option value="6H">6시간</option><option value="7H">7시간</option><option value="8H">8시간</option>
				</select>
			</div>
		</div>
	</div>
</li>

<!-- 처음 작업큐 생성에서만 쓰이는 폼. 작업큐는 하루에 1개만 존재. -->
<li id="workQueueElTemplate" name="subjectLi" class="hide">
	<div class="bs-docs-subject workQueueSubject">
		<p class="subject hide">
			<input type="hidden" name="sid" value="-1">
		</p>
		<button class="tools icon-plus" onClick="addTaskClick(this)"></button>
		<ul class="taskList">
		</ul>
	</div>
</li>


<div class="container ">
	<div class="row">

		<div class="span12">
			<h2 id="body-copy">업무</h2>
			<p>날짜별 프로젝트별 업무확인</p>

			<div class="row-fluid">
				<!-- 좌측메뉴 -->
				<div class="span3 bs-docs-sidebar">
				<!-- div class="bs-docs-sidenav" data-spy="affix" data-offset-top="114" data-offset-bottom="270"-->
	
					
					<div class="input-append date" id="workDatePicker" data-date="<%=reqDateStr %>" data-date-format="yyyy.mm.dd" >
						<input class="input-small" size="16" type="text" value="<%=reqDateStr %>" readonly>
						<span class="add-on"><i class="icon-calendar"></i></span>
						<span class="btn" onClick="goTodayWork()">오늘</span>
					</div>
					
					<ul class="nav nav-list bs-docs-sidenav">
						<li class="<%=isWeek?"active":""%>"><a href="javascript:goWeekWork('<%=reqDateStr %>')"><i class="icon-chevron-right"></i><%=WebUtil.toMonthWeekString(reqDate) %> 종합 </a></li>
						<%
						List<Date> dateList = WebUtil.getListOfThisWeek(reqDate);
						for(int i=0; i< dateList.size(); i++) {
							Date date = dateList.get(i);
							if(date.equals(reqDate) && !isWeek){
						%>
						<li class="active"><a><i class="icon-chevron-right"></i><%=WebUtil.toDateYoilString(date) %></a></li>
						<%
							}else{
						%>
						<li><a href="javascript:goDateStrWork('<%=WebUtil.toDateString(date) %>')"><i class="icon-chevron-right"></i><%=WebUtil.toDateYoilString(date) %></a></li>
						<%
							}
						}
						%>
					</ul>
					
					<ul class="nav nav-list bs-docs-sidenav">
						<li class=""><a href="checkList.jsp"><i class="icon-check gray1"></i> 체크리스트</a></li>
						<li class=""><a href="request.jsp"><i class="icon-download gray1"></i> 업무요청큐</a></li>
						<!-- <li class=""><a href="schedule.jsp"><i class="icon-calendar gray1"></i> 스케쥴</a></li> -->
					</ul>

				<!--/div-->
				</div>


				<!-- 메인내용 -->
				<div class="span6">
					<% if(!isWeek){ %>
					<div>
						<a href="javascript:initWorkQueue()"><i class="icon-tasks"></i><small>작업큐생성</small></a>
						<a href="javascript:viewAddProject()"><i class="icon-plus-sign"></i><small>프로젝트추가</small></a>
						<%
						//업무보고는 당일자만 가능하다.
						if(isToday){ 
						%>
						<a href="#finishWorkModal" class="pull-right" role="button" data-toggle="modal"><i class="icon-share-alt"></i><small>업무마감보고</small></a>
						<a href="#startWorkModal" class="pull-right" role="button" data-toggle="modal"><i class="icon-share-alt"></i><small>업무시작보고</small></a>
						<%
						}
						%>
					</div>
					<% } %>
					<!-- 내용추가폼 -->
					<div class="alert hide" id="addProject">
					<table>
						<tr>
						<td>
						외부
						</td>
						<td>
						내부
						</td>
						</tr>
						<tr>
						<td>
						<select id="myProject" multiple="multiple" size="10" onDblClick="addProjectClick()">
							<%
							ProjectDAO projectDAO = new ProjectDAO();
							List<ProjectInfo> list = projectDAO.selectTypeOutAlive();
							for(int i=0; i< list.size(); i++){
								ProjectInfo info = list.get(i);
							%>
							<option value="<%=info.pid %>"><%=info.name %></option>
							<%
							}
							%>
						</select>
						<input type="hidden" name="regdate" value="<%=WebUtil.toDateTimeString(reqDate)%>" />
						</td>
						<td>
						<select id="mySolution" multiple="multiple" size="10" onDblClick="addSolutionClick()">
							<%
							List<ProjectInfo> listIn = projectDAO.selectTypeInAlive();
							for(int i=0; i< listIn.size(); i++){
								ProjectInfo info = listIn.get(i);
							%>
							<option value="<%=info.pid %>"><%=info.name %></option>
							<%
							}
							%>
						</select>
						<input type="hidden" name="regdate" value="<%=WebUtil.toDateTimeString(reqDate)%>" />
						</td>
						</tr>
						<tr>
						<td colspan="2">
						<!-- <button class="btn btn-primary" onClick="addProjectClick()">추가</button> -->
						<button class="btn" onClick="$('#addProject').hide()">닫기</button>
						</td>
						</tr>
						</table>
					</div>
					<!--// 내용추가폼 -->
					
					<div class="workList">
<%
WorkDAO dao = new WorkDAO();
WorkSubjectDAO subjectDAO = new WorkSubjectDAO();
WorkTaskDAO taskDAO = new WorkTaskDAO();

List<DAOBean> workList = null;

if(isWeek){
	workList = dao.selectWeek(myUserInfo.serialId, reqDate, false);
}else{
	workList = dao.select(myUserInfo.serialId, reqDate, false);
}

//workQueue가 생성되어 있지 않다면 빈 ul 준비.
if(workList.size() == 0){
%>
<div>
<div class="project hide">
	<input type="hidden" name="wid" />
	<input type="hidden" name="pid" value="-1" />
</div>
<ul id="workQueue" class="subjectList left0"></ul>
</div>
<%	
}

//workQueue가 있다면 보여준다.
for(int i=0;i<workList.size(); i++){
	WorkInfo2 workInfo = (WorkInfo2) workList.get(i);
	int wid = workInfo.id;
	int sid = -1;
%>

<div>
<div class="project hide">
	<input type="hidden" name="wid" value="<%=wid %>" />
	<input type="hidden" name="pid" value="-1" />
</div>
<ul id="workQueue" class="subjectList left0">
	<li name="subjectLi" class="">
		<div class="bs-docs-subject workQueueSubject">
			<p class="subject hide">
				<input type="hidden" name="sid" value="<%=sid %>">
			</p>
			<button class="tools icon-plus" onClick="addTaskClick(this)"></button>
			<ul class="taskList sortableTaskList">
			<%
				List<WorkTask> taskList = taskDAO.select(wid, sid);
				for(int k=0; k<taskList.size(); k++) {
					WorkTask task = taskList.get(k);
					int tid = task.id;
				
			%>
				<li name="taskLi">
					<div name="taskDiv" class="taskDiv checkbox handleT">
						<input type="hidden" name="tid" value="<%=tid %>"/> 
						<input type="checkbox" class="taskCheck" <%=task.status == 1?"checked":""%>/> 
						<div class="taskContents <%=task.status == 1?"task_done":""%>">
							<span class="taskText"><%=task.memo %></span>
							<span name="timeStr" class="taskTimeInfo"><span name="timeValue" class="label"><%=task.time %></span></span>
							<div name="infoBox" class="hide input-append">
								<select name="time" class="span3">
									<option value="">[예상시간]</option>
									<option value="30m" <%="30m".equals(task.time)?"selected":"" %>>30분</option>
									<%
									for(int d=1;d<=8;d++) {
										String timeValue = d+"H";
									%>
										<option value="<%=d %>H" <%=timeValue.equals(task.time)?"selected":"" %>><%=d %>시간</option>
									<%
									}
									%>
								</select>
							</div>
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
<%
}
%>
<ul id="projectList" class="projectList <%=isWeek?"":"sortableProjectList" %>" >

<%


if(isWeek){
	workList = dao.selectWeek(myUserInfo.serialId, reqDate, true);
}else{
	workList = dao.select(myUserInfo.serialId, reqDate, true);
}
for(int i=0;i<workList.size(); i++){
	WorkInfo2 workInfo = (WorkInfo2) workList.get(i);
	int wid = workInfo.id;
	int pid = workInfo.pid;
	List<WorkSubject> subjectList = subjectDAO.select(wid);
%>

<li name="projectLi">
	<div class="project handleP">
		<input type="hidden" name="wid" value="<%=wid %>">
		<input type="hidden" name="pid" value="<%=pid %>">
		<strong><a href="/WMS/project/info.jsp?pid=<%=pid %>&status=B" target="_project"><small><%=workInfo.projectName %></small></a></strong>
		<% if(!isWeek) { %>
		<button class="tools" onClick="removeProjectClick(this)">삭제</button>
		<% } %>
		<button class="tools" onClick="addSubjectClick(this)">주제추가</button>
	</div>
	<ul name="subjectList" class="subjectList sortableSubjectList">
		<%
		for(int j=0; j<subjectList.size(); j++){
			WorkSubject workSubjectInfo = (WorkSubject) subjectList.get(j);
			int sid = workSubjectInfo.id;
			List<WorkTask> taskList = taskDAO.select(wid, sid);
		%>
		<li name="subjectLi">
		<div class="bs-docs-subject">
			<p class="subject handleS">
				<input type="hidden" name="sid" value="<%=sid %>">
				<small><span class="subjectText"><%=workSubjectInfo.title %></span></small>
				<span name="infoBox" class="hide input-append"><!-- <button onClick='updateSubjectClick(this)'>확인</button> --><button onClick='removeSubjectClick(this)'>삭제</button></span>
			</p>
			<button class="tools icon-plus" onClick="addTaskClick(this)"></button>
			<ul class="taskList sortableTaskList">
			<%
				for(int k=0; k<taskList.size(); k++) {
					WorkTask task = taskList.get(k);
					int tid = task.id;
				
			%>
				<li name="taskLi">
					<div name="taskDiv" class="taskDiv checkbox handleT">
						<input type="hidden" name="tid" value="<%=tid %>"/> 
						<input type="checkbox" class="taskCheck" <%=task.status == 1?"checked":""%>/> 
						<div class="taskContents <%=task.status == 1?"task_done":""%>">
							<span class="taskText"><%=task.memo %></span>
							<span name="timeStr" class="taskTimeInfo"><span name="timeValue" class="label"><%=task.time %></span></span>
							<div name="infoBox" class="hide input-append">
								<select name="time" class="span3">
									<option value="">[예상시간]</option>
									<option value="30m" <%="30m".equals(task.time)?"selected":"" %>>30분</option>
									<%
									for(int d=1;d<=8;d++) {
										String timeValue = d+"H";
									%>
										<option value="<%=d %>H" <%=timeValue.equals(task.time)?"selected":"" %>><%=d %>시간</option>
									<%
									}
									%>
								</select>
							</div>
						</div>
					</div>
					
				</li>
			<%
				}
			%>
			</ul>
		</div>
		</li>
		<%
		} //for(int j=0; j<subjectList.size(); j++){
		%>
	</ul>

</li>
<%
}
%>

</ul>					
					
					
					</div>
					
				</div>
				<!--// 메인내용 -->
				
				
				<!-- 보조내용 -->
				<div class="span3">
					<%@include file="rightList.jsp"%>
				</div>
				<!--// 보조내용 -->
				
			</div>

		</div>
	</div>
	<!-- row -->
</div>
<!-- container -->

<%@include file="../inc/footer.jsp"%>




