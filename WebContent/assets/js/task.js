$(function() {
	$('document').ready(function() {
		callInterval();
	});

	$('#liveDatePicker').datepicker().on('changeDate', function(ev) {
		$("#liveDateForm input[name=year]").val(ev.date.getFullYear());
		$("#liveDateForm input[name=month]").val(ev.date.getMonth() + 1);
		$("#liveDateForm").submit();
	});

	$('#userSelect').on('change', function(ev) {
		selectUser = $('#userSelect').val();
		$("#liveDateForm input[name=user]").val($('#userSelect').val());
		$("#liveDateForm").submit();
	});

	function dblClick(divElem) {
		var div = $(divElem);
		var form = $(divElem).parent().parent();
		$.ajax({
			type : "POST",
			url : "doTask.jsp",
			dataType : "json",
			data : {
				taskdate : form.find("#taskdate").val(),
				content : form.find("#content").text(),
				issue : form.find("#issue").text(),
				userId : form.find("#UserId").val(),
				action : "checkEditable",
				tid : form.find("#tid").val(),
				async : true
			},
			success : function(response) {
				// if (response.result == "0") {
				form.find("#tid").val(response.tid);
				$.ajax({
					type : "POST",
					url : "doTask.jsp",
					dataType : "json",
					async : true,
					data : {
						taskdate : form.find("#taskdate").val(),
						content : form.find("#content").text(),
						issue : form.find("#issue").text(),
						userId : form.find("#UserId").val(),
						action : "setEdit",
						tid : form.find("#tid").val()
					},
					success : function(data) {
						if (data.result == "0") {
							{
								console.log($(this));
								console.log(div);
								div.attr("contenteditable", "true");
								form.find("#tid").val(data.tid);
								editMode = true;
							}
						}
					}
				});
				// } else {
				// $(this).attr("contenteditable", "false");
				// alert("이미 편집중입니다.");
				// }
			}
		});
	}

	$("div.fc-day-content").dblclick(function() {
		if ($(this).attr("contenteditable") == "true")
			return false;

		dblClick($(this));
		return false;
	});

	$("div.fc-day-issue").dblclick(function() {
		if ($(this).attr("contenteditable") == "true")
			return false;
		dblClick($(this));
		return false;
	});

	$("div.fc-day-content").keypress(function(event) {
		if ((event.shiftKey || event.altKey || event.ctrlKey) && event.which == 13) {
			if (event.which == 13) {
				$("div.fc-day-content").blur()
				return;
			}
		}
	});

	$("div.fc-day-issue").keypress(function(event) {
		console.log('keypress');
		if ((event.shiftKey || event.altKey || event.ctrlKey) && event.which == 13) {
			$("div.fc-day-issue").blur();
			return;
		}		
	});

	$("div.fc-day-content").blur(function() {
		onBlur($(this));
	});

	$("div.fc-day-issue").blur(function() {
		onBlur($(this));
	});

	function onBlur(divElem) {
		editMode = false;

		console.log("onBlur");

		var div = $(divElem);
		var form = $(divElem).parent().parent();

		var content = form.find("#content");
		var issue = form.find("#issue");
		$(content).attr("contenteditable", "false");
		$(issue).attr("contenteditable", "false");

		var divContent = form.find(".fc-day-content");
		var divIssue = form.find(".fc-day-issue");

		var contentText = htmlToText($(divContent).html(), null);
		var issueText = htmlToText($(divIssue).html(), null);

		content.val(contentText);
		issue.val(issueText);

		doPost(form.find("#taskdate"), form.find("#content"), form
				.find("#issue"), form.find("#UserId"), form.find("#tid"));
	}

	userSelect = $("#userSelect");
	if (userSelect) {
		prepareSelectUser(userSelect, false);
	}

	if (selectUser != "") {
		setSelectValue(userSelect, selectUser);
	}
});

// /////////////////////////////////////////////////
// /데이타를 쏘는 부분
// /////////////////////////////////////////////////

function doPost(taskdate, content, issue, userId, tid) {
	//console.log(content.val());
	//console.log(issue.val());
	// alert("doPost Called");
	// alert(taskdate.val() + ":" + content.text() + ":" + issue.text() + ":" +
	// id.val());
	$.ajax({
		type : "POST",
		url : "doTask.jsp",
		data : {
			taskdate : taskdate.val(),
			content : content.val(),
			issue : issue.val(),
			userId : userId.val(),
			action : "updateInsert",
			tid : tid.val(),
			id : tid.val()
		}
	});
}

function callInterval() {
	window.setInterval("loadTask()", 60000);
}

function loadTask() {
	console.log("loadTask Called");
	if (editMode == false)
		$('#liveDateFormn').submit();
}

/*
 * var div = $(this); var form = $(this).parent().parent(); $.ajax({ type :
 * "POST", url : "doTask.jsp", dataType : "json", data : { taskdate :
 * form.find("#taskdate").val(), content : form.find("#content").text(), issue :
 * form.find("#issue").text(), userId : form.find("#UserId").val(), action :
 * "checkEditable", tid : form.find("#tid").val(), async : true }, success :
 * function(response) { if (response.result == "0") {
 * form.find("#tid").val(response.tid); $.ajax({ type : "POST", url :
 * "doTask.jsp", dataType : "json", async : true, data : { taskdate :
 * form.find("#taskdate").val(), content : form.find("#content").text(), issue :
 * form.find("#issue").text(), userId : form.find("#UserId").val(), action :
 * "setEdit", tid : form.find("#tid").val() }, success : function(data) { if
 * (data.result == "0") { { console.log($(this)); console.log(div);
 * div.attr("contenteditable", "true"); form.find("#tid").val(data.tid); } } }
 * }); } else { $(this).attr("contenteditable", "false"); alert("이미 편집중입니다."); } }
 * }); return false;
 * 
 */