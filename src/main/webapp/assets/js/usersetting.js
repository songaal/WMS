$(function() {
	$("#userForm").validate();
	$("#restForm").validate();
	
	$('.date').datepicker().on('changeDate', function(ev){
		$(this).blur();
		$(this).datepicker('hide');
    });
	
	$('#liveDatePicker').datepicker().on('changeDate', function(ev){
    	//console.log(ev.date.getFullYear(), ev.date.getMonth()+1);
    	$("#liveDateForm input[name=year]").val(ev.date.getFullYear());
    	$("#liveDateForm input[name=month]").val(ev.date.getMonth()+1);
    	$("#liveDateForm").submit();
    });
    
    $('#liveDateTimePicker').datepicker().on('changeDate', function(ev){
    	//console.log(ev.date.getFullYear(), ev.date.getMonth()+1, ev.date.getDate());
    	$("#liveDateForm input[name=year]").val(ev.date.getFullYear());
    	$("#liveDateForm input[name=month]").val(ev.date.getMonth()+1);
    	$("#liveDateForm input[name=day]").val(ev.date.getDate());
    	$("#liveDateForm").submit();
    });
    
    $('.wms_late').css('cursor', 'pointer');
    $('.wms_late').click(function(e) {
    	obj = $(this);
    	liveDate = obj.siblings(".live_date").text();
    	year = $("#liveDateForm").children("input[name=year]").val();
    	month = $("#liveDateForm").children("input[name=month]").val();
		bootbox.prompt(liveDate+" 지각아님사유", function(memo) {
			if(memo == null){
				return;
			}
			if(memo == ""){
				bootbox.alert("사유를 적어주세요.");
				return;
			}
			
			submitPost("/WMS/usersetting/doCheckInOut.jsp", {action: "execuseLate", liveDate: liveDate, memo: memo, year: year, month: month});
		});
	});
});

function resetPasswd() {
	var accept = false;
	
	if((accept=confirm("패스워드를 초기화 하시겠습니까?"))) {
		
	}
	
	if(accept && (accept=confirm("패스워드가 초기화 됩니다.\n\n확실합니까?"))) {
		
	}
	
	if(accept) {
		$.ajax({
			url: "doUserSetting.jsp"
			,type: "POST"
			,data : {
				action: "resetPasswd"
			}
			,dataType: "json"
			,success: function(data){
				console.log(data);
				if(data.result == true){
					bootbox.alert("패스워드를 리셋 하였습니다.");
				}else{
					bootbox.alert("패스워드를 리셋하지 못했습니다.");
				}
			}
		});
	}
}

function updatePasswd(){
	
	//이전 폼 데이터 제거.
	oldPasswd = $('#userForm input[name=oldPasswd]').val();
	newPasswd = $('#userForm input[name=newPasswd]').val();
	newPasswd2 = $('#userForm input[name=newPasswd2]').val();
	if(oldPasswd.length == 0 || newPasswd.length == 0 || newPasswd2.length == 0){
		bootbox.alert("패스워드를 입력해주세요.");
	}else if(newPasswd != newPasswd2){
		bootbox.alert("새패스워드확인이 일치하지 않습니다.");
	}else{
		
		$.ajax({
			url: "doUserSetting.jsp"
			,type: "POST"
			,data : {
				action: "updatePasswd"
				,oldPasswd: oldPasswd
				,newPasswd: newPasswd
			}
			,dataType: "json"
			,success: function(data){
				console.log(data);
				if(data.result == true){
					$("form").validate().resetForm();
					$('#userForm input[name=oldPasswd]').val("");
					$('#userForm input[name=newPasswd]').val("");
					$('#userForm input[name=newPasswd2]').val("");
					bootbox.alert("패스워드를 업데이트 하였습니다.");
				}else{
					bootbox.alert("패스워드를 업데이트에 실패했습니다.");
				}
			}
		});
	}
	
}

//출근입력.
function doCheckIn(){
	submitPost("/WMS/usersetting/doCheckInOut.jsp", {action: "checkIn"});
}
function alreadyCheckIn(){
	bootbox.alert("출근입력을 할수 없습니다.");
}
//출근입력 묻기.
function doCheckInConfirm(){
	bootbox.confirm("출근을 입력합니다.", function(isOK){
		if(isOK){
			doCheckIn();
		}
	});
}
//퇴근입력.
function doCheckOut(){
	submitPost("/WMS/usersetting/doCheckInOut.jsp", {action: "checkOut"});
}
function alreadyCheckOut(){
	bootbox.alert("퇴근입력을 할수 없습니다.");
}
//외근입력
function doCheckOutterWork(){
	submitPost("/WMS/usersetting/doCheckInOut.jsp", {action: "checkInOutter"});
}


/////////////////////
//자신의 휴가 사용.
/////////////////////
function requestRestApproval(){
	
	$.ajax({
		url: "doRest.jsp"
		, type: "POST"
		, data: {
			action: "request"
			, category: $("#restForm select[name=category] option:selected").val()
			, amount: $("#restForm input[name=amount]").val()
			, applyDate: $("#restForm input[name=applyDate]").val()
			, memo: $("#restForm input[name=memo]").val()
		}
		, dataType: "json"
		, success: function(data){
			if(data.result == true){
				$("#spendModal").modal('hide');
				bootbox.alert("결재가 요청되었습니다.");
			}else{
				bootbox.alert("요청실패!");
			}
		}	
	});
} 

