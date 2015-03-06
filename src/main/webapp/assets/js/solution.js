$(function() {
	$('.date').datepicker().on('changeDate', function(ev) {
		$(this).blur();
		$(this).datepicker('hide');
	});
});


function viewModifyProjectInfo(pid, statusFilter){
	$("#project-content").load("viewSolutionModify.jsp?pid="+pid+"&statusFilter="+statusFilter, function(){
		$('#modifyModal').modal('show');
	});
}

function insertProject(){
	$("#projectForm input[name=action]").val("insert");
	$("#projectForm").submit();
}

function modifyProject(){
	$("#projectForm input[name=action]").val("modify");
	$("#projectForm").submit();
}

function deleteProject(){
	if(confirm("삭제합니까?")){
		$("#projectForm input[name=action]").val("delete");
		$("#projectForm").submit();
	}
}


function selectProject(pid, status){
	submitGet("info.jsp", {pid: pid, status: status});
}



//////////////////////////////////////////////
//요청내용
//////////////////////////////////////////////
function viewInsertProjectRequest(){
	prepareSelectList();
	setSelectListValue();
	$('#insertModal').modal('show');
}

function insertProjectRequest(){
	$("#projectForm input[name=action]").val("insert");
	$("#projectForm").submit();
}

function modifyProjectRequest(){
	$("#projectForm input[name=action]").val("modify");
	$("#projectForm").submit();
}

function deleteProjectRequest(){
	if(confirm("삭제합니까?")){
		$("#projectForm input[name=action]").val("delete");
		$("#projectForm").submit();
	}
}


//////////////////////////////////////////////
//회의록
//////////////////////////////////////////////
function viewInsertProjectMeeting(){
	$('#insertModal').modal('show');
}

function insertProjectMeeting(){
	$("#projectForm input[name=action]").val("insert");
	$("#projectForm").submit();
}

function modifyProjectMeeting(){
	$("#projectForm input[name=action]").val("modify");
	$("#projectForm").submit();
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
function viewInsertProjectMaintain(){
	$('#insertModal').modal('show');
}

function insertProjectMaintain(){
	$("#projectForm input[name=action]").val("insert");
	$("#projectForm").submit();
}

function modifyProjectMaintain(){
	$("#projectForm input[name=action]").val("modify");
	$("#projectForm").submit();
}

function deleteProjectMaintain(){
	if(confirm("삭제합니까?")){
		$("#projectForm input[name=action]").val("delete");
		$("#projectForm").submit();
	}
}



