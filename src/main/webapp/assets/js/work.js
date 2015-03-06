$(function() {

    $('#workDatePicker').datepicker().on('changeDate', function(ev) {
    	goDateWork(ev.date);
	});
    
    $(document).keydown(function(e){
    	if(e.target.tagName.toUpperCase() == "BODY"){
    		//뒤로가기 금지.
    		if(e.which == 8){
    			e.preventDefault();
    		}
    	}
    });
    
    $("select[name=time]").change(function(e){
    	updateTaskClick(this);
    	currentTaskWorking = null;
    });
    
    
//    $( "#checkList" ).sortable();
//    $( "#checkList" ).disableSelection();
    
    initWorkList();
});
function initWorkList(){
	$(".taskContents").click(taskEdit);
	$("p[class *= subject]").click(subjectEdit);

	$(".sortableProjectList").sortable(projectSortableProperty);
	$(".sortableSubjectList").sortable(subjectSortableProperty);
	$(".sortableTaskList").sortable(taskSortableProperty);
	
	$(".taskCheck").click(taskChecked);
}
/////////////////////////////////////////////

var projectSortableProperty = { handle: ".handleP", grid: [ 20, 10 ], placeholder: "ui-sortable-placeholder"
	, start: projectChangeStartCallBack, update: projectChangeUpdateCallBack, cursor: "move" };
var subjectSortableProperty = { handle: ".handleS", grid: [ 20, 10 ], placeholder: "ui-sortable-placeholder"
	, start: subjectChangeStartCallBack, update: subjectChangeUpdateCallBack, cursor: "move" };
var taskSortableProperty = { handle: ".handleT", grid: [ 20, 10 ], placeholder: "ui-sortable-placeholder"
	, start: taskChangeStartCallBack, update: taskChangeUpdateCallBack, cursor: "move", connectWith: ".sortableTaskList" };


//function reloadWorkList(){
//	$("#workList").load("workList.jsp", initWorkListPage);
//}

var projectStartIndex;
var subjectStartIndex;
var taskStartIndex; //subject간 task 이동시 필요한 old list index
var taskStartWID; //subject간 task 이동시 필요한 old wid
var taskStartSID; //subject간 task 이동시 필요한 old sid
var taskStartLIST; //subject간 task 이동시 source LIST. 향후 에러시 cancel할때 필요.

function projectChangeStartCallBack(event, ui){
	projectStartIndex = ui.item.index();
}
function projectChangeUpdateCallBack(event, ui){
	wid = ui.item.find("input[name=wid]").val();
	var regdate = $('#myProject').siblings('input[name=regdate]').val();
	
	console.log("project move ", projectStartIndex, "=>", ui.item.index(), ", wid >> ", wid);
	
	$.ajax({
		url: "doWork.jsp"
		, type: "POST"
		, data: {
			action: "moveWorkProject"
			, id: wid
			, from: projectStartIndex
			, to: ui.item.index()
			, regdate: regdate
		}
		, success: function(data){
			
			if(data.result != true){
				alert("이동중 에러발생.");
				ui.item.parents(".projectList").sortable('cancel');
			}
		} 
		, dataType: "json"
	});
	
}
function subjectChangeStartCallBack(event, ui){
	subjectStartIndex = ui.item.index();
}
function subjectChangeUpdateCallBack(event, ui){
	wid = ui.item.parents(".subjectList").siblings(".project").children("input[name=wid]").val();
	sid = ui.item.find("input[name=sid]").val();

	console.log("subject move ", subjectStartIndex, "=>", ui.item.index(), "wid >> ", wid, "sid >> ", sid);
	
	$.ajax({
		url: "doWorkSubject.jsp"
		, type: "POST"
		, data: {
			action: "moveWorkSubject"
			, wid: wid
			, sid: sid
			, from: subjectStartIndex
			, to: ui.item.index()
		}
		, success: function(data){
			console.log(data);
			if(data.result != true){
				alert("이동중 에러발생.");
				ui.item.parents(".subjectList").sortable('cancel');
			}
		} 
		, dataType: "json"
	});
	
}

