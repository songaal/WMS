<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.UserDAO" %>

<%@include file="../inc/header.jsp"%>

<%
	UserDAO dao = new UserDAO();
	List<UserInfo> list = dao.select();
%>

<div class="container ">
	<div class="row">

		<div class="span12">
			<h2 id="body-copy">사용자영역</h2>
		</div>
			
		<!-- 좌측메뉴 -->
		<%@include file="leftMenu.jsp"%>
		<!--// 좌측메뉴 -->
		
		<!-- 메인내용 -->
		<div class="span4">
			<h4>패스워드설정</h4>
			<form id="userForm">
				<input type="hidden" name="action" value="updatePasswd" />
				<input type="password" name="oldPasswd" class="input-large required" placeholder="기존패스워드" />
				<br>
				<input type="password" name="newPasswd" class="input-large required" minlength="6" placeholder="새패스워드" />
				<br>
				<input type="password" name="newPasswd2" class="input-large required" minlength="6" placeholder="새패스워드 확인" />
				<br>
				<button type="button" class="btn btn-primary" onClick="updatePasswd()">수정</button>
				<button type="button" class="btn btn-danger" onClick="resetPasswd()">초기화</button>
			</form>
			
			
		</div>
		<div class="span4">
		
			<h4>알림기능설정</h4>
			<p>Chrome 브라우저에서는 데스크탑 알림기능을 사용할 수 있습니다.</p>
			<p>
			<a href="#" class="btn" onclick="window.webkitNotifications.requestPermission(); return false;">알림기능활성화</a>
			</p>
			
			
			
		</div>

	</div>
	<!-- row -->
</div>
<!-- container -->

<%@include file="../inc/footer.jsp"%>



