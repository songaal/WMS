<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.ProjectWork" %>
<%@ page import="co.fastcat.wms.dao.ProjectWorkDAO" %>

<%@include file="../inc/header.jsp"%>

<%
	String pid = request.getParameter("pid");
	String status = request.getParameter("status");
	
	ProjectWorkDAO dao = new ProjectWorkDAO();
	List<ProjectWork> list = dao.select(pid);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	String nowDate = sdf.format(new Date());	
%>

<div class="modal hide" id="insertModal" tabindex="-1" role="dialog"
	aria-labelledby="insertModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">×</button>
		<h3 id="insertModalLabel">작업내용추가</h3>
	</div>
	<div class="modal-body">
		<form id="projectForm" method="post" action="doWork.jsp">
			<input type="hidden" name="action" /> 
			<input type="hidden" name="pid" value="<%=pid%>" /> 
			<input type="hidden" name="wid" value="" />
			<input type="hidden" name="statusFilter" value="<%=status%>" /> 
			<input type="hidden" name="userId" value="<%=myUserInfo.serialId%>" /> 
			
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>

					<tr>
						<th>등록일</th>
						<td>
							<div name="reqDate" id="reqDate" class="input-append date required" data-date="" data-date-format="yyyy.mm.dd">
								<input class="input-small uneditable-input" size="10" name="regdate" type="text" value="<%=nowDate%>"> 
									<span class="add-on"><i	class="icon-calendar"></i></span>
							</div>
						</td>
					</tr>

					<tr>
						<th>작업내용</th>
						<td><textarea name="content" class="mid required"></textarea></td>
					</tr>					
					
					<tr>
						<th>이슈</th>
						<td><textarea name="issue" class="mid"></textarea></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onClick="insertProjectRequest()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 추가폼 -->

<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog"
	aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">작업내용 수정</h3>
	</div>
	<div id="work-content" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifyProjectWork()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-danger" onclick="deleteProjectWork()">삭제</button>
	</div>
</div>
<!--// 수정폼 -->

<div class="container ">
	<div class="row">
		<div class="span12">
			<h2 id="body-copy">프로젝트</h2>
		</div>
		<br>
		<!-- 왼쪽 프로젝트 리스트 -->
		<%@include file="incProjectLeft.jsp"%>

		<!-- 메인 내용 -->
		<div class="span9">
		<%@include file="incProjectSubmenu.jsp" %>
			<p>
				<button class="btn btn-info btn-small"
					onClick="viewInsertProjectWork()">작업내역추가</button>
			</p>

			<%
				if(list.size() == 0){
			%>
			<table class="table table-bordered table-condensed">
				<tr>
					<td>작업내역이 없습니다.</td>
				</tr>
			</table>
			<%
				}
			%>

			<%
				Date prevDate = null;
				for(int i=0; i<list.size(); i++){
					ProjectWork info = (ProjectWork) list.get(i);
				
					if(WebUtil.isPrevMonth(info.regdate, prevDate)){
			%>
			<p class="project"><%=WebUtil.toHangulYearMonthString(info.regdate)%></p>
			<br />
			<%
				}
					prevDate = info.regdate;
			%>
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="100">
					<col width="*">
				</colgroup>
				<tbody>
				<tr>					
					<tr>
						<th>일자</th>
						<td><%=WebUtil.toDateStringWithYoil(info.regdate)%></td>
					</tr>					
					<tr>
						<th>작업내용</th>
						<td><%=WebUtil.getMultiLineValue(info.content)%></td>
					</tr>					
					<tr>
						<th>이슈</th>
						<td><%=WebUtil.getMultiLineValue(info.issue)%></td>
					</tr>					
					<tr>
						<th>처리일자</th>
						<td><%=WebUtil.toDateString(info.doneDate)%></td>
					</tr>
					<tr class="warning">
						<th>진행상태</th>
						<td><%=info.getStatusString() %>
											
						</td>						
					</tr>
					<tr>
						<th>
						수정
						</th>
						<td>
						<button onClick="viewModifyWorkInfo('<%=info.wid%>')"
								class="btn btn-small" type="button">수정</button>
						<%
						if ( !"C".equals(WebUtil.getValue(info.status)) )
						{
						%>
						<button class="btn btn-info btn-small"	onClick="javascript:completeWork('<%=info.wid%>', '<%=info.pid%>')">작업종료</button>
						<%} %>									
						</td>
					</tr>
				</tbody>
			</table>
			<%
				}
			%>

		</div>

	</div>
</div>



<%@include file="../inc/footer.jsp"%>



