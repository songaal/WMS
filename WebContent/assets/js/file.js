// /////////////////////////////////////////////////
// /데이타를 쏘는 부분
// /////////////////////////////////////////////////
function deleteFileInfo(id){
	if(confirm("삭제합니까?")){		
		$.ajax({
			type : "POST",
			url : "doAttach.jsp",
			dataType : "json",
			data : {
				fileInfoId : id,
				action : "delete",			
				async : false
			},
			success : function(data) {				
				window.location.reload(false);
			}		
		});
	}
}
///////////////////////////////////////////////////
///데이타를 쏘는 부분
///////////////////////////////////////////////////
function uploadFile()
{			
	 $("#file_upload2").ajaxForm( {
     	url:"/WMS/attachment",
     	dataType:'json',
     	async : false,
     	success:function(jsonObj) {
     		if ( jsonObj.result == 1)
     			alert(jsonObj.errmsg);		     		
     	}
     }
     ).submit();
	 $('#fileInsertModal').modal('hide');
	 window.location.reload(false);
}	

function copyUrl(id) 
{ 
	var IE = (document.all) ? true : false; 
	var URL = '/WMS/download?id='+id;   
	if (IE) { 
		window.clipboardData.setData('Text', URL); 
		alert('주소가 복사되었습니다. Ctrl+V로 붙여 넣기 하세요.'); 
	} else { 
		temp = prompt("이 링크의 주소입니다. Ctrl+C를 눌러 클립보드로 복사하세요", URL ); 
	} 
}		

function copyTag(id,fileName) 
{
	var IE = (document.all) ? true : false;
	var URL = '/WMS/download?id='+id;   
	var Anchor = '<a href="' + URL + '" target="about:blank">'+fileName + '</a>';
	if (IE) {
		window.clipboardData.setData('Text', Anchor); 
		alert('Ctrl+V로 붙여 넣기 하세요.');
	} else	{
		temp = prompt("Ctrl+C를 눌러 클립보드로 복사하세요", Anchor );
	}
}		