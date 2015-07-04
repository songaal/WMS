<%-- <%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	boolean isWeek = false;
	Date reqDate = new Date();
	String reqDateStr = WebUtil.toDateString(reqDate);
	Date today = new Date();
	String todayStr = WebUtil.toDateString(today);
	Date todayStartTime = WebUtil.get0Time(today);

	String rid = request.getParameter("rid");
	String status = WebUtil.getValue(request.getParameter("status"), ProjectRequest.STATUS_READY);
	
	ProjectRequestDAO dao = new ProjectRequestDAO();
	List<DAOBean> list = null;
	if(rid != null && rid.length() > 0){
		list = new ArrayList<DAOBean>();
		ProjectRequest2 r = dao.selectRequest(rid);
		if(r != null){
			list.add(r);
		}
	}else{
		list = dao.selectRequestQueueAll(status);
	}
	WorkTaskDAO taskDAO = new WorkTaskDAO();
%>


<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog" aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">요청사항수정</h3>
	</div>
	<div id="request-content" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn" onClick="modifyProjectRequest()">저장</button>
		<button class="btn btn-primary" onClick="doneProjectRequest()">완료처리</button>
		<button class="btn btn-danger" onclick="deleteProjectRequest()">삭제</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 수정폼 -->

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
						<li class=""><a href="checkList.jsp"><i class="icon-check gray1"></i> 체크리스트</a></li>
						<li class="active"><a href="request.jsp"><i class="icon-download gray1"></i> 업무요청큐</a></li>
						<!-- <li class=""><a href="schedule.jsp"><i class="icon-calendar gray1"></i> 스케쥴</a></li> -->
					</ul>
	
				<!--/div-->
				</div>
			
				<!-- 메인 내용 -->
				<div class="span6">
					
					<div class="btn-group pagination-centered">
						<a class="btn btn-small <%=status.equals(ProjectRequest.STATUS_READY)?"active":"" %>" href="request.jsp?status=<%=ProjectRequest.STATUS_READY %>">접수</a>
						<a class="btn btn-small <%=status.equals(ProjectRequest.STATUS_DONE)?"active":"" %>" href="request.jsp?status=<%=ProjectRequest.STATUS_DONE %>">완료</a>
					</div>
					<br>
			
					<div>
					총 <span class="label label-info"><%=list.size() %></span>건 
					<!-- <a href="javascript:viewInsertProjectRequest()"><i class="icon-plus-sign"></i><small>요청사항추가</small></a> -->
					</div>
					
					<%
					if(list.size() == 0){
					%>
					<table class="table table-bordered table-condensed">
					<tr><td>요청내역이 없습니다.</td></tr>
					</table>
					<%				
					}
					%>
					
					<%
					Date prevDate = null;
					for(int i=0; i<list.size(); i++){
						ProjectRequest2 info = (ProjectRequest2) list.get(i);
					
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
							<th>제목</th>
							<td><%=WebUtil.getMultiLineValue(info.title) %></td>
							</tr>
							<tr>
							<th>요청일자</th>
							<td><%=WebUtil.toDateStringWithYoil(info.regdate) %></td>
							</tr>
							<tr>
							<th>처리기한</th>
							<td><%=WebUtil.toDateStringWithYoil(info.dueDate) %></td>
							</tr>
							<tr>
							<th>요청자</th>
							<td><%=WebUtil.getValue((info.clientPersonName==null)?info.clientPname:"") %></td>
							</tr>
							<tr>
							<th>요청방법</th>
							<td><%=WebUtil.getValue(info.method) %></td>
							</tr>
							<tr>
							<th>요청내용</th>
							<td><%=WebUtil.getMultiLineValue(info.content) %></td>
							</tr>
							<tr>
							<th>처리내용</th>
							<td><%=WebUtil.getValue(info.result) %></td>
							</tr>
							<tr>
							<th>처리담당자</th>
							<td><%=info.userName %></td>
							</tr>
							<tr>
							<th>처리일자</th>
							<td><%=WebUtil.toDateStringWithYoil(info.doneDate) %></td>
							</tr>
							<tr>
							<th>진행상태</th>
							<td><%=BusinessUtil.getRequestStatusStr(info.status) %></td>
							</tr>
							<tr>
							<th> </th>
							<td>
								<button class="btn btn-mini" onClick="viewModifyRequestInfo(<%=info.rid %>)">수정</button> 
							</td>
							</tr>
						</tbody>
					</table>
					<%
					}
					%>
					
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



 --%>