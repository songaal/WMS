<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	RestDataDAO historyDAO = new RestDataDAO();
	List<RestData> issueList = historyDAO.selectIssue(myUserInfo.serialId);
	List<RestData> spentList = historyDAO.selectSpent(myUserInfo.serialId);
	
/* 	UserDAO userDAO = new UserDAO();
	UserInfo userInfo = userDAO.select(myUserInfo.serialId); */
%>

<!-- 휴가사용 추가폼 -->
<div id="spendModal" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="spendModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="spendModalLabel">휴가사용 결재요청</h3>
	</div>
	<div class="modal-body">
		<form id="restForm">
			<input type="hidden" name="action" />
			<input type="hidden" name="type" value="<%=RestData.TYPE_SPEND%>"/>
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					<tr>
						<th>휴가종류</th>
						<td>
							<select name="category">
								<option value="<%=RestData.CATEGORY_SPEND_MONTH%>">월차</option>
								<option value="<%=RestData.CATEGORY_SPEND_VACATION%>">휴가</option>
								<option value="<%=RestData.CATEGORY_SPEND_HALF%>">반차</option>
								<option value="<%=RestData.CATEGORY_SPEND_ETC%>">기타</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>기간</th>
						<td>
						<div class="input-append">
							<input type="text" name="amount" class="input-small required" placeholder="0.0" maxlength="3">
							<span class="add-on">일</span>
						</div>
					</tr>
					<tr>
						<th>시작일</th>
						<td>
						<div class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="applyDate" type="text">
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
						</td>
					</tr>
					<tr>
						<th>내용</th>
						<td><input name=memo class="input-xlarge" /></td>
					</tr>
					
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="requestRestApproval()">결재요청</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 추가폼 -->

<div class="container ">
	<div class="row">
		<div class="span12">
			<h2 id="body-copy">사용자영역</h2>
		</div>
		
		<!-- 좌측메뉴 -->
		<%@include file="leftMenu.jsp"%>
		<!--// 좌측메뉴 -->
		
		<!-- 메인내용 -->
		<div class="span9">
			<h4 id="body-copy">휴가</h4>
			<p>휴가정보</p>
			<div class="btn-group pagination-centered">
				<button class="btn btn-small active">정보</button>
				<a class="btn btn-small" href="restHistory.jsp">히스토리</a>
			</div>
			<p><%=myUserInfo.part %> <strong><%=myUserInfo.userName %></strong> <%=myUserInfo.title %></p>
			
			<table class="table table-bordered table-hover table-condensed">
				<tr>
				<th rowspan="2">잔여</th>
				<th colspan="2">발급</th>
				<th colspan="4">사용</th>
				</tr>
				
				<tr>
				<th>연차</th>
				<th>특별휴가</th>
				<th>반차</th>
				<th>월차</th>
				<th>휴가</th>
				<th>기타</th>
				</tr>
				
				<%
				RestDAO dao = new RestDAO();
				float getAll = 0f;
				float spentAll = 0f;
				
				RestInfo info = dao.select(myUserInfo.serialId);
				if(info != null) {
					getAll = info.getYear + info.getSpecial;
					spentAll = info.spentHalf + info.spentMonth + info.spentVacation + info.spentETC;
				%>
				<tr>
					<td rowspan="2"><%=info.remain %>일</td>
					<td><%=info.getYear %>일</td>
					<td><%=info.getSpecial %>일</td>
					<td><%=info.spentHalf %>일</td>
					<td><%=info.spentMonth %>일</td>
					<td><%=info.spentVacation %>일</td>
					<td><%=info.spentETC %>일</td>
				</tr>
				<tr>
					<td colspan="2"><%=getAll %>일</td>
					<td colspan="4"><%=spentAll %>일</td>
				</tr>
				<%
				}else{
				%>
					<tr><td colspan="7">휴가정보가 없습니다.</td></tr>
				<%
				}
				%>
			</table>
			
			<a href="#spendModal" role="button" class="btn btn-small btn-primary" data-toggle="modal">휴가사용결재요청</a>
		</div>
	</div>

</div>

<%@include file="../inc/footer.jsp"%>



