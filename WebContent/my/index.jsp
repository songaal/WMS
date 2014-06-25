<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	
	String date = request.getParameter("date");

	if(date == null || date.length() == 0) {
		date = WebUtil.toDashedDateString(new Date()); 	
	}
	
	Date todayDate = new SimpleDateFormat("yyyy-MM-dd").parse(date);
	boolean isToay = WebUtil.isToday(todayDate);
	
	String userId = myUserInfo.serialId;	
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	SimpleDateFormat sdfTime = new SimpleDateFormat("HH:mm");
	
	LiveDAO liveDAO = new LiveDAO();
	LiveInfo liveInfo = liveDAO.select(userId, todayDate);
	
	
%>
<style>
.workTime { font-size : 18px; font-weight: bold; }


</style>
<script>

$(document).ready(function(){
	CKEDITOR.inlineAll();
	setTimeout(function(){
		
		CKEDITOR.instances.myMemo.addCommand('save', {
		    exec: function( editor ) {
		    	$("#memoUpdateForm input[name=content]").val(editor.getData());
			    $("#memoUpdateForm").submit();
		    }
		});
		
		CKEDITOR.instances.todayWork.addCommand('save', {
		    exec: function( editor ) {
		    	$("#taskUpdateForm input[name=content]").val(editor.getData());
			    $("#taskUpdateForm").submit();
		    }
		});
		
		
	}, 500);
	
	setInterval(function(){
		var isMemoDirty = CKEDITOR.instances.myMemo.checkDirty();
		var isWorkDirty = CKEDITOR.instances.todayWork.checkDirty();
		console.log("memo dirty : ", isMemoDirty, ", work dirty : ", isWorkDirty);
		CKEDITOR.instances.myMemo.resetDirty();
		CKEDITOR.instances.todayWork.resetDirty();
	}, 1000);
	
	
	$.fn.datepicker7.dates['ko'] = {
	    days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
	    daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
	    daysMin: ["일", "월", "화", "수", "목", "금", "토", "일"],
	    months: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	    monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
	    today: "오늘",
	    clear: "지우기"
	};
	datepicker7 = $("#myCalendar").datepicker7({
		todayHighlight: true,
		language: "ko",
		todayBtn: "linked",
		format: "yyyy-mm-dd"
	});
	
	datepicker7.on('changeDate', function(ev) {
	    if(ev.date) {
	    	goDate(ev.date);
	    }
	  });
});

function goDate(date) {
	var curr_date = date.getDate();
	var curr_month = date.getMonth() + 1;
	var curr_year = date.getFullYear();
	$("#moveDateForm input[name=date]").val(curr_year + "-" + curr_month + "-" + curr_date);
	$("#moveDateForm").submit();
}

function doCheckOut() {
	$("#checkOutForm").submit();
}
	
