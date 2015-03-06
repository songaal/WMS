/*
 * 항목 클릭시 자세한 내용 펼쳐지는 스크립트.
 * */
var prevId = -1;
function expandDetail(id){
	var contentBody = $("#detail_"+id).html();
	var tb = $("#td_"+id);
	
//	console.log("nextTb >> ", nextTb);
//	console.log("nextTb.children().length >> ", nextTb.children().length);
	if(id != prevId){
		tb.after("<tr class='atv'><td></td><td colspan=13 style='text-align:left;'>"+contentBody+"</td></tr>");
		if(prevId > 0){
			var tb = $("#td_"+prevId);
			var nextTb = tb.next();
			nextTb.remove();
		}
		prevId = id;
	}else{
		nextTb = tb.next();
		nextTb.remove();
		prevId = -1;
	}
}

function viewSalesList(typeData){
	submitGet("index.jsp", {type: typeData});
}

function viewInsertSalesInfo(){
	$('#insertModal').modal('show');
}

function viewModifySalesInfo(sid){
	$("#sales-content").load("viewSalesModify.jsp?salesId="+sid);
	$('#modifyModal').modal('show');
}

function insertSales(){
	$("#salesForm input[name=action]").val("insert");
	$("#salesForm").submit();
}

function modifySales(){
	$("#salesForm2 input[name=action]").val("modify");
	console.log($("#salesForm2"));
	$("#salesForm2").submit();
}

function deleteSales(){
	if(confirm("삭제합니까?")){
		$("#salesForm2 input[name=action]").val("delete");
		$("#salesForm2").submit();
	}
}