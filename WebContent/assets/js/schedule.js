$(function(){
	loadEvents();
	
});

var visitYearMonth = {};
var selectCell;

function loadEvents(){
	
	if($('#calendar').length == 0)
		return;

	var calendar = $('#calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		selectable: true,
		selectHelper: true,
		timeFormat: 'H:mm',
		viewDisplay: function (element) {
			console.log("element>>", element.start, "//// ", element.visStart);
			var y = element.start.getFullYear();
			var m = element.start.getMonth() + 1;
			
			key = y+"-"+m;
			if(visitYearMonth[key]){
				console.log("방문한 년월이라서 무시.", y, m);
				return;
			}
			visitYearMonth[key] = true;
			
			year = y;
			month = m;
			
			$.ajax({
				url : 'doSchedule.jsp',
				type : 'POST',
				data : {
					action : 'listMonth'
					, year: y
					, month : m
				},
				dataType: "json",
				success: function(data){
					for(i=0;i<data.length; i++){
						event = data[i];
						console.log("event-"+i+" >> ", event.id, event.title, event.start);
						calendar.fullCalendar('renderEvent',
							{
								id: event.id,
								title: event.title,
								start: event.start,
								end: event.end,
								allDay: event.allDay
							},
							true // make the event "stick"
						);
					}
				},
				error : function() {
					alert('일정을 가져오지 못했습니다.');
				}
			});
	    },
		eventClick: function(calEvent, jsEvent, view) {
			if(selectCell != calEvent){
				selectCell = calEvent;
				return;
			}
	        console.log('Event: ' + calEvent.title, ", id=", calEvent.id);
	        bootbox.confirm("일정을 삭제합니까?", function(isOK){
	        	if(isOK){
		        	$.ajax({
		 				url : 'doSchedule.jsp',
		 				type : 'POST',
		 				data : {
		 					action : 'delete'
		 					,id : calEvent.id
		 				},
		 				dataType: "json",
		 				success: function(data){
		 					if(data.result){
		 						calendar.fullCalendar("removeEvents", calEvent.id);
		 					}else{
		 						bootbox.alert("자신의 일정만 삭제가능합니다.");
		 					}
		 				},
		 				error : function() {
		 					alert('일정을 삭제에러');
		 				}
		 			});
	        	}
	        	selectCell = null;
	        });
	       
	        
	    },
	   
		select: function(start, end, allDay) {
			console.log(start, end, allDay);
			var allDayStr = 0;
			if(allDay){
				allDayStr = 1;
			}
			if(allDay){
				timeInfo = getOnlyDateStr(start);
				if(!isTheSameDate(start, end)){
					timeInfo = timeInfo+"~"+getOnlyDateStr(end);
				}
			}else{
				timeInfo = getOnlyTimeStr(start)+"~"+getOnlyTimeStr(end);
			}
			console.log("timeInfo >> ", timeInfo, ", allDay>>", allDay);
			bootbox.prompt(timeInfo+" 일정의 내용과 장소를 입력하세요.", function(title){
				if(title == null){
					return;
				}
				
				$.ajax({
					url: "doSchedule.jsp"
					,data: {
						action: "insert"
						, title: title
						, startTime: getTimeStr(start)
						, endTime: getTimeStr(end)
						, allDay: allDayStr
					}
					,type: "POST"
					,dataType: "json"
					,async: false
					,success: function(data){
						console.log(data);
						
						//입력에 성공했으면 달력에 그려준다.
						if(data.result){
							calendar.fullCalendar('renderEvent',
								{
									id: data.id,
									title: title +"-"+data.userName,
									start: start,
									end: end,
									allDay: allDay
								},
								true // make the event "stick"
							);
						}//if
					}//success function
					
				});
						
			});
			calendar.fullCalendar('unselect');
		},
		editable: false
		
	});
	
}

