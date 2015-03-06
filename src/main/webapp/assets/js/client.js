$(function() {

    
});

//고객사페이지
function viewClientA(){
	submitGet("client.jsp", { ctype: 'A'});
}
//리셀러페이지
function viewClientB(){
	submitGet("client.jsp", { ctype: 'B'});
}

function viewInsertClientInfo(){
	//이전 폼 데이터 제거.
	$('#addForm')[0].reset();
	//이전 에러메시지 제거.
	$("form").validate().resetForm();
	
	$('#addClient').show();
}

function viewModifyClientInfo(id){
	$("#client-info").load("viewClientModify.jsp?cid="+id);
	$('#modifyModal').modal('show');
}

function modifyClient(){
	$("#updateForm input[name=action]").val("modify");
	$("#updateForm").submit();
}

function deleteClient(){
	if(confirm("삭제합니까?")){
		$("#updateForm input[name=action]").val("delete");
		$("#updateForm").submit();
	}
}



/////



function viewInsertClientPersonInfo(){
	//이전 폼 데이터 제거.
	$('#addForm')[0].reset();
	//이전 에러메시지 제거.
	$("form").validate().resetForm();
	
	$('#addClientPerson').show();
}

function viewModifyClientPersonInfo(id){
	$("#client-info").load("viewClientPersonModify.jsp?id="+id);
	$('#modifyModal').modal('show');
}

function modifyClientPerson(){
	if ( $("#updateForm").validate() )	{
	$("#updateForm input[name=action]").val("modify");
	$("#updateForm").submit();
	}
}

function deleteClientPerson(){
	if(confirm("삭제합니까?")){
		$("#updateForm input[name=action]").val("delete");
		$("#updateForm").submit();
	}
}
