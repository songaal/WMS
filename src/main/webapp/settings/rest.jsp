<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.RestDAO" %>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>
<%@ page import="co.fastcat.wms.bean.RestInfo2" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>

<%@include file="../inc/header.jsp"%>

<%
	RestDAO dao = new RestDAO();
	List<DAOBean> list = dao.selectAll();
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
						<li class=""><a href="auth.jsp"><i class="icon-chevron-right"></i>권한관리</a></li>
						<li class="active"><a href="rest.jsp"><i class="icon-chevron-right"></i>휴가관리</a></li>
						<li class=""><a href="approval.jsp"><i class="icon-chevron-right"></i>결재관리</a></li>
					</ul>
				</div>
				<!--// 좌측메뉴 -->
				
				<!-- 메인내용 -->
				<div class="span9">
					<h4>휴가관리</h4>
					
					<table class="table">
						<tr>
						<th>번호</th>
						<th>이름</th>
						<th>입사일</th>
						<th>근무기간</th>
						<th>휴가발급일수</th>
						<th>사용일수</th>
						<th>잔여일수</th>
						<th>&nbsp;</th>
						</tr>
						<%
						int inx=0;
						for(int i=0; i<list.size(); i++){
							RestInfo2 info = (RestInfo2) list.get(i);
							Calendar enterDay = Calendar.getInstance();
							if(info!=null && info.enterDate!=null) {
								enterDay.setTime(info.enterDate);
								
								float getAll = info.getYear + info.getSpecial;
								float spentAll = info.spentHalf + info.spentMonth + info.spentVacation + info.spentETC;
						%>
						<tr>
						<td><%=++inx %></td>
						<th><%=info.userName %></th>
						<td><%=WebUtil.toDateString(info.enterDate) %></td>
						<td><%=BusinessUtil.userYearMonth(enterDay) %></td>
						<td><%=getAll %>일</td>
						<td><%=spentAll %>일</td>
						<td><%=info.remain %>일</td>
						<td><button onClick="viewRestDetail('<%=info.userSID %>')" class="btn btn-small btn-info" type="button">관리</button>	</td>
						</tr>
						<%
							}
						}
						%>
						
					</table>
				</div>
			</div>

		</div>
	</div>
	<!-- row -->
</div>
<!-- container -->

<%@include file="../inc/footer.jsp"%>