function printSortableUI(category, ui){
	
	console.log(category+"] sender >>", ui.sender);
	if(ui.sender != null){
		sid = ui.sender.siblings(".subject").children("input[name=sid]").val();
		console.log(category+"] sender sid >>", sid);
	}
	//console.log(category+"] item >>", ui.item);
	taskMemo = ui.item.find(".taskText").text();
	console.log(category+"] item text >>", taskMemo);
	sid = ui.item.parents("li[name=subjectLi]").find("input[name=sid]").val();
	tid = ui.item.find("input[name=tid]").val();
	console.log(category+"] sid >>", sid);
	console.log(category+"] tid >>", tid);
	console.log(category+"] index >>", ui.item.index());
}
function taskChangeStartCallBack(event, ui){
	printSortableUI("start", ui);
	taskStartWID = ui.item.parents(".subjectList").siblings(".project").children("input[name=wid]").val();
	taskStartSID = ui.item.parents("li[name=subjectLi]").find("input[name=sid]").val();
	taskStartIndex = ui.item.index();
	taskStartLIST = ui.item.parents(".taskList");
}

function taskChangeUpdateCallBack(event, ui){
	if(ui.sender != null){
		//sender가 존재하면, task를 다른 subject로 옮길때 update가 두번째 호출되는 이벤트이다.
		//이미 처리한 이벤트 이므로, skip하도록 한다.
		return;
	}
	printSortableUI("update", ui);
	wid = ui.item.parents(".subjectList").siblings(".project").children("input[name=wid]").val();
	pid = ui.item.parents(".subjectList").siblings(".project").children("input[name=pid]").val();
	sid = ui.item.parents("li[name=subjectLi]").find("input[name=sid]").val();
	tid = ui.item.find("input[name=tid]").val();
	if(taskStartSID == sid){
		console.log("task move ", taskStartIndex, "=>", ui.item.index(), ", sid >> ", sid);
		//같은 subject내의 이동.
		$.ajax({
			url: "doWorkTask.jsp"
			, type: "POST"
			, data: {
				action: "moveWorkTask"
				, wid: wid
				, sid: sid
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
	}else{
		//다른 subject로의 이동.
		console.log("삭제 wid=", taskStartWID, ", sid=", taskStartSID, ", tid=", tid, ", seq=", taskStartIndex);
		console.log("추가 wid=", wid, ", pid=", pid, ", sid=", sid, ", seq=", ui.item.index());
		oldWid = taskStartWID;
		oldSid = taskStartSID;
		
		$.ajax({
			url: "doWorkTask.jsp"
			, type: "POST"
			, data: {	
				action: "moveToAnotherWorkTask"
				, oldWid: oldWid
				, oldSid: oldSid
				, wid: wid
				, sid: sid
				, pid: pid
				, tid: tid
				, from: taskStartIndex
				, to: ui.item.index()
			}
			, success: function(data){
				console.log(data);
				if(data.result != true){
					alert("다른 주제로 이동중 에러발생.");
					//source, target list 모두 cancel.
					taskStartLIST.sortable('cancel');
					ui.item.parents(".taskList").sortable('cancel');
				}
			}
			, dataType: "json"
		});
	}
}

function taskChecked(){
	
	var checkDone = false;
	if($(this).is(":checked")){
		checkDone = true;
	}else{
		checkDone = false;
	}
	
	tid = $(this).siblings("input[name=tid]").val();
	var taskDiv = $(this).parent(".taskDiv");
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
				taskDiv.addClass("task_done");
			}else if(data.result == "not"){
				console.log("NOT!!");
				taskDiv.removeClass("task_done");
			}
		}
		, dataType: "json"
	});
}
///////////////////////////////////////

function addTaskClick(el){
	var obj = $(el);
	wid = obj.parents(".subjectList").siblings(".project").children("input[name=wid]").val();
	pid = obj.parents(".subjectList").siblings(".project").children("input[name=pid]").val();
	sid = obj.siblings(".subject").children("input[name=sid]").val();
	var taskList = obj.siblings(".taskList");
	
	if(currentTaskWorking != null){
		updateTaskClick(currentTaskWorking.children("textarea"));
	}
	//이전 편집은 닫는다.
	addTask(wid, pid, sid, taskList);
}

