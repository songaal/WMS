<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%

%>


<div class="container ">
	<div class="row">

		<div class="span12">
			<h2 id="body-copy">관리설정</h2>

			<div class="row-fluid">
			
				<!-- 좌측메뉴 -->
				<div class="span3 bs-docs-sidebar">

					<ul class="nav nav-list bs-docs-sidenav">
						<li><a href="index.jsp"><i class="icon-chevron-right"></i>사용자관리</a></li>
						<li class=""><a href="checkInOut.jsp"><i class="icon-chevron-right"></i>출결관리</a></li>
						<li class=""><a href="report.jsp"><i class="icon-chevron-right"></i>보고관리</a></li>
						<li class="active"><a href="auth.jsp"><i class="icon-chevron-right"></i>권한관리</a></li>
						<li class=""><a href="rest.jsp"><i class="icon-chevron-right"></i>휴가관리</a></li>
						<li class=""><a href="approval.jsp"><i class="icon-chevron-right"></i>결재관리</a></li>
					</ul>
				</div>
				<!--// 좌측메뉴 -->
				
				<!-- 메인내용 -->
				<div class="span9">
					<h4>권한관리</h4>
					
					<!-- <table class="table">
						<tr>
						<th>번호</th>
						<th>이름</th>
						<th>아이디</th>
						<th>권한</th>
						<th>&nbsp;</th>
						</tr>
						
						<tr>
						<td>1</td>
						<th>송상욱</th>
						<td>swsong</td>
						<td>
							<i class="icon-ok"></i>로드맵 
							<i class="icon-ok"></i>영업
							<i class="icon-ok"></i>자금
							<i class="icon-ok"></i>프로젝트
							<i class="icon-ok"></i>업무
							<i class="icon-ok"></i>근태
							<i class="icon-ok"></i>휴가
							<i class="icon-ok"></i>사내규정
							<i class="icon-ok"></i>관리설정
						</td>
						<td><button onClick="viewModifyUserInfo('')"
								class="btn btn-small" type="button">수정</button></td>
						</tr>
						
						<tr>
						<td>2</td>
						<th>유승호</th>
						<td>shyoo</td>
						<td>
							<span class="muted text-cancel"><i class="icon-remove"></i>로드맵</span> 
							<i class="icon-ok"></i>영업
							<span class="muted text-cancel"><i class="icon-remove"></i>자금</span>
							<i class="icon-ok"></i>프로젝트
							<i class="icon-ok"></i>업무
							<i class="icon-ok"></i>근태
							<i class="icon-ok"></i>휴가
							<i class="icon-ok"></i>사내규정
							<span class="muted text-cancel"><i class="icon-remove"></i>관리설정	</span>					
						</td>
						<td><button onClick="viewModifyUserInfo('')"
								class="btn btn-small" type="button">수정</button></td>
						</tr>
						
						<tr>
						<td>2</td>
						<th>강재호</th>
						<td>jhkang</td>
						<td>
							<i class="icon-ok"></i>로드맵 
							<i class="icon-remove"></i>영업
							<i class="icon-remove"></i>자금
							<i class="icon-ok"></i>프로젝트
							<i class="icon-ok"></i>업무
							<i class="icon-ok"></i>근태
							<i class="icon-ok"></i>휴가
							<i class="icon-ok"></i>사내규정
							<i class="icon-remove"></i>관리설정						
						</td>
						<td><button onClick="viewModifyUserInfo('')"
								class="btn btn-small" type="button">수정</button></td>
						</tr>
						
					</table> -->
				</div>
			</div>

		</div>
	</div>
	<!-- row -->
</div>
<!-- container -->

<%@include file="../inc/footer.jsp"%>



