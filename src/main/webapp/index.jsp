<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="java.util.*"%>
<%@ page import="co.fastcat.wms.bean.LiveInfo" %>
<%@ page import="co.fastcat.wms.dao.LiveDAO" %>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>
<%@ page import="co.fastcat.wms.webpage.WebUtil" %>

<%@include file="../inc/header.jsp"%>

<div class="container">

	<!-- Docs nav
    ================================================== -->
	<div class="row">
		<%
		if(!isLogin){
		%>
		<!-- 로그인폼 -->
		<div class="span12">
			<br><br><br>
            <h3 style="text-align: center">패스트캣 WMS</h3>
            <br>
			<div class="pagination-centered">
				<form class="form-inline" action="doLogin.jsp" method="post">
					<input type="hidden" name="action" value="login">
					<input type="hidden" name="redirectUrl" value="<%=WebUtil.getValue(request.getParameter("redirectUrl")) %>">
					<input type="text" name="userId" class="input-small" placeholder="아이디">
					<input type="password" name="passwd" class="input-small" placeholder="패스워드">
					<button type="submit" class="btn">로그인</button>
				</form>
			</div>
		</div>
		<!--// 로그인폼 -->
		<%
		} else {

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
        }
		%>
	</div>

</div>

<%@include file="../inc/footer.jsp"%>