$(function() {

    $('.duedate').datepicker().on('changeDate', function(ev) {
    	$(this).blur();
		$(this).datepicker('hide');
		updateClClick(this);
	});
    
    initCheckList();
});
function initCheckList(){
	$(".clDiv").click(clEdit);
	//$(".sortableCheckList").sortable(clSortableProperty);
	
	$(".clCheck").click(clChecked);
}
/////////////////////////////////////////////
var clSortableProperty = { handle: ".handleT", grid: [ 20, 10 ], placeholder: "ui-sortable-placeholder"
	, start: clChangeStartCallBack, update: clChangeUpdateCallBack, cursor: "move" };


//function reloadWorkList(){
//	$("#workList").load("workList.jsp", initWorkListPage);
//}

var clStartIndex; //subject간 task 이동시 필요한 old list index


function clChangeStartCallBack(event, ui){
	printSortableUI("start", ui);
	taskStartWID = ui.item.parents(".subjectList").siblings(".project").children("input[name=wid]").val();
	taskStartSID = ui.item.parents("li[name=subjectLi]").find("input[name=sid]").val();
	taskStartIndex = ui.item.index();
	taskStartLIST = ui.item.parents(".taskList");
}

function clChangeUpdateCallBack(event, ui){
	printSortableUI("update", ui);
	tid = ui.item.find("input[name=tid]").val();
	if(taskStartSID == sid){
		console.log("chek list move ", taskStartIndex, "=>", ui.item.index(), ", sid >> ", sid);
		//같은 subject내의 이동.
		$.ajax({
			url: "doWorkTask.jsp"
			, type: "POST"
			, data: {
				action: "moveCheckList"
				, tid: tid
				, from: taskStartIndex
				, to: ui.item.index()
			}
			, success: function(data){
				
				if(data.result != true){
					alert("이동중 에러발생.");
					ui.item.parents(".taskList").sortable('cancel');
				}
			}
			, dataType: "json"
		});
	}
}

function clChecked(){
	
	var checkDone = false;
	if($(this).is(":checked")){
		checkDone = true;
	}else{
		checkDone = false;
	}
	
	tid = $(this).siblings("input[name=tid]").val();
	var clDiv = $(this).parent(".clDiv");
	$.ajax({
		url: "doWorkTask.jsp"
		, type: "POST"
		, data: {
			action: "toggleWorkTask"
			, tid: tid
			, checkDone: checkDone
		}
		, success: function(data){
			console.log(data);
			if(data.result == "done"){
				console.log("DOE!!");
				clDiv.addClass("task_done");
			}else if(data.result == "not"){
				console.log("NOT!!");
				clDiv.removeClass("task_done");
			}
		}
		, dataType: "json"
	});
}
///////////////////////////////////////

function addCheckListClick(el){
	var obj = $(el);
	wid = -1;
	pid = -1;
	sid = -1;
	time = "";
	var taskList = obj.siblings(".taskList");
	var taskEl = $("#checkElTemplate").clone(true);//이벤트까지 함께 복사.
	taskEl.removeAttr("id");
	var duedateObj = taskEl.find("input[name = duedate]");
	var duedate = duedateObj.val();
	var memoObj = taskEl.find("input[name=checkTodo]");
	var memo = memoObj.val();
	//clEditKeyDown
	$.ajax({
		url: "doWorkTask.jsp"
		, data: {	
			action: "addCheckList"
			, wid: wid
			, pid: pid
			, sid: sid
			, time: time
			, duedate: duedate
			, memo: memo
			, seq: 0
		}
		, success: function(data){
			
			if(data.tid != -1){
				taskList.prepend(taskEl);
//				taskEl.show();
				taskEl.removeClass("hide");
				memoObj.focus();
				memoObj.keydown(clEditKeyDown);
				taskEl.find("input[name=tid]").val(data.tid);
				//duedateObj.addClass("duedate");
				duedateObj.datepicker().on('changeDate', function(ev) {
			    	$(this).blur();
					$(this).datepicker('hide');
					updateClClick(this);
				});
				
				console.log("add chekclist >> pid:", pid, ", sid:", sid, ", tid:", taskEl.find("input[name=tid]").val(), ", memo:", memo, ", duedate:", duedate);
			}else{
				alert("작업을 추가할 수 없습니다.");
			}
		}
		, dataType: "json"
	});
	
}

