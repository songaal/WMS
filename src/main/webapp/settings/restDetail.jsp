<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.RestDataDAO" %>
<%@ page import="co.fastcat.wms.dao.RestDAO" %>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>
<%@ page import="co.fastcat.wms.dao.UserDAO" %>
<%@ page import="co.fastcat.wms.bean.RestData" %>
<%@ page import="co.fastcat.wms.bean.RestInfo" %>

<%@include file="../inc/header.jsp"%>

<%
	String userSID = WebUtil.getValue(request.getParameter("userSID"));

	if(userSID == null || userSID.length() == 0){
		gotoMain(response);
		return;
	}
	
	RestDataDAO historyDAO = new RestDataDAO();
	List<RestData> issueList = historyDAO.selectIssue(userSID);
	List<RestData> spentList = historyDAO.selectSpent(userSID);
	
	UserDAO userDAO = new UserDAO();
	UserInfo userInfo = userDAO.select(userSID);
%>

<!-- 휴가발급 추가폼 -->
<div id="issueModal" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="issueModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="issueModalLabel">휴가발급 결재요청</h3>
	</div>
	<div class="modal-body">
		<form id="restIssueForm">
			<input type="hidden" name="action" />
			<input type="hidden" name="userSID" value="<%=userInfo.serialId%>"/>
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					<tr>
						<th>대상자</th>
						<td><%=userInfo.userName %> <%=userInfo.title %></td>
					</tr>
					<tr>
						<th>휴가종류</th>
						<td>
							<select name="category">
								<option value="<%=RestData.CATEGORY_ISSUE_YEAR%>">연차</option>
								<option value="<%=RestData.CATEGORY_ISSUE_SPECIAL%>">특별휴가</option>
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
						<th>발급일</th>
						<td>
						<div class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="applyDate" type="text">
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
						</td>
					</tr>
					<tr>
						<th>발급내용</th>
						<td><input name=memo class="input-xlarge" /></td>
					</tr>
					
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="issueRestApproval()">결재요청</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 추가폼 -->

<!-- 휴가사용 추가폼 -->
<div id="spendModal" class="modal hide" tabindex="-1" role="dialog" aria-labelledby="spendModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="spendModalLabel">휴가사용 결재요청</h3>
	</div>
	<div class="modal-body">
		<form id="restSpendForm">
			<input type="hidden" name="action" />
			<input type="hidden" name="userSID" value="<%=userInfo.serialId%>"/>
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					<tr>
						<th>대상자</th>
						<td><%=userInfo.userName %> <%=userInfo.title %></td>
					</tr>
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
						<th>사유</th>
						<td><input name=memo class="input-xlarge" /></td>
					</tr>
					
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="spendRestApproval()">결재요청</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 추가폼 -->


<div class="container ">
	<div class="row">
		<div class="span12">
			<h2 id="body-copy">관리설정</h2>
		</div>
		<!-- 좌측메뉴 -->
		<div class="span3 bs-docs-sidebar">
			<ul class="nav nav-list bs-docs-sidenav">
				<li><a href="index.jsp"><i class="icon-chevron-right"></i>사용자관리</a></li>
				<li><a href="auth.jsp"><i class="icon-chevron-right"></i>권한관리</a></li>
				<li class="active"><a href="rest.jsp"><i class="icon-chevron-right"></i>휴가관리</a></li>
				<li class=""><a href="approval.jsp"><i class="icon-chevron-right"></i>결재관리</a></li>
			</ul>
		</div>
		<!--// 좌측메뉴 -->
		
		<!-- 메인내용 -->
		<div class="span9">
			<h4 id="body-copy">휴가상세</h4>
			<p><a href="rest.jsp"><i class="icon-circle-arrow-left"></i> 리스트로</a></p>
			<p><%=userInfo.part%> <strong><%=userInfo.userName%></strong> <%=userInfo.title%></p>
			
			<p>
			<a href="#issueModal" role="button" class="btn btn-small btn-primary" data-toggle="modal">발급</a>
			<a href="#spendModal" role="button" class="btn btn-small btn-warning" data-toggle="modal">사용</a>
			</p>
			
			<div class="row">
			
			
			<div class="span9">
				<h4>휴가정보통계</h4>
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
					
					RestInfo info = dao.select(userInfo.serialId);
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
			
			
			</div>
			<div class="span9">
				<h4>발급내역</h4>
				<table class="table table-bordered table-hover table-condensed">
					<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>휴가종류</th>
					<th>일수</th>
					<th>내용</th>
					</tr>
					<%
						float total = 0.0f;
						for(int i=0; i<issueList.size(); i++){
							RestData history = issueList.get(i);
							total += history.amount;
						}
					%>
					<tr class="info">
					<td colspan="3"><strong>총계</strong></td>
					<td><%=total%></td>
					<td></td>
					</tr>
					<%
						for(int i=0; i<issueList.size(); i++){
							RestData history = issueList.get(i);
					%>
					<tr>
					<td><%=issueList.size() - i%></td>
					<td><%=WebUtil.toDateString(history.applyDate)%></td>
					<td><%=BusinessUtil.getRestCategoryName(history.category) %></td>
					<td><%=history.amount%></td>
					<td><%=WebUtil.getValue(history.memo) %></td>
					</tr>
					<%
						}
					%>
					
				</table>
			</div>
			
			<div class="span9">
				<h4>사용내역</h4>
				<table class="table table-bordered table-hover table-condensed">
					<tr>
					<th>번호</th>
					<th>날짜</th>
					<th>휴가종류</th>
					<th>일수</th>
					<th>내용</th>
					<%
					total = 0.0f;
					for(int i=0; i<spentList.size(); i++){
						RestData history = spentList.get(i);
						total += history.amount;
					}
					%>
					<tr class="info">
					<td colspan="3"><strong>총계</strong></td>
					<td><%=total%></td>
					<td></td>
					</tr>
					<%
					for(int i=0; i<spentList.size(); i++){
						RestData history = spentList.get(i);
					%>
					<tr>
					<td><%=spentList.size() - i %></td>
					<td><%=WebUtil.toDateString(history.applyDate) %></td>
					<td><%=BusinessUtil.getRestCategoryName(history.category) %></td>
					<td><%=history.amount %></td>
					<td><%=WebUtil.getValue(history.memo) %></td>
					</tr>
					<%
					}
					%>
				</table>
				
			</div>
			</div>
		</div>
	</div>

</div>

<%@include file="../inc/footer.jsp"%>



