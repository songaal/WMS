<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="java.util.*"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="co.fastcat.wms.bean.LiveInfo" %>
<%@ page import="co.fastcat.wms.dao.LiveDAO" %>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>
<%@include file="../inc/session.jsp"%>
<head>
<link href="/WMS/assets/css/bootstrap.css" rel="stylesheet">
<script src="/WMS/assets/js/jquery-1.8.2.js"></script>
<script src="/WMS/assets/js/bootstrap.js"></script>
<script src="/WMS/assets/js/bootbox.js"></script>
</head>
<body>
<%
	String action = request.getParameter("action");
    String ipAddress = getClientIP(request);
	
	if("checkIn".equals(action) || "checkInOutter".equals(action) ){
		boolean isOutter = "checkInOutter".equals(action); //외근여부.
		
		LiveDAO liveDAO = new LiveDAO();
		
		//토, 일 요일에 출근하면 주말근무이다.
		String yoil = WebUtil.getShortYoilString(Calendar.getInstance());
		boolean isHolidayWork = (yoil.equals("토") || ydoCheckInOutoil.equals("일"));
		boolean isYesterdayWorkLate = false;

		if(!isHolidayWork){
			//평일근무이면 지각/전날야근등을 체크한다.
			Calendar yesterdayCal = Calendar.getInstance();
			yesterdayCal.add(Calendar.DATE, -1);
			LiveInfo yesterdayLiveInfo = liveDAO.select(myUserInfo.serialId, yesterdayCal.getTime());
			
			logger.debug("yesterdayLiveInfo >> {}", yesterdayLiveInfo);
			if(yesterdayLiveInfo != null && yesterdayLiveInfo.status != null){
				isYesterdayWorkLate = yesterdayLiveInfo.status.contains(LiveInfo.NIGHT_WORK);
			}
		}
		
		Date todayDate = new Date();
		long now = todayDate.getTime();
		LiveInfo liveInfo = liveDAO.select(myUserInfo.serialId, todayDate);
		
		boolean isUpdate = false; //휴가등으로 근무상태를 미리 기록해놓은경우.
		
		if(liveInfo != null){
			if(liveInfo.checkIn == null){
				//출근시간이 없다면 현시간으로 수정.
				liveInfo.regTime = new Timestamp(now);
				liveInfo.checkIn = liveInfo.regTime;
                liveInfo.ipAddress = ipAddress;
				isUpdate = true;
			}else{
				//출근시간이 있으면 스킵.
				//근무기록이 있다면(휴가결재완료등..) 출근을 기록하지 않는다.		
				response.sendRedirect(pageFrom);
				return;
			}
		}else{
			liveInfo = new LiveInfo();
			//로그인된 세션 myUserInfo 정보를 이용한다.
			liveInfo.serialId = myUserInfo.serialId;
			liveInfo.liveDate = new java.sql.Date(now);
			liveInfo.regTime = new Timestamp(now);
			liveInfo.checkIn = liveInfo.regTime;
			//liveInfo.checkOut
			liveInfo.status = BusinessUtil.getCheckInStatusString(now);
            liveInfo.ipAddress = ipAddress;

			if(isHolidayWork){
				liveInfo.status = LiveInfo.SPECIAL_WORK;
			}else if(liveInfo.status.contains(LiveInfo.LATE) && isYesterdayWorkLate){
				//지각이지만, 어제 늦게까지 일했으면 지각면제.
				if(BusinessUtil.isCompromisableLate(now)){
					//너무늦은시간이 아니면, 지각면제이나 Compromisable time을 지나면 여전히 지각표시.
					liveInfo.status = LiveInfo.OK;
					liveInfo.memo="[전일야근]";
				}else{
					//너무 늦었으면, 야근으로인한 제외를 적용하지 않는다.
					isYesterdayWorkLate = false;
				}
			}
			if(isOutter){
				liveInfo.status += LiveInfo.OUTTER;
			}
		}
		
		
		String checkInMessage = "";
		
		if(isUpdate){
			liveDAO.modify(liveInfo);
			checkInMessage = "오늘도 힘내서 화이팅입니다^^";
		}else{
			liveDAO.create(liveInfo);
			
			String status = BusinessUtil.getCheckInStatusString(now);
			if(isHolidayWork){
				checkInMessage = "주말에도 일하느라 수고가 많습니다.";
			}else if(status.contains(LiveInfo.LATE)){
				checkInMessage = "아침에 조금더 부지런하게~^^";
			}else if(status.contains(LiveInfo.OUTTER)){
				checkInMessage = "외부에서 일하느라 수고가 많습니다.";
			}else{
				checkInMessage = "오늘도 힘내서 화이팅입니다^^";
			}
		}
		%>
		<script>
		bootbox.alert("<%=checkInMessage%>", function(){
            pageFrom = "/WMS/my";
			window.location = "<%=pageFrom%>";
		});
		</script>
		<%
	}else if("checkOut".equals(action)){
		//퇴근
		
		LiveDAO liveDAO = new LiveDAO();
		LiveInfo liveInfo = liveDAO.select(myUserInfo.serialId, new Date());
		String checkOutMessage = null;
		if(liveInfo != null){
			checkOutMessage = "오늘도 하루도 수고하셨습니다.";
			long now = System.currentTimeMillis();
			//로그인된 세션 myUserInfo 정보를 이용한다.
			liveInfo.checkOut = new Timestamp(now);
			if(BusinessUtil.isWorkLate()){
				liveInfo.status += LiveInfo.NIGHT_WORK;
				checkOutMessage = "늦은 시간까지 수고하셨습니다.";
			}
			liveDAO.modify(liveInfo);
		}else{
			checkOutMessage = "금일 출근정보가 없어서 퇴근하지 못했습니다.";
		}
		%>
		<script>
		bootbox.alert("<%=checkOutMessage%>", function(){
			window.location = "<%=pageFrom%>";
		});
		</script>
		<%
		
	}else if("execuseLate".equals(action)){
		//지각 아님으로 수정.
		String liveDate = request.getParameter("liveDate");
		String memo = request.getParameter("memo");
		String year = request.getParameter("year");
		String month = request.getParameter("month");
		long time = WebUtil.parseDate(liveDate).getTime();
		
		LiveDAO liveDAO = new LiveDAO();
		LiveInfo liveInfo = liveDAO.select(myUserInfo.serialId, new Date(time));
		
		if(liveInfo != null){
			//기존 출근시각은 남겨둔다.
			liveInfo.regTime = new Timestamp(System.currentTimeMillis()); //등록시간 현재시각으로.
			liveInfo.status = liveInfo.status.replaceAll(LiveInfo.LATE, LiveInfo.OK); //지각 상태 없애기.
			liveInfo.memo = memo;
			liveDAO.modify(liveInfo);
		}
		
		response.sendRedirect("index.jsp?year="+year+"&month="+month);
	}
	
%>
</body>