function removeClClick(el){
	var obj = $(el);
	var myList = obj.parents("li[name = taskLi]");
	index = myList.index();
	
	wid = -1;
	sid = -1;
	tid = obj.parents(".clDiv").children("input[name=tid]").val();
	console.log("remove task >> wid: ", wid, ", sid:", sid, ", tid:", tid, ", index:", index);
	
	$.ajax({
		url: "doWorkTask.jsp"
		, type: "POST"
		, data: {
			action: "deleteWorkTask"
			, id: tid
			, wid : wid
			, sid: sid
			, seq: index
		}
		, success: function(data){
			
			if(data.result == true){
				
				myList.remove();
				
			}else{
				alert("작업을 삭제할 수 없습니다.");
			}
		}
		, dataType: "json"
	});
		
}
//Span 태그 => Textarea
function clEdit() {
	var taskCheck = $(this).children(".clCheck");
	if(taskCheck.is(":checked")){
		alert("완료항목은 수정할수 없습니다.");
		return;
	}
	
	var taskTextObj = $(this).children(".taskText");
	if(taskTextObj.length == 0){
		return;
	}
	var infoBoxObj = $(this).children("div[name = infoBox]");
	
	var timeStr = $(this).children("span[name = dueDateStr]");
    timeStr.hide();
    
	var html = taskTextObj.text();
    var inputText = $("<input type='text' name='checkTodo' class=\"input-large\"/>");
    inputText.val(html);
    taskTextObj.replaceWith(inputText);
    inputText.focus();
    inputText.keydown(clEditKeyDown);
    infoBoxObj.show();
}
//Textarea => span 태그
function updateClClick(el){
	var obj = $(el);
	pid = -1;
	sid = -1;
	tid = obj.parents(".clDiv").children("input[name=tid]").val();
	time = "";
	var clDiv = obj.parents(".clDiv");
	var infoBox = clDiv.children("div[name = infoBox]");
	
	var timeObj = infoBox.find("input[name = duedate]");
	duedate = timeObj.val();
	var textareaObj = clDiv.children("input[name = checkTodo]");
	var html = textareaObj.val();
    //줄바꿈은 <br>태그로 바꾸어준다.
    html = nl2br(html);
    
    console.log("update task >> pid:", pid, ", sid:", sid, ", tid:", tid, ", html:", html, ", duedate:", duedate);
    
    $.ajax({
		url: "doWorkTask.jsp"
		, type: "POST"
		, data: {
			action: "modifyWorkTask"
			, id: tid
			, memo: html
			, time: time
			, duedate: duedate
		}
		, success: function(data){
			
			if(data.result == true){
				infoBox.hide();
				var dueDateStr = clDiv.children("span[name = dueDateStr]");
				dueDateStr.show();
				var timeValue = dueDateStr.children("span[name = timeValue]");
			    timeValue.text(getDateYoil(duedate));
			    
				var viewableText = $("<span class='taskText rightPaneText'></span>");
			    viewableText.html(html);
			    textareaObj.replaceWith(viewableText);
				
			}else{
				alert("작업을 업데이트할 수 없습니다.");
			}
		}
		, dataType: "json"
	});
}
var week = new Array('일', '월', '화', '수', '목', '금', '토');

function getDateYoil(dateStr){
	dateObj = parseDate(dateStr);
	
	today = new Date();
	todayStr = today.getFullYear()+"."+(today.getMonth() + 1)+"."+today.getDate();
	today = parseDate(todayStr);
	yesterday = parseDate(todayStr);
	yesterday.setDate(yesterday.getDate() - 1);
	tomorrow = parseDate(todayStr);
	tomorrow.setDate(tomorrow.getDate() + 1);
	
	if(dateObj.getTime() == today.getTime()){
		return "오늘";
	}else if(dateObj.getTime() == yesterday.getTime()){
		return "어제";
	}else if(dateObj.getTime() == tomorrow.getTime()){
		return "내일";
	}
	
	month = dateObj.getMonth() + 1;
	date = dateObj.getDate();
	month = (month < 10) ? '0' + month : month;
	date = (date < 10) ? '0' + date : date;
	return month + "." + date + "(" + week[dateObj.getDay()] + ")";
	
}

function clEditKeyDown(e){
//	console.log("keydown >> ", e.which, e.target);
	if (e.which == 13) { //ENTER
		e.preventDefault();
		updateClClick(this);
	}else if(e.which == 27){
		updateClClick(this);
	}else if(e.which == 8){ //BACK SPACE
		if($(this).val().length == 0){
			//삭제한다.
			removeClClick(this);
		}
	}
	return;
}

//////////////////////////////////////////////
//요청내용
//////////////////////////////////////////////
function viewInsertProjectRequest(){
	$("#requestForm div[class *= date]").datepicker().on('changeDate', function(ev) {
    	$(this).blur();
		$(this).datepicker('hide');
	});
	selectObj = $("#requestForm select[name=userId]");
	userSID = $("#requestForm input[name=myId]").val();
	console.log("userSID>>", userSID);
	prepareSelectUser(selectObj, false);
	setSelectValue(selectObj, userSID);
	$('#requestModal').modal('show');
}

function insertProjectRequest(){
	if($("#requestForm").valid()){
		$("#requestForm input[name=action]").val("insertAjax");
		submitFormAjax($("#requestForm"), "/WMS/project/doRequest.jsp", "POST", "json", function(data){
			if(data.result){
				bootbox.alert("요청사항을 큐에 추가했습니다.");
				$('#requestModal').modal('hide');
			}else{
				bootbox.alert("입력실패!");
			}
		});
	}
}

