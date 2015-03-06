$(function() {
	$(".date").datepicker().on("changeDate", function(ev) {
		$(this).blur();
		$(this).datepicker('hide');
	});
	
	var element = $("#logText")[0];
	
	if(element) {
		if(!element.innerHTML && $("#sampleContent")[0]) {
			element.innerHTML = $("#sampleContent").html();
		}
		CKEDITOR.config.tabSpaces = 4;
        CKEDITOR.config.height = 500;
		CKEDITOR.replace("logText");
	}
	
	element = $("#pmId");
	if(element[0]) {
		$.ajax({
			url: "/WMS/common/listUser.jsp"
			, async: false
			, dataType: "json"
			, success: function(j) {
				var options = '<option value="">:: 선택 ::</option>';
				for ( var i = 0; i < j.length; i++) {
					options += '<option value="' + j[i].value + '">' + j[i].name + '</option>';
				}
				element.html(options);
			}
		});
	}
	
	prepareSelectList();
});

var selectUser = "";

function toggleArea(areaOff, areaOn) {
	$("#"+areaOff).css("display","none");
	$("#"+areaOn).css("display","");
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

//수정폼의 기본값 설정.
function setModifiedSelectListValue(){
	///pmid
	val = $("#pmIdValue").val();
	$("select#pmId option[value="+val+"]").attr('selected', 'selected');
	
	///고객사
	val = $("#clientIdValue").val();
	$("select#clientId option[value="+val+"]").attr('selected', 'selected');
	//리스트생성.
	$("select#clientId").trigger('change', val);
	
	val = $("#clientPersonIdValue").val();
	$("select#clientPersonId option[value="+val+"]").attr('selected', 'selected');
	
	///구축업체.
	val = $("#resellerIdValue").val();
	$("select#resellerId option[value="+val+"]").attr('selected', 'selected');
	//리스트생성.
	$("select#resellerId").trigger('change', val);
	
	val = $("#resellerPersonIdValue").val();
	$("select#resellerPersonId option[value="+val+"]").attr('selected', 'selected');
}

function viewModifyProjectInfo(pid, statusFilter){
	$("#project-content").load("viewProjectModify.jsp?pid="+pid+"&statusFilter="+statusFilter, function(){
		prepareSelectList();
		setModifiedSelectListValue();
		$('#modifyModal').modal('show');
	});
}

function insertProject(){
	if($("#projectForm").valid()) {
		$("#projectForm input[name=action]").val("insert");
		$("#projectForm").submit();
	}
}

function modifyProject(){
	if($("#projectForm").valid()) {
		$("#projectForm input[name=action]").val("modify");
		$("#projectForm").submit();
	}
}

function deleteProject(){
	if(confirm("프로젝트를 삭제하시겠습니까?")){
		if(confirm("프로젝트 및 관련정보가 삭제되어 복원할 수 없게 됩니다. \n확실합니까?")) {
			$("#projectForm input[name=action]").val("delete");
			$("#projectForm").submit();
		}
	}
}


function selectProject(pid, status){
	submitGet("info.jsp", {pid: pid, status: status});
}

//////////////////////////////////////////////
//작업내용
//////////////////////////////////////////////
function viewModifyWorkInfo(wid){
	$("#work-content").load("viewWorkModify.jsp?wid="+wid);
	$('#modifyModal').modal('show');
}


function viewInsertProjectWork(){
	prepareSelectList();
	setSelectListValue();
	$('#insertModal').modal('show');
}

function insertProjectWork(){
	$("#projectForm input[name=action]").val("insert");
	$("#projectForm").submit();
}

function modifyProjectWork(){
	$("#workModify input[name=action]").val("modify");
	$("#workModify").submit();
}

function deleteProjectWork(){
	if(confirm("삭제합니까?")){		
		$("#workModify input[name=action]").val("delete");
		$("#workModify").submit();
	}
}

function completeWork(id, project_id)
{
	if(confirm("완료합니까?")){
	$("#projectForm input[name=action]").val("complete");
	$("#projectForm input[name=wid]").val(id);
	$("#projectForm input[name=pid]").val(project_id);
	$("#projectForm").submit();
	}
}



//////////////////////////////////////////////
//요청내용
//////////////////////////////////////////////
function viewModifyRequestInfo(rid){
	$("#request-content").load("viewRequestModify.jsp?rid="+rid);
	$('#modifyModal').modal('show');
}

function viewInsertProjectRequest(){
	prepareSelectList();
	setSelectListValue();
	$('#insertModal').modal('show');
}

function insertProjectRequest(){
	if($("#projectForm").valid()) {
		$("#projectForm input[name=action]").val("insert");
		$("#projectForm").submit();
	}
}

function modifyProjectRequest(){
	if($("#requestModifyForm").valid()) {
		$("#requestModifyForm input[name=action]").val("modify");
		$("#requestModifyForm").submit();
	}
}

function deleteProjectRequest(){
	if(confirm("삭제합니까?")){
		$("#requestModifyForm input[name=action]").val("delete");
		$("#requestModifyForm").submit();
	}
}

function appendProjectWork(){	
		$("#projectForm input[name=action]").val("appendWork");
		$("#projectForm").submit();	
}

//////////////////////////////////////////////
//회의록
//////////////////////////////////////////////

function viewModifyMeetingInfo(mid){
	$('#meeting-content').load("viewMeetingModify.jsp?mid="+mid);
	$('#modifyModal').modal('show');
}

function viewInsertProjectMeeting(){
	$('#insertModal').modal('show');
}

function insertProjectMeeting(){
	if($("#projectForm").valid()) {
		$("#projectForm input[name=action]").val("insert");
		$("#projectForm").submit();
	}
}

function modifyProjectMeeting(){
	if($("#projectForm").valid()) {
		$("#projectForm input[name=action]").val("modify");
		$("#projectForm").submit();
	}
}

function deleteProjectMeeting(){
	if(confirm("삭제합니까?")){
		$("#projectForm input[name=action]").val("delete");
		$("#projectForm").submit();
	}
}

//////////////////////////////////////////////
//정기점검
//////////////////////////////////////////////

function viewModifyMaintInfo(mid){
	$('#maint-content').load("viewMaintModify.jsp?mid="+mid);
	$('#modifyModal').modal('show');
}

function viewInsertProjectMaintain(){
	$('#insertModal').modal('show');
}

function insertProjectMaintain(){
	if($("#projectForm").valid()) {
		$("#projectForm input[name=action]").val("insert");
		$("#projectForm").submit();
	}
}

function modifyProjectMaintain(){
	if($("#projectForm").valid()) {
		$("#maintModifyFrm input[name=action]").val("modify");
		$("#maintModifyFrm").submit();
	}
}

function deleteProjectMaintain(){
	if(confirm("삭제합니까?")){
		$("#maintModifyFrm input[name=action]").val("delete");
		$("#maintModifyFrm").submit();
	}
}