</script>
<div class="container"> 
	<div class="row">
		<!-- 메인내용 -->
			<div class="row">
				<div class="span4">
					<div id="myCalendar" data-date="<%=date%>"></div>
				</div>
				<div class="span8">
					<h3 style="color: #0088cc;">
					<%
					Calendar today = Calendar.getInstance();
					today.setTime(todayDate);
					SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy.MM.dd");
					int dayOfWeek = today.get(Calendar.DAY_OF_WEEK);
					String dayString = null;
					if(dayOfWeek == Calendar.MONDAY){
						dayString = "월";
					}else if(dayOfWeek == Calendar.TUESDAY){
						dayString = "화";
					}else if(dayOfWeek == Calendar.WEDNESDAY){
						dayString = "수";
					}else if(dayOfWeek == Calendar.THURSDAY){
						dayString = "목";
					}else if(dayOfWeek == Calendar.FRIDAY){
						dayString = "금";
					}else if(dayOfWeek == Calendar.SATURDAY){
						dayString = "토";
					}else if(dayOfWeek == Calendar.SUNDAY){
						dayString = "일";
					}
					%>
					<%=myUserInfo.userName %> <%=sdf1.format(today.getTime()) %> (<%=dayString %>)
					</h3>
					
					<%
					String startTime = "";
					String endTime = "";
					try{
						startTime = sdfTime.format(liveInfo.checkIn);
					}catch(Exception e ){
					}
					try{
						endTime = sdfTime.format(liveInfo.checkOut);
					}catch(Exception e ){
					}
					
					String statusStr = "";
					String statusClass = "muted";
					
					if(liveInfo != null) {
						if(liveInfo.status.contains(LiveInfo.LATE)){
							statusStr = "(지각)";
							statusClass = "text-error";
						}else if(liveInfo.status.contains(LiveInfo.OK)){
							statusClass = "text-success";
						}
						if(liveInfo.status.contains(LiveInfo.REST) || liveInfo.status.contains(LiveInfo.HALF_REST)){
							statusStr = "(휴가)";
							statusClass = "muted";
						}
					}
					%>
					<div class="workTime <%=statusClass%>">
					근무 : <%=startTime %> ~ <%
					if(endTime.length() > 0){
						out.print(endTime); 
					}else{
						if(isToay) {
							out.print("<input type='button' class='btn-small' onclick='javascript:doCheckOut();' value='퇴근'>");
						}
					}
					%> <%=statusStr %>
					<% 
					
					%>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="span4">
					
					
					<%
					ScheduleDAO scheduleDAO = new ScheduleDAO();
					String orderby = "order by start desc";
					List<DAOBean> list = scheduleDAO.select(null, orderby, null, null, "limit 3", ScheduleInfo.class);
					
					%>
					<h3>최근일정</h3>
					<ul class="my-list">
					<%
						for(DAOBean bean : list) {
							ScheduleInfo info = (ScheduleInfo) bean;
							Calendar c = Calendar.getInstance();
							c.setTime(info.startTime);
							dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
							dayString = null;
							if(dayOfWeek == Calendar.MONDAY){
								dayString = "월";
							}else if(dayOfWeek == Calendar.TUESDAY){
								dayString = "화";
							}else if(dayOfWeek == Calendar.WEDNESDAY){
								dayString = "수";
							}else if(dayOfWeek == Calendar.THURSDAY){
								dayString = "목";
							}else if(dayOfWeek == Calendar.FRIDAY){
								dayString = "금";
							}else if(dayOfWeek == Calendar.SATURDAY){
								dayString = "토";
							}else if(dayOfWeek == Calendar.SUNDAY){
								dayString = "일";
							}
					%>
						<li class="my-list">
							<b><%=sdf.format(info.startTime) %> (<%=dayString %>)</b>
							<br>
							&nbsp;&nbsp;&nbsp;<%=info.title %>
						</li>
					<%
						}
					%>
					</ul>
					
					
					<%
					EventDAO eventDAO = new EventDAO();
					String orderby1 = "order by regdate desc";
					List<DAOBean> list1 = eventDAO.select(null, orderby1, null, null, "limit 5", EventInfo.class);
					%>
					<h3>최근이벤트</h3>
					<ul class="my-list">
					<%
						for(DAOBean bean : list1) {
							EventInfo info = (EventInfo) bean;
							Calendar c = Calendar.getInstance();
							c.setTime(info.regdate);
							dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
							dayString = null;
							if(dayOfWeek == Calendar.MONDAY){
								dayString = "월";
							}else if(dayOfWeek == Calendar.TUESDAY){
								dayString = "화";
							}else if(dayOfWeek == Calendar.WEDNESDAY){
								dayString = "수";
							}else if(dayOfWeek == Calendar.THURSDAY){
								dayString = "목";
							}else if(dayOfWeek == Calendar.FRIDAY){
								dayString = "금";
							}else if(dayOfWeek == Calendar.SATURDAY){
								dayString = "토";
							}else if(dayOfWeek == Calendar.SUNDAY){
								dayString = "일";
							}
					%>
						<li class="my-list">
							<b><%=sdf.format(info.regdate) %> (<%=dayString %>)</b>
							<br>
							&nbsp;&nbsp;&nbsp;<%=info.content %>
						</li>
					<%
						}
					%>
							
					</ul>
					<form method="post" action="doMy.jsp">
						<input type="hidden" name="action" value="newEvent" >
						<input type="hidden" name="taskdate" value="<%=date%>"> 
						<textarea name="content" style="width:95%; height:60px"></textarea>
						<input type="submit" value="추가">
					</form>
					
				</div>
				
				
				
				<%
				SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
				%>
				<div class="fc-day span8" id="taskdivToday">
					<%
						TaskInfoDAO tDAO2 = new TaskInfoDAO();
						TaskInfo tInfoToday = tDAO2.select2(userId, todayDate);
					%>
					<h3>업무</h3>
					<i>Update time : <%=sdf3.format(tInfoToday != null ? tInfoToday.regdate : new java.sql.Timestamp(0) ) %></i>
					<div id="todayWork" contenteditable="true" class="my-box"><%=tInfoToday != null ? tInfoToday.content : "<p>"%></div>
					
					
					<%
						MemoDAO memoDAO = new MemoDAO();
						MemoInfo memoInfo = memoDAO.selectOne(userId);
						if(memoInfo == null) {
							memoInfo = new MemoInfo();
							memoInfo.regdate = new java.sql.Timestamp(0);
							memoInfo.content = "<p>";
						}
					%>
					
					<br>
					<h3>메모</h3>
					<i>Update time : <%=sdf3.format(memoInfo.regdate) %></i>
					<div id="myMemo" contenteditable="true" class="my-box"><%=memoInfo.content %></div>
				</div>
			</div>
			
			
			
	</div>
	<!-- row -->
</div>
<form id="moveDateForm" method="post" action="index.jsp">
	<input type="hidden" name="date">
</form>

<form id="checkOutForm" method="post" action="doMy.jsp">
	<input type="hidden" name="action" value="checkOut" >
	<input type="hidden" name="taskdate" value="<%=date%>"> 
</form>

<form id="taskUpdateForm" method="post" action="doMy.jsp">
	<input type="hidden" name="action" value="updateTask" >
	<input type="hidden" name="taskdate" value="<%=date%>"> 
	<input type="hidden" name="content" /> 
</form>

<form id="memoUpdateForm" method="post" action="doMy.jsp">
	<input type="hidden" name="action" value="updateMemo" >
	<input type="hidden" name="taskdate" value="<%=date%>"> 
	<input type="hidden" name="content" >
</form>
<!-- container -->
<%@include file="../inc/footer.jsp"%>



