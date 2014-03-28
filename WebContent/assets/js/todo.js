$(function() {
	var element = $(".clicked");
	if(element[0]) {
		var wid = element.attr("id").substring(4);
		expandDetail(wid);
	}
	
	$(".date").datepicker().on("changeDate", function(ev) {
		$(this).blur();
		$(this).datepicker('hide');
	});
});

function viewTodoList(typeData){
	submitGet("index.jsp", {type: typeData});
}
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

//////////////////////////////////////////////
//작업내용
//////////////////////////////////////////////
function viewModifyWorkInfo(wid){
	$("#work-content").load("viewTodoModify.jsp?wid="+wid);
	$('#modifyModal').modal('show');
}


function viewInsertProjectWork(){
	prepareSelectList();	
	$('#insertModal').modal('show');
}

function insertProjectWork(){
	if($("#projectForm").valid()) {
		$("#projectForm input[name=action]").val("insert");
		$("#projectForm").submit();
	}
}

function modifyProjectWork(){
	if($("#workModify").valid()) {
		$("#workModify input[name=action]").val("modify");
		$("#workModify").submit();
	}
}

function deleteProjectWork(){
	if(confirm("삭제합니까?")){		
		$("#workModify input[name=action]").val("delete");
		$("#workModify").submit();
	}
}

function prepareSelectList(){
	
	$.ajax({
		url: "/WMS/common/listUser.jsp"
		, async: false
		, dataType: "json"
		, success: function(j) {
			var options = '<option value="">:: 선택 ::</option>';
			for ( var i = 0; i < j.length; i++) {
				options += '<option value="' + j[i].value + '">' + j[i].name + '</option>';
			}
			$("select#websqrdPersonId").html(options);
		}
	});
	
	$.ajax({
		url: "/WMS/common/listClient.jsp"
		, async: false
		, dataType: "json"
		, data: { type : "A" }
		, success: function(j) {
			var options = '<option value="">:: 선택 ::</option>';
			for ( var i = 0; i < j.length; i++) {
				options += '<option value="' + j[i].value + '">' + j[i].name + '</option>';
			}
			options += '<option value="NEW" >[신규입력]</option>';
			$("select#clientId").html(options);
		}
	});
	
	$("select#clientId").change(
		function() {
			if($(this).val() == "NEW"){
				$("select#clientPersonId").html('<option value="NEW" >[신규입력]</option>');
				$("#newClientId").show();
				$("#newClientPersonId").show();
			}else{
				$("#newClientId").hide();
				$("#newClientPersonId").hide();
				$.ajax({
					url: "/WMS/common/listClientPerson.jsp"
					, async: false
					, dataType: "json"
					, data: {cid : $(this).val()} 
					, success: function(j) {
						var options = '<option value="">:: 선택 ::</option>';
						for ( var i = 0; i < j.length; i++) {
							options += '<option value="' + j[i].value + '">' + j[i].name + '</option>';
						}
						options += '<option value="NEW" >[신규입력]</option>';
						$("select#clientPersonId").html(options);
					}
				});
			}
		}
	);
	$("select#clientPersonId").change(
		function() {
			if($(this).val() == "NEW"){
				$("#newClientPersonId").show();
			}else{
				$("#newClientPersonId").hide();
			}
		}
	);

	
	$.ajax({
		url: "/WMS/common/listClient.jsp"
		, async: false
		, dataType: "json"
		, data: { type : "B" }
		, success: function(j) {
			var options = '<option value="">:: 선택 ::</option>';
			for ( var i = 0; i < j.length; i++) {
				options += '<option value="' + j[i].value + '">' + j[i].name + '</option>';
			}
			options += '<option value="NEW" >[신규입력]</option>';
			$("select#resellerId").html(options);
		}
	});
	$("select#resellerId").change(
		function() {
			if($(this).val() == "NEW"){
				$("select#resellerPersonId").html('<option value="NEW" >[신규입력]</option>');
				$("#newResellerId").show();
				$("#newResellerPersonId").show();
			}else{
				$("#newResellerId").hide();
				$("#newResellerPersonId").hide();
				$.ajax({
					url: "/WMS/common/listClientPerson.jsp"
					, async: false
					, dataType: "json"
					, data: {cid : $(this).val()} 
					, success: function(j) {
						var options = '<option value="">:: 선택 ::</option>';
						for ( var i = 0; i < j.length; i++) {
							options += '<option value="' + j[i].value + '">' + j[i].name + '</option>';
						}
						options += '<option value="NEW" >[신규입력]</option>';
						$("select#resellerPersonId").html(options);
					}
				});
			}
		}
	);
	$("select#resellerPersonId").change(
		function() {
			if($(this).val() == "NEW"){
				$("#newResellerPersonId").show();
			}else{
				$("#newResellerPersonId").hide();
			}
		}
	);
}

//추가폼의 기본값 설정.
function setSelectListValue(){
	///pmid
	val = $("#pmIdValue").val();
	$("select#pmId option[value="+val+"]").attr('selected', 'selected');
}
