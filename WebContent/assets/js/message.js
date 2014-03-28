$(function() {
	if($("#messageTextarea").length > 0){
		CKEDITOR.replace( 'messageTextarea', { skin:'moono',tabSpaces:4 });
		
		messageHtml = $("#messageForm textarea[name=message]").val();
		if(messageHtml.length > 0){
			var oEditor = CKEDITOR.instances.messageTextarea;
			oEditor.setData("<br><br>-------------------------------<br>\n"+messageHtml);
		}
	}
	
	receiverSelect = $("#receiverSelect");
	if(receiverSelect){
		prepareSelectUser(receiverSelect, false);
	}

	if(selectUser != ""){
		setSelectValue(receiverSelect, selectUser);
	}
	
	referencerSelect = $("#referencerSelect");
	if(referencerSelect){
		prepareSelectUser(referencerSelect, false);
	}

	if(selectUser != ""){
		setSelectValue(referencerSelect, selectUser);
	}
});

var selectUser = "";

function sendMessage(){
	var oEditor = CKEDITOR.instances.messageTextarea;
	$("#messageForm textarea[name=message]").val(oEditor.getData());
	if($("#messageForm").valid()){
		$("#messageForm").submit();
	}
}

function readMessage(el, id, viewType){
	console.log("this>> ",$(el));
	var unreadTr = $(el).parents(".warning");
	if(unreadTr.length > 0){
		console.log("unreadTr>> ",unreadTr);
		unreadTr.removeClass("warning");
		unreadTr.children(".receiveDate").text("[읽음]");
	}
	$("#message-content").load("viewReadMessage.jsp?id="+id+"&viewType="+viewType);
	$('#readModal').modal('show');
}

//답장보내기.
function replyMessage(){
	sender = $("#readModal").find("input[name=sender]").val();
	receiver = $("#readModal").find("input[name=receiver]").val();
	titleText = "Re: "+$("#readModal").find("td[id=titleText]").text();
	messageHtml = $("#readModal").find("td[id=messageHtml]").html();
	console.log(sender, receiver, titleText , messageHtml);
	submitPost("write.jsp", {action:"sendMessage", receiver: sender, title: titleText, message: messageHtml});
}
