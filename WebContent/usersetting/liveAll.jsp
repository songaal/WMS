<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	String yearStr = request.getParameter("year");
	String monthStr = request.getParameter("month");
	String dayStr = request.getParameter("day");
	
	UserDAO userDAO = new UserDAO();
	List<UserInfo> userList = userDAO.select();
	
	
	LiveDAO liveDAO = new LiveDAO();
	Calendar cal = Calendar.getInstance();
	int year = 0;
	int month = 0;
	int day = 0;
	
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
	if(dayStr == null){
		day = cal.get(Calendar.DAY_OF_MONTH);
	}else{
		day = Integer.parseInt(dayStr);
		cal.set(Calendar.DAY_OF_MONTH, day);
	}
	
	String yearMonthDay = WebUtil.toDateString(cal.getTime());
	String yoil = WebUtil.getYoilString(cal);
%>


<div class="container ">	
		
	<form action="doCheckInOut.jsp" id="checkInOutForm" method="post" class="hidden">
		<input type="hidden" name="action">
	</form>
	
	<div class="row">

		<div class="span12">
			<h2 id="body-copy">사용자영역</h2>
		</div>
		
		<!-- 좌측메뉴 -->
		<%@include file="leftMenu.jsp"%>
		<!--// 좌측메뉴 -->
		
		<!-- 메인내용 -->
		<div class="span9">
			<h4>출퇴근부</h4>
			<form action="doCheckInOut.jsp" id="checkInOutForm" method="post" class="hidden">
				<input type="hidden" name="action">
			</form>
			
			<div class="btn-group pagination-centered">
				<a class="btn btn-small" href="index.jsp">개인</a>
				<button class="btn btn-small active">전체</button>
			</div>
			
			<form action="liveAll.jsp" id="liveDateForm" method="post" class="hide">
				<input type="hidden" name="year">
	  			<input type="hidden" name="month">
	  			<input type="hidden" name="day">
  			</form>
			
			<div class="input-append date" id="liveDateTimePicker" data-date="<%=yearMonthDay %>"  data-date-format="yyyy.mm.dd">
				<input class="input-small" size="10" type="text" value="<%=yearMonthDay %>" readonly>
				<span class="add-on"><i class="icon-calendar"></i></span>
			</div>
			
			<h4><%=yearMonthDay %> <%=yoil %></h4>
			<table class="table table-bordered table-hover table-condensed">
				<tr>
				<th>구분</th>
				<th>이름</th>
				<th>출근</th>
				<th>퇴근</th>
                    <th>아이피</th>
				<th>상태</th>
				<th>사유</th>
				</tr>
				<%
				for(int i=0; i < userList.size(); i++){
					UserInfo userInfo = userList.get(i);
					LiveInfo info = liveDAO.select(userInfo.serialId, new Date(cal.getTimeInMillis()));

					String checkIn = "";
					String checkOut = "";
					String status = "";
					String memo = "";
                    String ipAddress = "";
					
					if(info != null){
						checkIn = WebUtil.toTimeString(info.checkIn);
						checkOut = WebUtil.toTimeString(info.checkOut);
						status = BusinessUtil.getLiveStatusString(info.status);
						memo = WebUtil.getValue(info.memo);
                        ipAddress = info.ipAddress;
					}
				%>
				<tr>
				<td><%=i+1 %></td>
				<td><%=userInfo.userName %> <%=userInfo.title %></td>
				<td><%=checkIn %></td>
				<td><%=checkOut %></td>
                    <td><%=ipAddress %></td>
				<td><%=status %></td>
				<td><%=memo %></td>
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



