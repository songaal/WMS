<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.ApprovalSettingDAO" %>
<%@ page import="co.fastcat.wms.bean.ApprovalSetting" %>
<%@ page import="co.fastcat.wms.dao.UserDAO" %>
<%@ page import="co.fastcat.wms.bean.ApprovalInfo" %>

<%@include file="../inc/header.jsp"%>

<%
	String type = WebUtil.getValue(request.getParameter("type"), ApprovalInfo.TYPE_REST);
	UserDAO userDAO = new UserDAO();
	List<UserInfo> userList = userDAO.selectApproval();
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
						<li class=""><a href="rest.jsp"><i class="icon-chevron-right"></i>휴가관리</a></li>
						<li class="active"><a href="approval.jsp"><i class="icon-chevron-right"></i>결재관리</a></li>
					</ul>
				</div>
				<!--// 좌측메뉴 -->
				
				<!-- 메인내용 -->
				<div class="span9">
					<h4>결재관리</h4>
					
					<div class="btn-group pagination-centered">
						<button class="btn btn-small <%=type.equals(ApprovalInfo.TYPE_REST)?"active":""%>" onClick="selectApproval('<%=ApprovalInfo.TYPE_REST%>')">휴가</button>
						<button class="btn btn-small <%=type.equals(ApprovalInfo.TYPE_CHARGE)?"active":"" %>" onClick="selectApproval('<%=ApprovalInfo.TYPE_CHARGE %>')">비용청구</button>
						<button class="btn btn-small <%=type.equals(ApprovalInfo.TYPE_BOOK)?"active":"" %>" onClick="selectApproval('<%=ApprovalInfo.TYPE_BOOK %>')">도서구입</button>
						<button class="btn btn-small <%=type.equals(ApprovalInfo.TYPE_COMMON)?"active":"" %>" onClick="selectApproval('<%=ApprovalInfo.TYPE_COMMON %>')">일반결재</button>
					</div>
					<br/>
					<%
					ApprovalSettingDAO settingDAO = new ApprovalSettingDAO();
					ApprovalSetting setting = settingDAO.selectType(type);
					int resUserCount = 0;
					String resUser1 = null;
					String resUser2 = null;
					String resUser3 = null;
					if(setting != null) {
						resUserCount = setting.resUserCount;
						resUser1 = setting.resUser1;
						resUser2 = setting.resUser2;
						resUser3 = setting.resUser3;
					}
					%>
					<form id="restSetting" class="form-horizontal" action="doApproval.jsp" method="post" >
						<input type="hidden" name="action" value="update" />
						<input type="hidden" name="type" value="<%=type %>" />
						<div class="control-group">
							<label class="control-label" for="resUserCount">단계설정</label>
							<div class="controls">
								<select name="resUserCount">
									<option value="0">:: 선택 ::</option>
									<option value="1" <%=(resUserCount == 1)?"selected":"" %>>1단계</option>
									<option value="2" <%=(resUserCount == 2)?"selected":"" %>>2단계</option>
									<option value="3" <%=(resUserCount == 3)?"selected":"" %>>3단계</option>
								</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="resUser1">1단계 결재자</label>
							<div class="controls">
								<select name="resUser1">
								<option value="">:: 선택 ::</option>
								<%
								for(int i=0; i<userList.size(); i++){
									UserInfo userInfo = userList.get(i);
									String selected = "";
									if(userInfo.serialId.equals(resUser1)){
										selected = "selected";
									}
								%>
								<option value="<%=userInfo.serialId %>" <%=selected %> ><%=userInfo.userName %> <%=userInfo.title %></option>
								<%
								}
								%>
							</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="resUser2">2단계 결재자</label>
							<div class="controls">
								<select name="resUser2">
								<option value="">:: 선택 ::</option>
								<%
								for(int i=0; i<userList.size(); i++){
									UserInfo userInfo = userList.get(i);
									String selected = "";
									if(userInfo.serialId.equals(resUser2)){
										selected = "selected";
									}
								%>
								<option value="<%=userInfo.serialId %>" <%=selected %> ><%=userInfo.userName %> <%=userInfo.title %></option>
								<%
								}
								%>
							</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="resUser3">3단계 결재자</label>
							<div class="controls">
								<select name="resUser3">
								<option value="">:: 선택 ::</option>
								<%
								for(int i=0; i<userList.size(); i++){
									UserInfo userInfo = userList.get(i);
									String selected = "";
									if(userInfo.serialId.equals(resUser3)){
										selected = "selected";
									}
								%>
								<option value="<%=userInfo.serialId %>" <%=selected %> ><%=userInfo.userName %> <%=userInfo.title %></option>
								<%
								}
								%>
							</select>
							</div>
						</div>
						<div class="control-group">
							<div class="controls">
								<button type="submit" class="btn">저장</button>
							</div>
						</div>
					</form>
					
				</div>
			</div>

		</div>
	</div>
	<!-- row -->
</div>
<!-- container -->

<%@include file="../inc/footer.jsp"%>



