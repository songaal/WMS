<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="java.util.*"%>

<%@include file="../inc/header.jsp"%>

<!-- main banner
================================================== -->
<header class="jumbotron masthead">
	<div class="container">
		<h1>WebSquared</h1>
		<p class="lead">우리는 명품 검색엔진을 만든다.</p>
		<%=WebUtil.toDateString(new Date())%> <%=WebUtil.getYoilString(Calendar.getInstance()) %>
	</div>
</header>

<div class="container">

	<!-- Docs nav
    ================================================== -->
	<div class="row">
		<%
		if(!isLogin){
		%>
		<!-- 로그인폼 -->
		<div class="span12">
			<br><br>
			<div class="pagination-centered">
				<form class="form-inline" action="doLogin.jsp" method="post">
					<input type="hidden" name="action" value="login">
					<input type="hidden" name="redirectUrl" value="<%=WebUtil.getValue(request.getParameter("redirectUrl")) %>">
					<input type="text" name="userId" class="input-small" placeholder="아이디">
					<input type="password" name="passwd" class="input-small" placeholder="패스워드">
					<!-- 
					<label class="checkbox"> 
						<input type="checkbox"> 자동로그인
					</label>
					-->
					<button type="submit" class="btn">로그인</button>
				</form>
			</div>
		</div>
		<!--// 로그인폼 -->
		<%
		}else{
		%>
		
		<!-- 사용자폼 -->
		<div class="row-fluid">
			<div class="span3">
				<h4>내정보</h4>
				<table class="table table-condensed table-striped">
				<tr><th colspan="2"><%=myUserInfo.userName %> <%=myUserInfo.title %></th></tr>
				<%
				LiveDAO liveDAO = new LiveDAO();
				LiveInfo liveInfo = liveDAO.select(myUserInfo.serialId, new Date());
				String inTimeStr ="<button class='btn btn-primary btn-mini' onClick='doCheckIn()'>출근하기</button>";
				String outTimeStr = "-";
				String status = "";
				String autoCheckIn = "<script>$(function() { doCheckInConfirm(); });</script>";
                    String ipAddress = "";
				if(liveInfo != null){
					if(liveInfo.checkIn != null){
						inTimeStr = WebUtil.toTimeString(liveInfo.checkIn);
                        ipAddress = liveInfo.ipAddress;
						//출근상태일때에 퇴근버튼을 보여준다.
						if(liveInfo.checkOut != null){
							outTimeStr = WebUtil.toTimeString(liveInfo.checkOut);
						}else{
							outTimeStr = "<button class='btn btn-primary btn-mini' onClick='doCheckOut()'>퇴근하기</button>";
						}
					}else{
						//출근시간이 없으면 출근을 요청한다.
						//out.println(autoCheckIn);
					}
					status = BusinessUtil.getLiveStatusString(liveInfo.status);
				}else{
					//근무정보가 없으면 출근을 요청한다.
					out.println(autoCheckIn);
				}
				%>
				<tr><td>출근</td><td><%=inTimeStr %>(<%=ipAddress %>)</td></tr>
				<tr><td>퇴근</td><td><%=outTimeStr %></td></tr>
				<tr><td>상태</td><td><%=status %></td></tr>
                    <tr><td>IP</td><td><%=getClientIP(request)%></td></tr>
				</table>
			</div>
			<div class="span4">
			<!-- 
				<h4>나의최근진행업무</h4>
				<table class="table table-condensed table-striped">
				<tr><th>다나와 APL2 개발</th><td>관리자개선사항</td></tr>
				<tr><th>기무사 댓글수집시스템</th><td>웹수집기 설정변경</td></tr>
				<tr><th>대교협공정성 확보시스템</th><td>2차모집 버그수정</td></tr>
				</table>
			 -->
			</div>
			
			<div class="span2">
			<!-- 
				<h4>금일특이사항</h4>
				<table class="table table-condensed table-striped">
				<tr><td>유승호 과장 휴가</td></tr>
				</table>
			 -->
			</div>
			
			<div class="span2">
			<!-- 
				<h4>금일업무일정</h4>
				<table class="table table-condensed table-striped">
				<tr><td>10/29 14시</td><td>송상욱 대교협방문</td></tr>
				<tr><td>10/29 09시</td><td>강재호 우리은행방문</td></tr>
				</table>
				-->
			</div>
			<div class="span2">
			<!-- 
				<h4>예정사항</h4>
				<table class="table table-condensed table-striped">
				<tr><td>10/29</td><td>플립커뮤니케이션 교육</td></tr>
				<tr><td>10/30</td><td>13시 유승호 다나와방문</td></tr>
				<tr><td>11/03</td><td>BHS 검색교육</td></tr>
				</table>
			-->
			</div>
		</div>
		<!--// 사용자폼 -->
		<%
		}
		%>
	</div>

</div>

<%@include file="../inc/footer.jsp"%>



