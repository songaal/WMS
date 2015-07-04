<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.WorkList" %>
<%@ page import="co.fastcat.wms.dao.WorkListDAO" %>
<%@ page import="co.fastcat.wms.bean.ProjectInfo" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>
<%@ page import="co.fastcat.wms.dao.ProjectDAO" %>

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
						<span class="btn">&lt;</span>
						<span class="btn" onClick="goTodayWork()">오늘</span>
						<span class="btn">&gt;</span>
					</div>
					
					<ul class="nav nav-list bs-docs-sidenav">
						<li class="<%=isWeek?"active":""%>"><a href="javascript:goWeekWork('<%=reqDateStr %>')"><i class="icon-chevron-right"></i><%=WebUtil.toMonthWeekString(reqDate) %> 스케쥴 </a></li>
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
				<div class="span9">
					<% if(!isWeek){ %>
					<div>
						<a href="javascript:viewAddProject()"><i class="icon-plus-sign"></i><small>주간프로젝트추가</small></a>
						<%
						//업무보고는 당일자만 가능하다.
						if(isToday){ 
						%>
						<!-- <a href="#finishWorkModal" class="pull-right" role="button" data-toggle="modal"><i class="icon-share-alt"></i><small>주간마감보고</small></a>
						<a href="#startWorkModal" class="pull-right" role="button" data-toggle="modal"><i class="icon-share-alt"></i><small>주간시작보고</small></a> -->
						<%
						}
						%>
					</div>
					<% } %>
					
					<!-- 내용추가폼 -->
					<div class="alert hide" id="addProject">
						<div class="input-append">
							<input type="text" class="span2" placeholder="고객사명"><input type="text" class="span2" placeholder="리셀러명"><input type="text" placeholder="신규프로젝트명"></input>
							<span class="btn btn-primary" onClick="">신규생성</span>
						</div>
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
						<select id="myProject" multiple="multiple" size="10" onDblClick="addWeekProjectClick()">
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
						<select id="mySolution" multiple="multiple" size="10" onDblClick="addWeekSolutionClick()">
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
					
					
					<table class="table table-bordered">
						<thead>
							<tr>
								<th>날짜</th>
								
								<%
								dateList = WebUtil.getListOfThisWeek(reqDate);
								for(int i=0; i< dateList.size(); i++) {
									Date date = dateList.get(i);
									if(i >= 5){
										continue;//토,일요일 건너뜀.
									}
										
								%>
								<th><%=WebUtil.toMiniDateString(date) %></th>
								<%
								}
								%>
							</tr>
							<tr>
								<th>요일</th>
								<th>월</th>
								<th>화</th>
								<th>수</th>
								<th>목</th>
								<th>금</th>
							</tr>
						</thead>
						<tbody>
						<%
							WorkListDAO wlDao = new WorkListDAO();
							List<DAOBean> workList = wlDao.selectWeek(myUserInfo.serialId, reqDate);
							
							for(int i=0;i<workList.size();i++){
								
								WorkList wl = (WorkList) workList.get(i);
								out.println(wl.content+"<br>");
							}
						%>
							<tr>
								<th>다나와<br>APL2</th>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
							</tr>
							<tr>
								<th>대교협<br>공정성개선</th>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
								<td class="workTd">
									<div contenteditable="true" class="work_cell taskText "></div>
								</td>
							</tr>
						</tbody>
					
					</table>
					
					
				</div>
				<!--// 메인내용 -->
			
				
			</div>

		</div>
	</div>
	<!-- row -->
</div>
<!-- container -->

<%@include file="../inc/footer.jsp"%>




