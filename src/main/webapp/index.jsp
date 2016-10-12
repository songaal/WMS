<%@ page contentType="text/html; charset=UTF-8"%>
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
            response.sendRedirect("/WMS/my");
        }
		%>
	</div>

</div>

<%@include file="../inc/footer.jsp"%>