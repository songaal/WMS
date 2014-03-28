<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	String yearStr = request.getParameter("year");
	String monthStr = request.getParameter("month");
	String user = request.getParameter("user");

	LiveDAO liveDAO = new LiveDAO();
	Calendar cal = Calendar.getInstance();
	int year = 0;
	int month = 0;
	if (yearStr == null) {
		year = cal.get(Calendar.YEAR);
	} else {
		year = Integer.parseInt(yearStr);
		cal.set(Calendar.YEAR, year);
	}
	if (monthStr == null) {
		month = cal.get(Calendar.MONTH) + 1;
	} else {
		month = Integer.parseInt(monthStr);
		cal.set(Calendar.MONTH, month - 1);
	}

	String yearMonth = WebUtil.toDateString(cal.getTime()).substring(0, 7);

	int startOfMonth = 1;
	int endOfMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
	int days[] = new int[42];

	int weekIdx = 0;
	int yoilIdx = 0;
	for (int i = 1; i < endOfMonth + 1; i++) {
		cal.set(Calendar.DAY_OF_MONTH, i);
		yoilIdx = cal.get(Calendar.DAY_OF_WEEK);
		days[weekIdx * 7 + (yoilIdx - 1)] = i;
		if (yoilIdx == 7)
			weekIdx++;
	}
	
	if ( user == null || user.isEmpty() )
		user = myUserInfo.serialId;		
%>

<div class="container">
	<div class="row">
		<div >
			<h2 id="body-copy">업무 리스트 <select id="userSelect" ></select></h2>
		</div>

		<!-- 메인내용 -->
		<div >

			<form action="index.jsp" id="liveDateForm" method="post" class="hide">
				<input type="hidden" id="year" name="year" value="<%=year%>"> 
				<input type="hidden" id="month" name="month" value="<%=month%>">
				<input type="hidden" id="user" name="user" value="<%=user%>">
			</form>
			
			<div class="row" >
				
				
				<div class="span1">			
					<div class="input-append date" id="liveDatePicker" data-date="<%=yearMonth%>" data-date-format="yyyy.mm" data-date-viewmode="months" data-date-minviewmode="months">
						<input class="input-small" size="7" type="text" value="<%=yearMonth%>" readonly> <span class="add-on"><i class="icon-calendar"></i></span>
					</div>
				</div>			
			</div>
			
			<table class="table table-bordered table-hover table-condensed fc-border-separate" style="margine-left : 0px">
				<thead>
					<tr>
						<th style="width: 5%; text-align: center;" ></th>
						<th class="fc-mon fc-widget-header" style="width: 19%; text-align: center;">월</th>
						<th class="fc-tue fc-widget-header" style="width: 19%; text-align: center;">화</th>
						<th class="fc-wed fc-widget-header" style="width: 19%; text-align: center;">수</th>
						<th class="fc-thu fc-widget-header" style="width: 19%; text-align: center;">목</th>
						<th class="fc-fri fc-widget-header" style="width: 19%; text-align: center;">금</th>
					</tr>
				</thead>
				<tbody>
					<%  int startWeek = 0;
						int endWeek = 6;

						if (days[6] == 1)	startWeek = 1;

						if (days[36] == 0)	endWeek = 5;

						for (int wIdx = startWeek; wIdx < endWeek; wIdx++) { %>
					<tr>
						<th rowspan="2"></th>
						<%for (int dayIdx = 1; dayIdx < 6; dayIdx++) {	%>
						<td>
							<%if (days[wIdx * 7 + dayIdx] > 0) {%>
							<div class="fc-day-number<%=days[wIdx * 7 + dayIdx]%>" style="text-align: right;">
								<%=days[wIdx * 7 + dayIdx]%>
							</div> <%}%>
						</td>
						<%}%>
					</tr>
					<tr>
						<%
						int idx = 0;
						for (int dayIdx = 1; dayIdx < 6; dayIdx++) {
							idx = days[wIdx * 7 + dayIdx];
						%>

						<td>
							<%	if ( idx > 0) {
								cal.set(Calendar.YEAR, year);
								cal.set(Calendar.MONTH, month-1);
								cal.set(Calendar.DAY_OF_MONTH, idx);
								TaskInfoDAO tDAO = new TaskInfoDAO();
								TaskInfo tInfo = tDAO.select2(user, cal.getTime());
								SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
								String strTaskDate = sdf.format(cal.getTime());
								String strRegDate = tInfo != null ? sdf.format(tInfo.regdate) : "" ;
								String strContent = tInfo != null ? strContent = tInfo.content.replaceAll("(\r\n|\n)", "<br />") : " ";
								String strIssue = tInfo != null ? tInfo.issue.replaceAll("(\r\n|\n)", "<br />") : " ";
							%>
							<div class="fc-day" id="taskdiv<%=idx%>">
								<form id="taskModify<%=idx%>" method="post" action="doTask.jsp">
									<input type="hidden" id="tid" value="<%=tInfo != null ? tInfo.id : -1%>"> 
									<input type="hidden" id="year" value="<%=year%>"> 
									<input type="hidden" id="month" value="<%=month%>"> 
									<input type="hidden" id="taskdate" value="<%=strTaskDate%>"> 
									<input type="hidden" id="regdate" value="<%=strRegDate%>">
									<input type="hidden" id="day" value="<%=idx%>" /> 
									<input type="hidden" id="UserId" value="<%=user%>" /> 
									<input type="hidden" id="content" value="<%=strContent%>" /> 
									<input type="hidden" id="issue" value="<%=strIssue%>" />
									<div class="fc-day-content" id="content<%=idx%>" style="min-height: 60px; border: 1px solid #A9ABFE;">										
											<%=strContent%>										
									</div>

									<div class="fc-day-issue" id="issue<%=idx%>" style="min-height: 40px; border: 1px solid #E3E3FF; background-color : #F5F5DC">										
											<%=strIssue%>										
									</div>

								</form>
							</div> <% 	} %>
						</td>
						<%}	%>
					</tr>
					<%}	%>
				</tbody>
			</table>		
		</div>
	</div>
	<!-- row -->
</div>
<!-- container -->
<script>
	$(document).ready(function() {
		CKEDITOR.config.toolbar = [];
	});	
	selectUser = "<%=user%>";
	writeAble = "true";
	editMode = false;
	year = "<%=year%>";
	month = "<%=month%>";	
</script>
<%@include file="../inc/footer.jsp"%>
<script src="/WMS/assets/js/jsHtmlToText.js"></script>



