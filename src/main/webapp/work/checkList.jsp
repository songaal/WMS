<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.WorkTaskDAO" %>
<%@ page import="co.fastcat.wms.bean.WorkTask" %>

<%@include file="../inc/header.jsp"%>

<%
	boolean isWeek = false;
	Date reqDate = new Date();
	String reqDateStr = WebUtil.toDateString(reqDate);
	Date today = new Date();
	String todayStr = WebUtil.toDateString(today);
	Date todayStartTime = WebUtil.get0Time(today);

	WorkTaskDAO taskDAO = new WorkTaskDAO();
	List<WorkTask> taskList = taskDAO.selectCheckList(myUserInfo.serialId);
	
%>


<div class="container ">
	<div class="row">
	
		<div class="span12">
			<h2 id="body-copy">업무</h2>
			<p>날짜별 프로젝트별 업무확인</p>
			
			<div class="row-fluid">
				<!-- 좌측메뉴 -->
				<div class="span3 bs-docs-sidebar">
					
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
						%>
						<li><a href="javascript:goDateStrWork('<%=WebUtil.toDateString(date) %>')"><i class="icon-chevron-right"></i><%=WebUtil.toDateYoilString(date) %></a></li>
						<%
						}
						%>
					</ul>
					
					<ul class="nav nav-list bs-docs-sidenav">
						<li class="active"><a href="checkList.jsp"><i class="icon-check gray1"></i> 체크리스트</a></li>
						<li class=""><a href="request.jsp"><i class="icon-download gray1"></i> 업무요청큐</a></li>
						<!-- <li class=""><a href="schedule.jsp"><i class="icon-calendar gray1"></i> 스케쥴</a></li> -->
					</ul>
	
				<!--/div-->
				</div>
			
				<!-- 메인 내용 -->
				<div class="span6">
					
					<div>
					총 <span class="label label-info"><%=taskList.size() %></span>건 
					</div>
					
					<%
					if(taskList.size() == 0){
					%>
					<table class="table table-bordered table-condensed">
					<tr><td>체크리스트 내역이 없습니다.</td></tr>
					</table>
					<%				
					}
					%>
					
					<table class="table table-bordered table-condensed">
						<colgroup>
							<col width="50">
							<col width="500">
							<col width="100">
							<col width="100">
						</colgroup>
						<tbody>
							<tr>
								<th>번호</th>
								<th>내용</th>
								<th>등록일</th>
								<th>마감일</th>
							</tr>
							<%
							for(int i=0; i<taskList.size(); i++){
								WorkTask workTask = (WorkTask) taskList.get(i);
							%>
							<tr>
								<td><%=taskList.size() - i %></td>
								<td class="<%=(workTask.status == 1)?"task_done":""%>"><%=workTask.memo %></td>
								<td><%=WebUtil.toDateString(workTask.regdate) %></td>
								<td><%=WebUtil.toDateString(workTask.duedate) %></td>
							</tr>
							<%
							}
							%>
							
						</tbody>
					</table>
					
				</div>
				
				
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



