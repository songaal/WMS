if (typeof console == "undefined") var console = { log: function() {} };

var alertTimer; //알림체크 타이머

$(function() {
	var checkInterval = 10 * 1000; 
	//setTimeout(checkAlert, 2 * 1000);//페이지 전환시는 2초후에 확인한다. 
	//alertTimer = setInterval(checkAlert, checkInterval);
	
	$(".wms_tooltip").tooltip();
	$(".wms_popover").popover();
	$(".wms_popover").click(function(){return false;})
	

//	CKEDITOR.replace('memojangTextarea', {
//		width : '100%',
//		height : 400,
//	});
	
//	CKEDITOR.instances.memojangTextarea.on('key', function(event) {
//        //Text change code
//		if(event.data.keyCode == 1114195){
//			console.log("Save >>", event.editor);
//			event.cancel();
//		}
//    });
//	
//	$('#memojangDiv').hide();
	
});

var memoLoaded = false;

//function toggleMemojang(){
//	if ($('#memojangDiv').is(':visible')) {
//		//저장.
//		var editor = CKEDITOR.instances.memojangTextarea;
//		
//		$.ajax({
//			url: "/WMS/common/doMemo.jsp"
//			,type: "POST"
//			,data: {
//				action: "update"
//				,content: editor.getData()
//			}
//			,dataType: "json"
//			,success: function(data){
//				// Check the active editing mode.
//				if (data.result) {
//					$('#memojangDiv').hide();
//				}else{
//					alert("에러");
//				}
//			}
//			,error: function(a, b){
//				alert("메모저장 에러 "+b);
//			}
//		});
//		
//	}else{
//		//처음로딩시는 데이터를 불러온다.
//		if(memoLoaded){
//			$('#memojangDiv').show();
//			return;
//		}
//		
//		$.ajax({
//			url: "/WMS/common/doMemo.jsp"
//			,data: {
//				action: "select"
//			}
//			,dataType: "html"
//			,success: function(data){
//				var editor = CKEDITOR.instances.memojangTextarea;
//
//				// Check the active editing mode.
//				if (editor.mode == 'wysiwyg') {
//					// Insert HTML code.
//					editor.insertHtml(data);
//					$('#memojangDiv').show();
//					memoLoaded = true;
//				}else{
//					alert("에러");
//				}
//			}
//			,error: function(a, b){
//				alert("메모로딩 에러 "+b);
//			}
//		});
//	}
//	
//}
function checkAlert(){
	$.ajax({
		url: "/WMS/common/doCheckAlert.jsp"
		,dataType: "json"
		,success: function(data){
			if(data.result){
				console.log("알림확인.	", data);
				
				if(window.webkitNotifications){
					if(window.webkitNotifications.checkPermission() == 0){
						var noti = window.webkitNotifications.createNotification('icon.png', '새메시지 도착', data.message);
						noti.show();
					}
				}
				//alert도 함께 띄운다.
				alert(data.message+"\n");
			}
		}
		,error: function(data){
			clearInterval(alertTimer);
			console.log("알림에러.	", data);
			//bootbox.alert("세션이 만료되거나, 에러가 발생했습니다.");
		}
	});
}


function logout(){
	//var url = "/WMS/doLogin.jsp?action=logout";
	bootbox.confirm("퇴근합니까?", function(isYes){
		if(isYes){
			//퇴근입력.
			$.ajax({
				url: "/WMS/usersetting/doCheckInOut.jsp"
					,data: {
						action: "checkOut"
					}
			,async: false
			});
		}
		
		submitPost("/WMS/doLogin.jsp", {action: "logout"});
	});
}

function nl2br(str){
	return $.trim(str).replace(/\n/g,"<br>");
}

function br2nl(str){
	return str.replace(/(<br>)|(<br \/>)|(<p>)|(<\/p>)/g,"\n");
}

function submitGet(url, data){
	submitForm(url, data, "GET");
}
function submitPost(url, data){
	submitForm(url, data, "POST");
}
//가상의 폼을 만들어서 sumit한다.
function submitForm(url, data, method){
	
    $('body').append($('<form/>', {
		id : 'jQueryPostItForm',
		method : method,
		action : url
	}));

	for ( var i in data) {
		$('#jQueryPostItForm').append($('<input/>', {
			type : 'hidden',
			name : i,
			value : data[i]
		}));
	}

	$('#jQueryPostItForm').submit();
}

//기존에 존재하는 form을 해석하여 ajax call로 변환해준다.
function submitFormAjax(formObj, url, method, dataType, successFunction){
	//formObj에서 data를 찾아서 {}로 만들어준다.
	var dataObj = {};
	
	//select는 다중값 처리되지 않음.
	formObj.find("select").each(function(){
		name = $(this).attr("name");
		if(name != ""){
			$(this).find("option").each(function(){
				if($(this).attr("selected") == "selected"){
					dataObj[name] = $(this).val();
					return;
				}
			});
		}
	});
	formObj.find("input").each(function(){
		name = $(this).attr("name");
		if(name != ""){
			dataObj[name] = $(this).val();
		}
	});
	formObj.find("textarea").each(function(){
		name = $(this).attr("name");
		if(name != ""){
			dataObj[name] = $(this).val();
		}
	});
	//TODO
	//다른 종류의 폼들도 추가해야함.
	
	$.ajax({
		url: url
		, data: dataObj
		, type: method
		, dataType: dataType
		, success: successFunction
	});
	
}


function getTimeStr(date){
	return date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate() + ' '+date.getHours()+':'+date.getMinutes() + ':'+date.getSeconds(); 
}

function getOnlyDateStr(date){
	d = date.getDate();
	if(d < 10){
		d = "0" + d;
	}
	return (date.getMonth()+1)+'.'+d;
}

function getOnlyTimeStr(date){
	m = date.getMinutes();
	if(m < 10){
		m = "0" + m;
	}
	return date.getHours()+':'+m;
}

function isTheSameDate(date1, date2){
	return (date1.getFullYear() == date2.getFullYear()) && (date1.getMonth() == date2.getMonth()) && (date1.getDate() == date2.getDate());
}
function prepareSelectUser(selectObj, async){
	$.ajax({
		url: "/WMS/common/listUser.jsp"
		, async: async
		, dataType: "json"
		, success: function(j) {
			var options = '<option value="">:: 선택 ::</option>';
			for ( var i = 0; i < j.length; i++) {
				options += '<option value="' + j[i].value + '">' + j[i].name + '</option>';
			}
			selectObj.html(options);
		}
	});
}

function setSelectValue(selectObj, val){
	console.log("selectObj >>", selectObj, selectObj.find("option"));
	selectObj.find("option").each(function(){
		if ($(this).val() == val) {
			console.log("compare>> ", $(this).val(), val);
			$(this).attr("selected", "selected");
			return;
		}
	});
}

function parseDate(dateString){
	var date = new Date();
	date.setYear(parseInt(dateString.substr(0, 4), 10));
	date.setMonth(parseInt(dateString.substr(5, 2), 10) - 1);
	date.setDate(parseInt(dateString.substr(8, 2), 10));
	date.setHours(0, 0, 0, 0);
	return date;
}