function addTask(wid, pid, sid, taskList){
	var taskEl = $("#taskElTemplate").clone(true);//이벤트까지 함께 복사.
	taskEl.removeAttr("id");
	time = taskEl.find("select[name = time]").val();
//	memo = taskEl.find(".taskText").html();
	memo = taskEl.find("textarea").val();
	
	$.ajax({
		url: "doWorkTask.jsp"
		, data: {	
			action: "addWorkTask"
			, wid: wid
			, pid: pid
			, sid: sid
			, time: time
			, memo: memo
			, seq: 0
		}
		, success: function(data){
			
			if(data.tid != -1){
				taskList.append(taskEl);
//				taskEl.show();
				taskEl.removeClass("hide");
				textareaText = taskEl.find("textarea");
				textareaText.focus();
				textareaText.keydown(taskEditKeyDown);
			    textareaText.keyup(taskEditKeyUp);
			    
				taskEl.find("input[name=tid]").val(data.tid);
				
				currentTaskWorking = $(taskEl).find(".taskContents");
			    console.log("currentTaskWorking3>> ",currentTaskWorking);
			    
				console.log("add task >> pid:", pid, ", sid:", sid, ", tid:", taskEl.find("input[name=tid]").val(), ", memo:", memo, ", time:", time);
			}else{
				alert("작업을 추가할 수 없습니다.");
			}
		}
		, dataType: "json"
	});
	
}

