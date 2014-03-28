<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	UserDAO dao = new UserDAO();
	List<UserInfo> list = dao.select();
%>
<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog" aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">사용자수정</h3>
	</div>
	<div id="user-info" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifyUser()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-warning" onclick="alert('개발중')">암호초기화</button>
		<button class="btn btn-danger" onclick="deleteUser()">삭제</button>
	</div>
</div>
<!--// 수정폼 -->

<div class="container ">
	<div class="row">

		<div class="span12">
			<h2 id="body-copy">관리설정</h2>
		</div>
			
		<!-- 좌측메뉴 -->
		<div class="span3 bs-docs-sidebar">

			<ul class="nav nav-list bs-docs-sidenav">
				<li class="active"><a href="index.jsp"><i class="icon-chevron-right"></i>사용자관리</a></li>
				<li class=""><a href="checkInOut.jsp"><i class="icon-chevron-right"></i>출결관리</a></li>
				<li class=""><a href="report.jsp"><i class="icon-chevron-right"></i>보고관리</a></li>
				<li><a href="auth.jsp"><i class="icon-chevron-right"></i>권한관리</a></li>
				<li class=""><a href="rest.jsp"><i class="icon-chevron-right"></i>휴가관리</a></li>
				<li class=""><a href="approval.jsp"><i class="icon-chevron-right"></i>결재관리</a></li>
			</ul>
		</div>
		<!--// 좌측메뉴 -->
		
		<!-- 메인내용 -->
		<div class="span9">
			<h4>사용자관리</h4>
			<p>
				총 <span class="label label-info"><%=list.size() %></span>명
				<button onClick="viewInsertUserInfo()"
					class="btn btn-info btn-small pull-right">사용자추가</button>
			</p>
			<div class="alert hide" id="addUser">
				<form id="addUserForm" action="doUserSettings.jsp" method="post">
					<input type="hidden" name="action" value="create">
					<input type="hidden" name="userType" value="U">
					<input type="hidden" name="type" value="W">
					<div class="input-prepend">
						<span class="add-on">W</span>
						<input type="text" name="serialId" class="input-small required" placeholder="사번" minlength="3" maxlength="3">
					</div>
					<div>
					<input type="text" name="userName" class="input-small required" placeholder="이름">
					<input type="text" name="title" class="input-small required" placeholder="직함">
					<input type="text" name="part" class="input-small required" placeholder="부서">
					<input type="text" name="userId" class="input-small required" minlength="6" placeholder="아이디">
					<input type="text" name="enterDate" class="input-small required" placeholder="입사일"
						maxlength="10" id="enterDatePicker" data-date-format="yyyy.mm.dd">
					</div>
					<button type="submit" class="btn btn-primary">추가</button>
					<button type="button" class="btn" onClick="javascript:$('#addUser').hide()">닫기</button>
				</form>
			</div>
			
			<table class="table table-bordered">
				<tr>
				<th>번호</th>
				<th>사번</th>
				<th>이름</th>
				<th>직함</th>
				<th>부서</th>
				<th>아이디</th>
				<th>근무기간</th>
				<th>입사일</th>
				<th>&nbsp;</th>
				</tr>
			<%
				Calendar today = Calendar.getInstance();
				for(int i=0; i<list.size(); i++){
					UserInfo info = list.get(i);
			%>
				<tr>
				<td><%=i+1 %></td>
				<th><%=info.serialId %></th>
				<th><%=info.userName %></th>
				<td><%=info.title %></td>
				<td><%=info.part %></td>
				<td><%=info.userId %></td>
				<%
				Calendar enterDay = Calendar.getInstance();
				enterDay.setTime(info.enterDate);
				%>
				<td><%=BusinessUtil.userYearMonth(enterDay) %></td>
				<td><%=WebUtil.toDateString(info.enterDate)%></td>
				<td><button onClick="viewModifyUserInfo('<%=info.serialId%>')"
						class="btn btn-small" type="button">수정</button></td>
				</tr>
			<%
				}
			%>
			</table>
		</div>

	</div>
	<!-- row -->
</div>
<!-- container -->

<%@include file="../inc/footer.jsp"%>



