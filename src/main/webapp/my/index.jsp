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

div.dig, div.hour, div.min, div.sec {
    position:absolute;
}
div.hour, div.min, div.sec {
    width:2px;
    height:2px;
    font-size:2px;
}

div.dig {
    width:30px;
    height:30px;
    font-family:arial,verdana,sans-serif;
    font-size:10px;
    color:#000000;
    text-align:center;
    padding-top:10px
}
div.min {
    background:#0DB3C2;
}
div.hour {
    background:#000000;
}
div.sec {
    background:#FF0000;
}


</style>
<script>
var toolbarConfig = [
	{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
	{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock' ] },
	{ name: 'insert', items: [ 'Table', 'Image', 'SpecialChar' ] },
	'/',
	{ name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source', '-', 'Save', 'Preview', 'Print' ] },
	{ name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
	{ name: 'colors', items: [ 'TextColor', 'BGColor' ] },
	{ name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] },
];
$(document).ready(function(){
	//CKEDITOR.inlineAll();
	CKEDITOR.inline('myMemo',{
    	toolbar: 'ToolbarSimple',     
        toolbar_ToolbarSimple: toolbarConfig
        	
	});
	CKEDITOR.inline('todayWork',{
    	toolbar: 'ToolbarSimple',     
        toolbar_ToolbarSimple: toolbarConfig
        	
	});
	//floatSpaceDockedOffsetX:0,
	setTimeout(function(){
		
		CKEDITOR.instances.myMemo.addCommand('save', {
		    exec: function( editor ) {
		    	saveMemo();
		    }
		});
		
		CKEDITOR.instances.todayWork.addCommand('save', {
		    exec: function( editor ) {
		    	saveTask();
		    }
		});
		
		
	}, 500);
	
	/* setInterval(function(){
		var isMemoDirty = CKEDITOR.instances.myMemo.checkDirty();
		var isWorkDirty = CKEDITOR.instances.todayWork.checkDirty();
		console.log("memo dirty : ", isMemoDirty, ", work dirty : ", isWorkDirty);
		CKEDITOR.instances.myMemo.resetDirty();
		CKEDITOR.instances.todayWork.resetDirty();
	}, 1000); */
	
	
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
	
	
	///시계구동
	clock();
	
	//자동저장.
	autoSaveTask();
	autoSaveMemo();
});

function goDate(date) {
	$("#moveDateForm input[name=date]").val(getDateString(date));
	$("#moveDateForm").submit();
}

function doCheckOut() {
	$("#checkOutForm").submit();
}

function getDateString(date) {
	var curr_date = date.getDate();
	var curr_month = date.getMonth() + 1;
	var curr_year = date.getFullYear();
	if(curr_month < 10) { 
		curr_month = "0" + curr_month;
	}
	if(curr_date < 10) { 
		curr_date = "0" + curr_date;
	}
	return curr_year + "-" + curr_month + "-" + curr_date;
}

function getDateTimeString(date) {
	var curr_year = date.getFullYear();
	var curr_month = date.getMonth() + 1;
	var curr_date = date.getDate();
	var curr_hour = date.getHours();
	var curr_min = date.getMinutes();
	if(curr_month < 10) { 
		curr_month = "0" + curr_month;
	}
	if(curr_date < 10) { 
		curr_date = "0" + curr_date;
	}
	if(curr_hour < 10) { 
		curr_hour = "0" + curr_hour;
	}
	if(curr_min < 10) { 
		curr_min = "0" + curr_min;
	}
	return curr_year + "." + curr_month + "." + curr_date + " " + curr_hour + ":" + curr_min;
}

function autoSaveMemo(){
	var isMemoDirty = CKEDITOR.instances.myMemo.checkDirty();
	if(isMemoDirty) {
		saveMemo();
	}
	setTimeout('autoSaveMemo()', 5000);
}

function autoSaveTask(){
	var isTaskDirty = CKEDITOR.instances.todayWork.checkDirty();
	if(isTaskDirty) {
		saveTask();
	}
	setTimeout('autoSaveTask()', 5000);
}

function saveTask(){
	
	var nowDateString = getDateTimeString(new Date());
	$.ajax({
		type: "POST",
		async: true,
		url: "doMy.jsp",
		data: {
			action: "updateTask",
			content : CKEDITOR.instances.todayWork.getData(),
			taskdate: "<%=date %>"
		}, 
		success: function(data){
			if(data["result"]==true) {
				//성공시 리셋.
				CKEDITOR.instances.todayWork.resetDirty();
				//업데이트 시간 표시.
				$("#workUpdateTime").text(nowDateString);
				$.notify("업무가 자동 저장됨.", {autoHide: true, autoHideDelay:1500, showDuration:0, hideDuration:0, globalPosition: "top right", className: "success"});
			}else{
				//실패.
				$.notify("업무 자동저장 에러.", {autoHide: true, autoHideDelay:2000, showDuration:0, hideDuration:0, globalPosition: "top right", className: "error"});
			}
		},
		error: function(){
			//실패.
			$.notify("업무 자동저장 페이지 에러.", {autoHide: true, autoHideDelay:2000, showDuration:0, hideDuration:0, globalPosition: "top right", className: "error"});
		},
		dataType: "json"
	});
}

function saveMemo(){
	
	var nowDateString = getDateTimeString(new Date());
	$.ajax({
		type: "POST",
		async: true,
		url: "doMy.jsp",
		data: {
			action: "updateMemo",
			content : CKEDITOR.instances.myMemo.getData(),
			taskdate: "<%=date %>"
		}, 
		success: function(data){
			if(data["result"]==true) {
				//성공시 리셋.
				CKEDITOR.instances.myMemo.resetDirty();
				//업데이트 시간 표시.
				$("#memoUpdateTime").text(nowDateString);
				$.notify("메모가 자동 저장됨.", {autoHide: true, autoHideDelay:1500, showDuration:0, hideDuration:0, globalPosition: "top right", className: "success"});
			}else{
				//실패.
				$.notify("메모 자동저장 에러.", {autoHide: true, autoHideDelay:2000, showDuration:0, hideDuration:0, globalPosition: "top right", className: "error"});
			}
		},
		error: function(){
			//실패.
			$.notify("메모 자동저장 페이지 에러.", {autoHide: true, autoHideDelay:2000, showDuration:0, hideDuration:0, globalPosition: "top right", className: "error"});
		},
		dataType: "json"
	});
}


//copied from w3schools.com
//Standard Scroll Clock by kurt.grigg@virgin.net
var H='....';
var H=H.split('');
var M='.....';
var M=M.split('');
var S='......';
var S=S.split('');
var Ypos=0;
var Xpos=0;
var Ybase=8;
var Xbase=8;
var dots=12;

function clock() {
	var time = new Date();
	var secs = time.getSeconds();
	var sec = -1.57 + Math.PI * secs / 30;
	var mins = time.getMinutes();
	var min = -1.57 + Math.PI * mins / 30;
	var hr = time.getHours();
	var hrs = -1.57 + Math.PI * hr / 6 + Math.PI
			* parseInt(time.getMinutes()) / 360;
	for (i = 0; i < dots; ++i) {
		document.getElementById("dig" + (i + 1)).style.top = 0 - 15 + 40
				* Math.sin(-0.49 + dots + i / 1.9).toString() + "px";
		document.getElementById("dig" + (i + 1)).style.left = 0 - 14 + 40
				* Math.cos(-0.49 + dots + i / 1.9).toString() + "px";
	}
	/* for (i = 0; i < S.length; i++) {
		document.getElementById("sec" + (i + 1)).style.top = Ypos + i
				* Ybase * Math.sin(sec).toString() + "px";
		document.getElementById("sec" + (i + 1)).style.left = Xpos + i
				* Xbase * Math.cos(sec).toString() + "px";
	} */
	for (i = 0; i < M.length; i++) {
		document.getElementById("min" + (i + 1)).style.top = Ypos + i
				* Ybase * Math.sin(min).toString() + "px";
		document.getElementById("min" + (i + 1)).style.left = Xpos + i
				* Xbase * Math.cos(min).toString() + "px";
	}
	for (i = 0; i < H.length; i++) {
		document.getElementById("hour" + (i + 1)).style.top = Ypos + i
				* Ybase * Math.sin(hrs).toString() + "px";
		document.getElementById("hour" + (i + 1)).style.left = Xpos + i
				* Xbase * Math.cos(hrs).toString() + "px";
	}
	setTimeout('clock()', 50);
}
</script>
<div class="container"> 
	<div class="row">
		<!-- 메인내용 -->
			<div class="row">
				<div class="span4">
				<table>
					<tr>
					<td>
						<!-- 달력 -->
						<div id="myCalendar" data-date="<%=date%>"></div>
					</td>
					<td>
						<!-- 시계 -->
						<div style="width:120px;height:100px;position:relative;left:58px;top:50px;">
							<div id="dig1" class="dig">1</div>
							<div id="dig2" class="dig">2</div>
							<div id="dig3" class="dig">3</div>
							<div id="dig4" class="dig">4</div>
							<div id="dig5" class="dig">5</div>
							<div id="dig6" class="dig">6</div>
							<div id="dig7" class="dig">7</div>
							<div id="dig8" class="dig">8</div>
							<div id="dig9" class="dig">9</div>
							<div id="dig10" class="dig">10</div>
							<div id="dig11" class="dig">11</div>
							<div id="dig12" class="dig">12</div>
						
							<div id="hour1" class="hour"></div>
							<div id="hour2" class="hour"></div>
							<div id="hour3" class="hour"></div>
							<div id="hour4" class="hour"></div>
						
							<div id="min1" class="min"></div>
							<div id="min2" class="min"></div>
							<div id="min3" class="min"></div>
							<div id="min4" class="min"></div>
							<div id="min5" class="min"></div>
						
							<!-- <div id="sec1" class="sec"></div>
							<div id="sec2" class="sec"></div>
							<div id="sec3" class="sec"></div>
							<div id="sec4" class="sec"></div>
							<div id="sec5" class="sec"></div>
							<div id="sec6" class="sec"></div> -->
						</div>
					</td>
					</tr>
				</table>
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
				SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy.MM.dd HH:mm");
				%>
				<div class="fc-day span8" id="taskdivToday">
					<%
						TaskInfoDAO tDAO2 = new TaskInfoDAO();
						TaskInfo tInfoToday = tDAO2.select2(userId, todayDate);
					%>
					<h3>업무</h3>
					<i>Update time : <span id="workUpdateTime"><%=sdf3.format(tInfoToday != null ? tInfoToday.regdate : new java.sql.Timestamp(0) ) %></span></i>
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
					<i>Update time : <span id="memoUpdateTime"><%=sdf3.format(memoInfo.regdate) %></span></i>
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

<!-- container -->
<%@include file="../inc/footer.jsp"%>



