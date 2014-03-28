$(function() {
	
	//입사일 날짜선택은 class로 안되는 현상이 발생하여 id로 처리함.
	$('#enterDatePicker').datepicker().on('changeDate', function(ev){
		$(this).blur();
		$(this).datepicker('hide');
    });
	
	$('#enterDatePicker2').datepicker().on('changeDate', function(ev){
		$(this).blur();
		$(this).datepicker('hide');
    });
	
	$('.date').datepicker().on('changeDate', function(ev){
		$(this).blur();
		$(this).datepicker('hide');
    });
	
	$("#addUserForm").validate();
    
	$('#liveDatePicker').datepicker().on('changeDate', function(ev){
    	$("#liveDateForm input[name=year]").val(ev.date.getFullYear());
    	$("#liveDateForm input[name=month]").val(ev.date.getMonth()+1);
    	$("#liveDateForm").submit();
    });
	
	
});

function viewInsertUserInfo(){
	//이전 폼 데이터 제거.
	$('#addUserForm')[0].reset();
	//이전 에러메시지 제거.
	$("form").validate().resetForm();
	
	$('#addUser').show();
}

function viewModifyUserInfo(sid){
	$("#user-info").load("viewUserModify.jsp?serialId="+sid);
	$('#modifyModal').modal('show');
}

function modifyUser(){
	$("#updateUserForm input[name=action]").val("modify");
	$("#updateUserForm").submit();
}

function deleteUser(){
	if(confirm("삭제합니까?")){
		$("#updateUserForm input[name=action]").val("delete");
		$("#updateUserForm").submit();
	}
}

function viewRestDetail(userSID){
	submitPost("restDetail.jsp", {userSID: userSID});
}

function selectApproval(type){
	submitPost("approval.jsp", {type: type});
}

/////////////////////
//관리자 휴가관리.
/////////////////////
function issueRestApproval(){
	
	$.ajax({
		url: "doRest.jsp"
		, type: "POST"
		, data: {
			action: "issue" //발급
			, userSID: $("#restIssueForm input[name=userSID]").val()
			, applyDate: $("#restIssueForm input[name=applyDate]").val()
			, category: $("#restIssueForm select[name=category] option:selected").val()
			, amount: $("#restIssueForm input[name=amount]").val()
			, memo: $("#restIssueForm input[name=memo]").val()
		}
		, dataType: "json"
		, success: function(data){
			if(data.result == true){
				$("#issueModal").modal('hide');
				bootbox.alert("결제가 요청되었습니다.");
			}else{
				bootbox.alert("요청실패!");
			}
		}	
	});
} 
function spendRestApproval(){
	
	$.ajax({
		url: "doRest.jsp"
		, type: "POST"
		, data: {
			action: "spend" //사용
			, userSID: $("#restSpendForm input[name=userSID]").val()
			, applyDate: $("#restSpendForm input[name=applyDate]").val()
			, category: $("#restSpendForm select[name=category] option:selected").val()
			, amount: $("#restSpendForm input[name=amount]").val()
			, memo: $("#restSpendForm input[name=memo]").val()
		}
		, dataType: "json"
		, success: function(data){
			if(data.result == true){
				$("#spendModal").modal('hide');
				bootbox.alert("결제가 요청되었습니다.");
			}else{
				bootbox.alert("요청실패!");
			}
		}	
	});
} 

//////////////////////////////////
//권한관리
function viewModifyUserReport(sid){
	$("#user-info").load("viewUserReportModify.jsp?userSID="+sid);
	$('#modifyModal').modal('show');
}

function modifyUserReport(){
	$("#updateUserForm input[name=action]").val("modify");
	$("#updateUserForm").submit();
}


/////
//출결관리
/////

function submitCheckInOutList(){
	$("#liveDateForm").submit();
}


function pagePrint() {
	Obj = $("#printArea");
    var W = 870;        //screen.availWidth; 
    var H = 700;       //screen.availHeight;

    var features = "menubar=no,toolbar=no,location=no,directories=no,status=no,scrollbars=yes,resizable=yes,width=" + W + ",height=" + H + ",left=0,top=0"; 
    var PrintPage = window.open("about:blank","printArea",features); 

    PrintPage.document.open(); 
    PrintPage.document.write("<html><head><title></title>" +
    		"<link href='/WMS/assets/css/bootstrap.css' rel='stylesheet'>" +
    		"<style type='text/css'>body, tr, td, input, textarea { font-family:Tahoma; font-size:9pt; }</style>\n</head>\n<body>" + Obj.html() + "\n</body></html>"); 
    PrintPage.document.close(); 

    PrintPage.document.title = document.domain; 
    PrintPage.print(); 
    //PrintPage.close();
}
