/*
 * 항목 클릭시 자세한 내용 펼쳐지는 스크립트.
 * */
var prevId = -1;
function viewMyDetail(aprvType, id, aprvId, showType){
	var url = "";
	if(aprvType == 'A' || aprvType == 'a'){
		url = "viewMyAprvRest.jsp";
	}else if(aprvType == 'B'){
		url = "viewMyAprvCharge.jsp";
	}else if(aprvType == 'C'){
		url = "viewMyAprvBook.jsp";
	}else if(aprvType == 'D'){
		url = "viewMyAprvCommon.jsp";
	}
	viewDetail0(url, id, aprvId, showType);
}
function viewDetail(aprvType, id, aprvId, showType){
	var url = "";
	if(aprvType == 'A' || aprvType == 'a'){
		url = "viewAprvRest.jsp";
	}else if(aprvType == 'B'){
		url = "viewAprvCharge.jsp";
	}else if(aprvType == 'C'){
		url = "viewAprvBook.jsp";
	}else if(aprvType == 'D'){
		url = "viewAprvCommon.jsp";
	}
	viewDetail0(url, id, aprvId, showType);
}
function viewDetail0(url, id, aprvId, showType){
	$("#message-content").load(url+"?id="+id+"&aprvId="+aprvId+"&showType="+showType);
	$('#readModal').modal('show');
}

function approvalRequest(id, type){
	bootbox.confirm("승인합니까?", function(isOK){
		if(isOK){
			submitPost("doApproval.jsp", {action:"approve", type:type, id: id, memo: $("#memo_"+id).val() });
		};
	});
} 
function rejectRequest(id, type){
	bootbox.confirm("반려합니까?", function(isOK){
		if(isOK){
			submitPost("doApproval.jsp", {action:"reject", type:type, id: id, memo: $("#memo_"+id).val() });
		};
	});
} 