function removeTaskClick(el){
	var obj = $(el);
	var myList = obj.parents("li[name = taskLi]");
	index = myList.index();
	
	wid = obj.parents(".subjectList").siblings(".project").children("input[name=wid]").val();
	sid = obj.parents(".taskList").siblings(".subject").children("input[name=sid]").val();
	tid = obj.parents(".taskDiv").children("input[name=tid]").val();
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

var currentTaskWorking = null;

//Span 태그 => Textarea
function taskEdit() {
	var taskCheck = $(this).siblings(".taskCheck");
	if(taskCheck.is(":checked")){
		alert("완료항목은 수정할수 없습니다.");
		return;
	}
	
	var taskTextObj = $(this).children(".taskText");
	if(taskTextObj.length == 0){
		return;
	}
	
	//이전 편집은 닫는다.
	if(currentTaskWorking != null){
		updateTaskClick(currentTaskWorking.children("textarea"));
	}
	
	
	var infoBoxObj = $(this).children("div[name = infoBox]");
	
	var timeStr = $(this).children("span[name = timeStr]");
    timeStr.hide();
    
	var html = taskTextObj.html();
    var textareaText = $("<textarea class=\"textarea-large\"/>");
    //textareaText.keypress(taskEditKeyPress);
    textareaText.keydown(taskEditKeyDown);
    textareaText.keyup(taskEditKeyUp);
    //<br>태그는 줄바꿈으로 바꾸어준다.
    html = br2nl(html);
    textareaText.val(html);
    taskTextObj.replaceWith(textareaText);
    textareaText.focus();
    infoBoxObj.show();
    
    
    currentTaskWorking = $(this);
    console.log("currentTaskWorking>> ",currentTaskWorking);
}

var altPressed = false;
function taskEditKeyDown(e){
	//console.log("keydown >> ", e.which, e.target);
	if(e.which == 18){ //ALT
		altPressed = true;
	}else if (e.which == 13) { //ENTER
		if(altPressed){
			//엔터키 삽입.
		}else{
			e.preventDefault();
			updateTaskClick(this);
//			console.log("this >> ", this);
			currentTaskWorking = null;
//		    console.log("currentTaskWorking updated1 >> ", currentTaskWorking);
		}
	}else if(e.which == 27){
		updateTaskClick(this);
		currentTaskWorking = null;
	}else if(e.which == 8){ //BACK SPACE
		//if("delete")
		//console.log("delete >> ", $(this).val().length, this);
		if($(this).val().length == 0){
			//삭제한다.
			removeTaskClick(this);
			currentTaskWorking = null;
//			console.log("currentTaskWorking updated2 >> ", currentTaskWorking);
		}
	}else if(e.which == 38){ //ARROW UP
		//console.log("Parent >> ", $(e.target).parent("li"));
	}else if(e.which == 40){ //ARROW DOWN
		
	}
	return;
}
function taskEditKeyUp(e){
//	console.log("keyup >> ", e.which);
	if(e.which == 18){
		altPressed = false;
	}
	return;
}

//Textarea => span 태그
function updateTaskClick(el){
	var obj = $(el);
	var pid = obj.parents(".subjectList").siblings(".project").children("input[name=pid]").val();
	var sid = obj.parents(".taskList").siblings(".subject").children("input[name=sid]").val();
	var tid = obj.parents(".taskDiv").children("input[name=tid]").val();
	
	var taskContents = obj.parents(".taskContents");
	var infoBox = taskContents.children("div[name=infoBox]");
//	console.log("taskContents>>", taskContents);
//	console.log("infoBox>>", infoBox);
	var timeObj = infoBox.children("select");
	var time = timeObj.val();
//	console.log("timeObj>>", timeObj, time);
	var textareaObj = taskContents.children("textarea");
	var html = textareaObj.val();
    //줄바꿈은 <br>태그로 바꾸어준다.
    html = nl2br(html);
    
    console.log("update task >> pid:", pid, ", sid:", sid, ", tid:", tid, ", html:", html, ", time:", time);
    
    $.ajax({
		url: "doWorkTask.jsp"
		, type: "POST"
		, data: {
			action: "modifyWorkTask"
			, id: tid
			, memo: html
			, time: time
		}
		, success: function(data){
			
			if(data.result == true){
				infoBox.hide();
				var timeStr = taskContents.children("span[name = timeStr]");
				timeStr.show();
				var timeValue = timeStr.children("span[name = timeValue]");
			    timeValue.text(time);
			    
				var viewableText = $("<span class='taskText'></span>");
			    viewableText.html(html);
			    textareaObj.replaceWith(viewableText);
			}else{
				alert("작업을 업데이트할 수 없습니다.");
			}
		}
		, dataType: "json"
	});
}




/////////////////////////////

function addSubjectClick(el){
	var obj = $(el);
	wid = obj.siblings("input[name=wid]").val();
	pid = obj.siblings("input[name=pid]").val();
	var subjectList = obj.parents(".project").siblings(".subjectList");
	addSubject(wid, pid, subjectList);
}

function addSubject(wid, pid, subjectList){
	var subjectEl = $("#subjectElTemplate").clone(true);
	//템플릿에서 복사된 id제거.
	subjectEl.removeAttr("id");
	subjectText = subjectEl.find(".subjectText").text();
	
	//add subject into db
	//get sid
	$.ajax({
		url: "doWorkSubject.jsp"
		, data: {	
			action: "addWorkSubject"
			, wid: wid
			, pid: pid
			, title: subjectText
			, seq: 0
		}
		, success: function(data){
			
			if(data.sid != -1){
				//set sid into DOM
				subjectEl.find("input[name=sid]").val(data.sid);
				subjectText = subjectEl.find(".subjectText").text();
				console.log("add subject >> pid:", pid, ", sid:", subjectEl.find("input[name=sid]").val(), ", subjectText:", subjectText);
				
				subjectList.prepend(subjectEl);
//				subjectEl.show();
				subjectEl.removeClass("hide");
				
				taskList = subjectEl.find(".taskList");
				//sortable 속성추가.
				taskList.addClass("sortableTaskList");
				//하위 task도 sortable로 셋팅.
				taskList.sortable(taskSortableProperty);
				
				//addTask(wid, pid, data.sid, taskList);
			}else{
				alert("주제를 추가하지 못했습니다.");
			}
		}
		, dataType: "json"
	});
}

function subjectEdit() {

	var textObj = $(this).children("small").children("span");
    
	var text = textObj.text();
    var textareaText = $("<input class=\"input-xlarge\" name=\"textInput\"></input>" );
    textareaText.val(text);
    textObj.replaceWith(textareaText);
    textareaText.keypress(subjectEditKeyPress);
    textareaText.focus();
    var infoBoxObj = $(this).find("span[name = infoBox]");
    infoBoxObj.show();
}
function subjectEditKeyPress(e){
	if (e.which == 13) {
		updateSubjectClick(this);
	}
}
function removeSubjectClick(el){
	var obj = $(el);
	taskCount = obj.parents(".subject").siblings(".taskList").children("li").length;
	if(taskCount > 0){
		alert("하위 작업이 있어서 삭제할 수 없습니다.");
		return;
	}
	
	wid = obj.parents(".subjectList").siblings(".project").children("input[name=wid]").val();
	sid = obj.parents(".subject").children("input[name=sid]").val();
	
	var myList = obj.parents("li[name = subjectLi]");
	index = myList.index();
	console.log("remove subject >> wid:", wid, ", sid:", sid, ", index:", index);
	
	$.ajax({
		url: "doWorkSubject.jsp"
		, type: "POST"
		, data: {	
			action: "deleteWorkSubject"
			, id: sid
			, wid: wid
			, seq: index
		}
		, success: function(data){
			
			if(data.result == true){
				
				myList.remove();
				
			}else{
				alert("주제를 삭제할 수 없습니다.");
			}
		}
		, dataType: "json"
	});
	
}

function updateSubjectClick(el){
	var obj = $(el);
	sid = obj.parents(".subject").children("input[name=sid]").val();
	var infoBox = obj.parents(".subject").find("span[name = infoBox]");
	
	var textInput = obj.parents(".subject").find("input[name=textInput]");
	var title = textInput.val();
	
	console.log("update subject >> sid:", sid, ", title:", title);

	$.ajax({
		url: "doWorkSubject.jsp"
		, type: "POST"
		, data: {
			action: "modifyWorkSubject"
			, id: sid
			, title: title
		}
		, success: function(data){
			
			if(data.result == true){
				infoBox.hide();
				
				var viewableText = $("<span class='subjectText'></span>");
				viewableText.text(title);
				textInput.replaceWith(viewableText);
				
			}else{
				alert("작업을 업데이트할 수 없습니다.");
			}
		}
		, dataType: "json"
	});
	
}
 
//////////////////////////
function initWorkQueue(){
	var regdate = $('#myProject').siblings('input[name=regdate]').val();
	
	$.ajax({
		url: "doWork.jsp"
		,data: {
			action: "initWorkQueue"
			, pid: -1
			, regdate : regdate
		}
		,dataType: "json"
		,success: function(data){
			wid = data.wid;
			if(wid != -1){
				//work queue 초기화.
				var workQueue = $("#workQueue");
				var workQueueEl = $("#workQueueElTemplate").clone(true);
				workQueueEl.removeAttr("id");
//				workQueueEl.show();
				workQueueEl.removeClass("hide");
				workQueue.prepend(workQueueEl);
				workQueue.siblings(".project").children("input[name=wid]").val(wid);
				
				taskList = workQueueEl.find(".taskList");
				//sortable 속성추가.
				taskList.addClass("sortableTaskList");
				//하위 task도 sortable로 셋팅.
				taskList.sortable(taskSortableProperty);
				
				//재로딩.
				window.location.reload(true); 
			}else{
				alert("이미 작업큐가 존재합니다.");
			}
		}
		
	});
}
function viewAddProject(){
	$('#addProject').toggle();
}

function addProjectClick(){
	var pid = $('#myProject option:selected').val();
	var text = $('#myProject option:selected').text();
	var regdate = $('#myProject').siblings('input[name=regdate]').val();
	addProjectClick0(pid, text, regdate);
}
function addSolutionClick(){
	var pid = $('#mySolution option:selected').val();
	var text = $('#mySolution option:selected').text();
	var regdate = $('#mySolution').siblings('input[name=regdate]').val();
	addProjectClick0(pid, text, regdate);
}

function addProjectClick0(pid, text, regdate){

	if(pid != ""){
		$.ajax({
			url: "doWork.jsp"
			,data: {
				action: "addWorkProject"
				, pid: pid
				, regdate : regdate
			}
			,success: function(data){
				wid = data.wid;
				if(wid != -1){
					//1. 프로젝트 추가.
					var projectList = $("#projectList");
					var projectEl = $("#projectElTemplate").clone(true);
					projectEl.removeAttr("id");
					projectEl.find("input[name=wid]").val(wid);
					projectEl.find("input[name=pid]").val(pid);
					var obj = projectEl.children(".project").children("strong").children("a");
					obj.attr("href", "/WMS/project/info.jsp?pid="+pid+"&status=B");
					obj.children("small").text(text);
//					projectEl.show();
					projectEl.removeClass("hide");
					projectList.prepend(projectEl);
					
					console.log("add project pid:", pid);
					//2. 주제 list 정렬기능추가.
					var subjectList = projectEl.children(".subjectList");
					//sortable 속성추가.
					subjectList.addClass("sortableSubjectList");
					//하위 서브젝트도 sortable로 셋팅.
					subjectList.sortable(subjectSortableProperty);
					
					//3. 주제 추가.
					addSubject(wid, pid, subjectList);

				}else{
					alert("이미 프로젝트가 있습니다.");
				}
			}
			,dataType: "json"
		});
		
	}
}

///// 주간 프로젝트 추가 ///////
function addWeekProjectClick(){
	var pid = $('#myProject option:selected').val();
	var text = $('#myProject option:selected').text();
	var regdate = $('#myProject').siblings('input[name=regdate]').val();
	addWeekProjectClick0(pid, text, regdate);
}
function addWeekSolutionClick(){
	var pid = $('#mySolution option:selected').val();
	var text = $('#mySolution option:selected').text();
	var regdate = $('#mySolution').siblings('input[name=regdate]').val();
	addWeekProjectClick0(pid, text, regdate);
}

function addWeekProjectClick0(pid, text, regdate){

	if(pid != ""){
		$.ajax({
			url: "doWork.jsp"
			,data: {
				action: "addWeekWorkProject"
				, pid: pid
				, regdate : regdate
			}
			,success: function(data){
//				wid = data.wid;
				//if(wid != -1){
				if(data.result){
				//TODO 페이지를 리로드한다.
					alert("추가됨.");
				}else{
					alert("이미 프로젝트가 있습니다.");
				}
			}
			,dataType: "json"
		});
		
	}
}

///////

function removeProjectClick(el){
	var obj = $(el);
	var regdate = $('#myProject').siblings('input[name=regdate]').val();
	
	var myList = obj.parents("li[name = projectLi]");
	subjectCount = myList.children(".subjectList").children("li").length;
	//subjectCount = 0;
	if(subjectCount > 0){
		alert("하위 주제가 남아있어서 삭제할 수 없습니다.");
		return;
	}
	wid = obj.siblings("input[name=wid]").val();
	console.log("remove project >> wid:", wid);
	
	$.ajax({
		url: "doWork.jsp"
		, type: "POST"
		, data: {
			action: "deleteWorkProject"
			,id: wid
			,regdate: regdate
		}
		, success: function(data){
			
			if(data.result == true){
				myList.remove();
				
			}else{
				alert("프로젝트를 삭제할 수 없습니다.");
			}
		}
		, dataType: "json"
	});
	
}

//업무시작/마감보고
function submitWorkCheck(checkType){
	var obj = $(".workList").clone(true);//workList
	obj.find("button").remove();
	obj.find("select").remove();
//	obj.find("input:checkbox").remove();
	obj.find("input:hidden").remove();
	obj.find(".hide").remove();
	
	title = "";
	comment = "";
	if(checkType == "start"){
		title = "업무시작보고";
		comment = $("#startWorkComment").val();
	}else if(checkType == "finish"){
		title = "업무마감보고";
		comment = $("#finishWorkComment").val();
	}
	
	commentHTML = "";
	if(comment.length > 0){
		commentHTML = "<p>"+nl2br(comment)+"</p>\n";
	}
	
	$.ajax({
		url: "/WMS/message/doMessage.jsp"
		,type: "POST"
		,data: {
			action: "submitWorkCheck"
			,title: $("#reqDateStr").val()+" "+title
			,message: commentHTML + obj.html()
		}
		,dataType: "json"
		,success: function(data){
			if(data.result){
				$("#startWorkModal").modal("hide");
				$("#finishWorkModal").modal("hide");
				bootbox.alert("보고하였습니다.");
			}else{
				bootbox.alert("실패!");
			}
		}
	});
}

//////////////////////////////////
function goTodayWork(){
	goDateWork(new Date());
}

function goDateWork(date){
	submitGet("index.jsp", {dateStr: date.getFullYear() + "." + (date.getMonth() + 1) + "." + date.getDate()});
}

function goDateStrWork(dateStr){
	submitGet("index.jsp", {dateStr: dateStr});
}

function goWeekWork(dateStr){
	submitGet("index.jsp", {dateStr: dateStr, week: true});
}


////////////////////////////////////
//요청내용.

function viewModifyRequestInfo(rid){
	$("#request-content").load("viewRequestModify.jsp?rid="+rid, function(){
		
		selectObj = $("#request-content").find("select[name = userId]");
		selectUserId = $("#request-content").find("input[name = selectUserId]").val();
		prepareSelectUser(selectObj, false);
		setSelectValue(selectObj, selectUserId);
		$('#modifyModal').modal('show');
	});
}

function doneProjectRequest(){
	if(!$("#requestForm").valid())
		return;
	
	$("#requestForm input[name=action]").val("modifyByWork");
	$("#requestForm input[name=status]").val("D");
	$("#requestForm input[name=doneDate]").val($("#requestForm input[name=todayStr]").val());
	$("#requestForm").submit();
}

function modifyProjectRequest(){
	if(!$("#requestForm").valid())
		return;
	
	$("#requestForm input[name=action]").val("modifyByWork");
	$("#requestForm").submit();
}

function deleteProjectRequest(){
	if(confirm("삭제합니까?")){
		$("#requestForm input[name=action]").val("deleteByWork");
		$("#requestForm").submit();
	}
}