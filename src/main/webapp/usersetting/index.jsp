<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.LiveInfo" %>
<%@ page import="co.fastcat.wms.dao.LiveDAO" %>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>

<%@include file="../inc/header.jsp"%>

<%
	String yearStr = request.getParameter("year");
	String monthStr = request.getParameter("month");
	

	LiveDAO liveDAO = new LiveDAO();
	Calendar cal = Calendar.getInstance();
	int year = 0;
	int month = 0;
	if(yearStr == null){
		year = cal.get(Calendar.YEAR);
	}else{
		year = Integer.parseInt(yearStr);
		cal.set(Calendar.YEAR, year);
	}
	if(monthStr == null){
		month = cal.get(Calendar.MONTH) + 1;
	}else{
		month = Integer.parseInt(monthStr);
		cal.set(Calendar.MONTH, month - 1);
	}
	
	String yearMonth = WebUtil.toDateString(cal.getTime()).substring(0, 7);
	
	int startOfMonth = 1;
	int endOfMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
	
	List<LiveInfo> list = liveDAO.selectMonth(myUserInfo.serialId, new Date(cal.getTimeInMillis()));
	
	//달력에 입력할 수 있도록 <일자, 내용> 맵에 넣어둔다. 
	Map<Integer, LiveInfo> liveList = new HashMap<Integer, LiveInfo>();
	Calendar c = Calendar.getInstance();
	
	int[] stat = new int[8];
	
	for(int i=0; i<list.size(); i++){
		LiveInfo info = list.get(i);
		c.setTime(info.liveDate);
		int key = c.get(Calendar.DAY_OF_MONTH);
		liveList.put(key, info);
		
		stat[0]++;
		if(info.status.contains(LiveInfo.OK)){
	stat[1]++;
		}
		if(info.status.contains(LiveInfo.LATE)){
	stat[2]++;
		}
		if(info.status.contains(LiveInfo.HALF_REST)){
	stat[3]++;
		}
		if(info.status.contains(LiveInfo.REST)){
	stat[4]++;
		}
		if(info.status.contains(LiveInfo.NIGHT_WORK)){
	stat[5]++;
		}
		if(info.status.contains(LiveInfo.SPECIAL_WORK)){
	stat[6]++;
		}
		
	}
%>


<div class="container ">

	<div class="row">

		<div class="span12">
			<h2 id="body-copy">사용자영역</h2>
		</div>

		<!-- 좌측메뉴 -->
		<%@include file="leftMenu.jsp"%>
		<!--// 좌측메뉴 -->

		<%
			LiveInfo liveInfo = liveDAO.select(myUserInfo.serialId, new Date());
		%>
		<!-- 메인내용 -->
		<div class="span9">
			<h4>출퇴근부</h4>
			<p>
				<button	onClick="<%=(liveInfo == null || liveInfo.checkIn == null)?"doCheckIn()":"alreadyCheckIn()"%>" class="btn btn-info btn-small">출근입력</button>
				<button onClick="<%=(liveInfo != null && liveInfo.checkIn != null && liveInfo.checkOut == null)?"doCheckOut()":"alreadyCheckOut()"%>" class="btn btn-small">퇴근입력</button>
				<!-- <button onClick="doCheckOutterWork()" class="btn btn-warning btn-small">외근입력</button> -->
			</p>


			<div class="btn-group pagination-centered">
				<button class="btn btn-small active">개인</button>
				<a class="btn btn-small" href="liveAll.jsp">전체</a>
			</div>

			<form action="index.jsp" id="liveDateForm" method="post" class="hide">
				<input type="hidden" id="year" name="year" value="<%=year%>"> 
				<input type="hidden" id="month" name="month" value="<%=month%>">
			</form>

			<div class="input-append date" id="liveDatePicker"
				data-date="<%=yearMonth%>" data-date-format="yyyy.mm"
				data-date-viewmode="months" data-date-minviewmode="months">
				<input class="input-small" size="7" type="text"
					value="<%=yearMonth%>" readonly> <span class="add-on"><i
					class="icon-calendar"></i></span>
			</div>
			<p>
				<span class="label label-inverse">전체 <%=stat[0]%>
				</span> &nbsp;<%=BusinessUtil.getLiveStatusString(LiveInfo.OK, stat[1] + "")%>
				&nbsp;<%=BusinessUtil.getLiveStatusString(LiveInfo.LATE, stat[2] + "")%>
				&nbsp;<%=BusinessUtil.getLiveStatusString(LiveInfo.HALF_REST, stat[3] + "")%>
				&nbsp;<%=BusinessUtil.getLiveStatusString(LiveInfo.REST, stat[4] + "")%>
				&nbsp;<%=BusinessUtil.getLiveStatusString(LiveInfo.NIGHT_WORK, stat[5] + "")%>
				&nbsp;<%=BusinessUtil.getLiveStatusString(LiveInfo.SPECIAL_WORK, stat[6] + "")%>
				&nbsp;<%=BusinessUtil.getLiveStatusString(LiveInfo.OUTTER, stat[7] + "")%>
			</p>
			<table class="table table-bordered table-hover table-condensed">
				<tr>
					<th>날짜</th>
					<th>출근</th>
					<th>퇴근</th>
                    <th>아이피</th>
					<th>근무상태</th>
					<th>등록/수정시간</th>
					<th>사유</th>
				</tr>
				<%
					for (int i = startOfMonth; i <= endOfMonth; i++) {
						cal.set(Calendar.DAY_OF_MONTH, i);
						int yoilIdx = cal.get(Calendar.DAY_OF_WEEK);
						String yoil = WebUtil.getYoilString(cal);
						LiveInfo info = liveList.get(i);

						String classStr = "";
						String classStr2 = "";
						if (yoilIdx == 1) {
							classStr = "warning";
							classStr2 = "red_color";
						}
						if (yoilIdx == 7) {
							classStr = "warning";
							classStr2 = "blue_color";
						}

						String checkIn = "";
						String checkOut = "";
						String status = "";
						String regTime = "";
						String memo = "";
						String liveDateStr = "";
                        String ipAddress = "";
						if (info != null) {
							checkIn = WebUtil.toTimeString(info.checkIn);
							checkOut = WebUtil.toTimeString(info.checkOut);
							status = BusinessUtil.getLiveStatusString(info.status, true, null);
							regTime = WebUtil.toShortDateTimeString(info.regTime);
							memo = WebUtil.getValue(info.memo);
							liveDateStr = WebUtil.toDateString(info.liveDate);
                            ipAddress = info.ipAddress;
						}
				%>
				<tr class="<%=classStr%>">
					<td class="<%=classStr2%>"><%=i%> [<%=yoil%>]</td>
					<td><%=checkIn%></td>
					<td><%=checkOut%></td>
                    <td><%=ipAddress%></td>
					<td><%=status%><span class="live_date hide"><%=liveDateStr%></span></td>
					<td><%=regTime%></td>
					<td><%=memo%></td>
				</tr>
				<%
					}
				%>
			</table>
			<!--// 메인내용 -->


		</div>

	</div>
	<!-- row -->
</div>
<!-- container -->

<%@include file="../inc/footer.jsp"%>



