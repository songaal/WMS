<%@ page contentType="text/html; charset=UTF-8"%>

<div class="span3 bs-docs-sidebar">
	<ul class="nav nav-list bs-docs-sidenav">
		<li class="<%=(thisPageName.equals("index.jsp") || thisPageName.equals("liveAll.jsp"))?"active":""%>"><a href="index.jsp"><i class="icon-chevron-right"></i>출퇴근부</a></li>
		<%-- <li class="<%=thisPageName.equals("book.jsp")?"active":""%>"><a href="book.jsp"><i class="icon-chevron-right"></i>도서구입</a></li>
		<li class="<%=thisPageName.equals("charge.jsp")?"active":""%>"><a href="charge.jsp"><i class="icon-chevron-right"></i>비용청구</a></li> --%>
		<li class="<%=thisPageName.equals("rest.jsp")||thisPageName.equals("restHistory.jsp")?"active":""%>"><a href="rest.jsp"><i class="icon-chevron-right"></i>휴가</a></li>
		<li class="<%=thisPageName.equals("password.jsp")?"active":""%>"><a href="password.jsp"><i class="icon-chevron-right"></i>설정</a></li>
	</ul>
</div>


