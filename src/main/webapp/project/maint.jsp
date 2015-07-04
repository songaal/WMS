<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.ProjectMaintain2" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>
<%@ page import="co.fastcat.wms.dao.ProjectMaintainDAO" %>

<%@include file="../inc/header.jsp"%>

<%
	String pid = request.getParameter("pid");
	String status = request.getParameter("status");
	
	ProjectMaintainDAO dao = new ProjectMaintainDAO();
	List<DAOBean> list = dao.selectProject(pid);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	String strNowDate = sdf.format(new Date());
%>

<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog"
	aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">회의 내용 수정</h3>
	</div>
	<div id="maint-content" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifyProjectMaintain()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-danger" onclick="deleteProjectMaintain()">삭제</button>
	</div>
</div>
<!--// 수정폼 -->

<!-- 추가폼 -->
<div class="modal hide" id="insertModal" tabindex="-1" role="dialog"
	aria-labelledby="insertModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="insertModalLabel">점검일정</h3>
	</div>
	<div class="modal-body">
		<form id="projectForm" method="post" action="doMaintain.jsp">
			<input type="hidden" name="action" />
			<input type="hidden" name="pid" value="<%=pid %>" />
			<input type="hidden" name="statusFilter" value="<%=status %>" />
			<input type="hidden" name="userId" value="<%=myUserInfo.serialId %>" />
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					
					<tr>
						<th>점검일자</th>
						<td>
						<div class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input required" size="10" name="maintainDate" type="text" value="<%=strNowDate%>">
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
						</td>
					</tr>
					<tr>
						<th>완료일자</th>
						<td>
						<div class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="doneDate" type="text">
							<span class="add-on"><i class="icon-calendar"></i></span>
						</div>
						</td>
					</tr>
					<tr>
						<th>점검내용</th>
						<td><textarea name="maintainList" class="mid required"></textarea></td>
					</tr>
					<tr>
						<th>처리내용</th>
						<td><textarea name="result" class="mid"></textarea></td>
					</tr>
					<tr>
						<th>코멘트</th>
						<td><textarea name="comment" class="mid"></textarea></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onClick="insertProjectMaintain()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 추가폼 -->

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
			<button class="btn btn-info btn-small" onClick="viewInsertProjectMaintain()">정기점검추가</button>
			</p>
			
			<%
			if(list.size() == 0){
			%>
			<table class="table table-bordered table-condensed">
			<tr><td>정기점검 내역이 없습니다.</td></tr>
			</table>
			<%				
			}
			%>
			
			<%
			Date prevDate = null;
			for(int i=0; i<list.size(); i++){
				ProjectMaintain2 info = (ProjectMaintain2) list.get(i);
			
				if(WebUtil.isPrevMonth(info.maintainDate, prevDate)){
				%>
					<p class="project"><%=WebUtil.toHangulYearMonthString(info.maintainDate) %></p><br/>
				<%
				}
				prevDate = info.maintainDate;
			%>
			<table class="table table-bordered table-hover table-condensed">
				<colgroup>
					<col width="100">
					<col width="*">
				</colgroup>
				<tbody>
					<tr>
					<th>업무번호</th>
					<td><a name="<%=WebUtil.getValue(info.mid) %>">#<%=WebUtil.getValue(info.mid) %></a></td>
					</tr>
					<tr>
					<th>점검일자</th>
					<td><%=WebUtil.toDateStringWithYoil(info.maintainDate) %></td>
					</tr>
					<tr>
					<th>완료일자</th>
					<td><%=WebUtil.toDateStringWithYoil(info.doneDate) %></td>
					</tr>
					<tr>
					<th>점검자</th>
					<td><%=info.userName %></td>
					</tr>
					<tr>
					<th>점검내용</th>
					<td><%=WebUtil.getMultiLineValue(info.maintainList) %></td>
					</tr>
					<tr>
					<th>처리내용</th>
					<td><%=WebUtil.getMultiLineValue(info.result) %></td>
					</tr>
					<tr>
					<th>코멘트</th>
					<td><%=WebUtil.getMultiLineValue(info.comment) %></td>
					</tr>
					<tr>
					<th>수정</th>
					<td>
					<button class="btn btn-info btn-small"
					onClick="javascript:viewModifyMaintInfo('<%=info.mid%>')">
						점기점검 수정 		
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



