<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@include file="session.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta charset="utf-8">
<title>업무관리시스템 :: 웹스퀘어드</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="">
<meta name="author" content="">

<!-- Le styles -->
<link href="/WMS/assets/css/bootstrap.css" rel="stylesheet">
<link href="/WMS/assets/css/bootstrap-responsive.css" rel="stylesheet">
<link href="/WMS/assets/css/jquery-ui-1.9.1.custom.css" rel="stylesheet">
<link href="/WMS/assets/css/docs.css" rel="stylesheet">
<link href="/WMS/assets/css/wms.css" rel="stylesheet">
<link href="/WMS/assets/css/datepicker.css" rel="stylesheet">
<link href="/WMS/assets/css/datepicker3.css" rel="stylesheet">
<link href="/WMS/assets/fullcalendar/fullcalendar.css" rel="stylesheet">
<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

<!-- Le fav and touch icons -->
<link rel="shortcut icon" href="/WMS/assets/ico/favicon.ico">
<link rel="apple-touch-icon-precomposed" sizes="144x144"
	href="/WMS/assets/ico/apple-touch-icon-144-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="114x114"
	href="/WMS/assets/ico/apple-touch-icon-114-precomposed.png">
<link rel="apple-touch-icon-precomposed" sizes="72x72"
	href="/WMS/assets/ico/apple-touch-icon-72-precomposed.png">
<link rel="apple-touch-icon-precomposed"
	href="/WMS/assets/ico/apple-touch-icon-57-precomposed.png">

<script src="/WMS/assets/js/jquery-1.8.2.js"></script>
<script src="/WMS/assets/js/jquery.validate.min.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<script src="/WMS/assets/js/bootstrap.js"></script>
<script src="/WMS/assets/js/bootstrap-datepicker.js"></script>
<script src="/WMS/assets/js/bootstrap-datepicker-2.js"></script>
<script src="/WMS/assets/js/bootbox.js"></script>
<script src="/WMS/assets/js/notify.min.js"></script>
<script src="/WMS/assets/js/wms.js"></script>
<!-- <script src="http://cdn.ckeditor.com/4.4.1/full/ckeditor.js"></script> -->
<script src="/WMS/assets/ckeditor4/ckeditor.js"></script>


<%
	//out.println(myUrl);
	if(myUrlPath.equals(PAGE_ROOT)){
		%><script src="/WMS/assets/js/usersetting.js"></script><%
	}else if(myUrlPath.equals(PAGE_SALES)){
		%><script src="/WMS/assets/js/sales.js"></script><%
	}else if(myUrlPath.equals(PAGE_CLIENT)){
		%><script src="/WMS/assets/js/client.js"></script><%
	}else if(myUrlPath.equals(PAGE_SCHEDULE)){
		%><script src="/WMS/assets/fullcalendar/fullcalendar.js"></script>
		<script src="/WMS/assets/js/schedule.js"></script>
		<%
	}else if(myUrlPath.equals(PAGE_PROJECT)){
		%><script src="/WMS/assets/js/project.js"></script><%
	}else if(myUrlPath.equals(PAGE_APPROVAL)){
		%><script src="/WMS/assets/js/approval.js"></script><%
	}else if(myUrlPath.equals(PAGE_SETTINGS)){
		%><script src="/WMS/assets/js/settings.js"></script><%
	}else if(myUrlPath.equals(PAGE_MESSAGE)){
		%><script src="/WMS/assets/js/message.js"></script><%
	}else if(myUrlPath.equals(PAGE_USERSETTING)){
		%><script src="/WMS/assets/js/usersetting.js"></script><%
	}else if(myUrlPath.equals(PAGE_TODO)){
		%><script src="/WMS/assets/js/todo.js"></script><%
	}else if(myUrlPath.equals(PAGE_TASK)){
		%><script type="text/javascript" src="/WMS/assets/js/task.js"></script><%
				
	}
%>
</head>
<%
String url = (request.getRequestURL()).toString();
%>
<body data-spy="scroll" data-target=".bs-docs-sidebar">
	<!-- Navbar
    ================================================== -->
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
				<button type="button" class="btn btn-navbar" data-toggle="collapse"
					data-target=".nav-collapse">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<a class="brand " href="/WMS/">WMS</a>
				<div class="nav-collapse collapse">
					<ul class="nav">
						<li class="<%=(url.indexOf(PAGE_MY)>0) ? "active":"" %>"><a href="<%=PAGE_MY%>">MY</a></li>
						<% if(allowedList.contains(PAGE_SALES)){ %>
						<li class="<%=(url.indexOf(PAGE_SALES)>0) ? "active":"" %>"><a href="<%=PAGE_SALES%>">영업</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_CLIENT)){ %>
						<li class="<%=(url.indexOf(PAGE_CLIENT)>0) ? "active":"" %>"><a href="<%=PAGE_CLIENT%>">고객정보</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_PROJECT)){ %>
						<li class="<%=(url.indexOf(PAGE_PROJECT)>0) ? "active":"" %>"><a href="<%=PAGE_PROJECT%>">프로젝트</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_TASK)){ %>
						<li class="<%=(url.indexOf(PAGE_TASK)>0) ? "active":"" %>"><a href="<%=PAGE_TASK%>">업무</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_TODO)){ %>
						<li class="<%=(url.indexOf(PAGE_TODO)>0) ? "active":"" %>"><a href="<%=PAGE_TODO%>">TODO</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_SCHEDULE)){ %>
						<li class="<%=(url.indexOf(PAGE_SCHEDULE)>0) ? "active":"" %>"><a href="<%=PAGE_SCHEDULE%>">일정</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_MESSAGE)){ %>
						<li class="<%=(url.indexOf(PAGE_MESSAGE)>0) ? "active":"" %>"><a href="<%=PAGE_MESSAGE%>">업무연락</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_APPROVAL)){ %>
						<li class="<%=(url.indexOf(PAGE_APPROVAL)>0) ? "active":"" %>"><a href="<%=PAGE_APPROVAL%>">결재</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_USERSETTING)){ %>
						<li class="<%=(url.indexOf(PAGE_USERSETTING)>0) ? "active":"" %>"><a href="<%=PAGE_USERSETTING%>">사용자</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_SETTINGS)){ %>
						<li class="<%=(url.indexOf(PAGE_SETTINGS)>0) ? "active":"" %>"><a href="<%=PAGE_SETTINGS%>">관리설정</a></li>
						<% } %>
						<% if(allowedList.contains(PAGE_ATTACH)){ %>
						<li class="<%=(url.indexOf(PAGE_ATTACH)>0) ? "active":"" %>"><a href="<%=PAGE_ATTACH%>">파일관리</a></li>
						<% } %>
						
						<% if(isLogin){ %>
						<!-- <li><a href="javascript:toggleMemojang()"><i class="icon-pencil"></i>메모장</a></li> -->
						<li><a href="javascript:logout()"><i class="icon-off"></i>로그아웃</a></li>
						<% } %>
						
					</ul>
				</div>
			</div>
		</div>
		<!-- <div id="memojangDiv">
			<textarea name="memojangTextarea" id="memojangTextarea"></textarea>
		</div> -->
	</div>
	
	
