<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.*" %>
<%@ page import="co.fastcat.wms.dao.*" %>

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
				<%
				SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy.MM.dd HH:mm");
				%>
				<div class="fc-day span12" id="taskdivToday">
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



