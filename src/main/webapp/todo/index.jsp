<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.ProjectWorkDAO" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>
<%@ page import="co.fastcat.wms.bean.ProjectWork2" %>

<%@include file="../inc/header.jsp"%>

<%
	ProjectWorkDAO todoDAO = new ProjectWorkDAO();
	request.setCharacterEncoding("utf-8");
	
	int workId = WebUtil.getIntValue(request.getParameter("wid"));
	
	String type = WebUtil.getValue(request.getParameter("type"), "A");
	List<DAOBean> list = null;
	if(type.equals("Z")){
		//전체리스트
		list = todoDAO.select2();
	}else{
		list = todoDAO.selectType(type);
	}
	
	int showColumnCount = 10;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	String nowDate = sdf.format(new Date());	
	
%>


<div class="modal hide" id="insertModal" tabindex="-1" role="dialog" aria-labelledby="insertModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="insertModalLabel">작업내용추가</h3>
	</div>
	<div class="modal-body">
		<form id="projectForm" method="post" action="doTodo.jsp">
			<input type="hidden" name="action" /> 
			<input type="hidden" name="pid" value="" /> 
			<input type="hidden" name="wid" value="" />
			<input type="hidden" name="statusFilter" value="<%=type%>" /> 
			<input type="hidden" name="userId" value="<%=myUserInfo.serialId%>" /> 
			<input type="hidden" name="status" value="A" />
			
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>

					<tr>
						<th>등록일</th>
						<td>
							<div name="reqDate" id="reqDate" class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
								<input class="input-small uneditable-input required" size="10" name="regdate" type="text" value="<%=nowDate%>"> 
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
		<button class="btn btn-primary" onClick="insertProjectWork()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
	</div>
</div>
<!--// 추가폼 -->

<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog" aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
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
			<h2 id="body-copy">TODO</h2>
		</div>
		
		<!-- 좌측메뉴 -->
		<div class="span3 bs-docs-sidebar">
			<ul class="nav nav-list bs-docs-sidenav">
				<li class="active"><a href="index.jsp"><i class="icon-chevron-right"></i>TODO 관리 </a></li>
			</ul>
		</div>
		<!--// 좌측메뉴 -->
	
		<!-- 메인내용 -->
		<div class="span9">
			<h4>TODO관리</h4>
			<div class="btn-group pagination-centered">
				<button class="btn btn-small <%="A".equals(type)?"active":"" %>" onClick="viewTodoList('A')">등록</button>
				<button class="btn btn-small <%="B".equals(type)?"active":"" %>" onClick="viewTodoList('B')">진행중</button>
				<button class="btn btn-small <%="C".equals(type)?"active":"" %>" onClick="viewTodoList('C')">완료</button>			
				<button class="btn btn-small <%="Z".equals(type)?"active":"" %>" onClick="viewTodoList('Z')">전체</button>
			</div>
			<p>	총 <span class="label label-info"><%=list.size()%></span>건
				<button onClick="javascript:viewInsertProjectWork()"
					class="btn btn-info btn-small pull-right">TODO추가</button>
			</p>
			<table class="table table-bordered table-hover table-condensed">
				<colgroup>
					<col width="50" />
					<col width="80" />
					<%if ( "Z".equals(type) ) { %>
						<col width="50" />
					<% } %>
					<col width="500" />					
					<col width="100" />
					
				</colgroup>
			
				<thead>
					<tr>
						<th>순번</th>
						<th>일자</th>
						<%if ( "Z".equals(type) ) { %>
							<th>상태</th>						
						<% } %>
						<th>내용</th>						
						<th>변경</th>
					</tr>
				</thead>
				<tbody>
				<% if (list.size() == 0) { %>
				<tr class="warning">
					<td colspan="<%=4%>">TODO 항목이 없습니다. </td>
				</tr>
				<% } else { %>
					<% for (int i = 0; i < list.size(); i++) { %>
						<% ProjectWork2 pwInfo = (ProjectWork2)list.get(i); %>
						<tr id="td_<%=pwInfo.wid%>">
							<td><%=list.size() - i%></td>
							<td><%=WebUtil.getDueDateDisplayStr(pwInfo.regdate)%></td>
							<%if ( "Z".equals(type) ) { %>
									<td id="wid_<%=pwInfo.wid %>" class="clickable <%=workId==pwInfo.wid?"clicked":"" %>"
								onClick="javascript:expandDetail('<%=pwInfo.wid%>')"> <%=pwInfo.getStatusString()%></td>
							<% } %>
							<td id="wid_<%=pwInfo.wid %>" class="clickable <%=workId==pwInfo.wid?"clicked":"" %>" onClick="javascript:expandDetail('<%=pwInfo.wid%>')"><%=WebUtil.getValue(pwInfo.content)%></td>
							<td><button onClick="viewModifyWorkInfo('<%=pwInfo.wid%>')"
									class="btn btn-small" type="button">수정</button></td>
						</tr>
					<% } %>
				<% } %>
				</tbody>
			</table>
			<% if (list.size() > 0) { %>
				<% for (int i = 0; i < list.size(); i++) { %>
					<% ProjectWork2 pwInfo = (ProjectWork2)list.get(i); %>
					<div id="detail_<%=pwInfo.wid %>" class="hide">
						<dl class="dl-horizontal">
							<dt>프로젝트 ID </dt>
							<dd><%=WebUtil.getValue(pwInfo.projectName) + "(" +  WebUtil.getValue(pwInfo.pid) + ")" %>&nbsp;</dd>
							
							<dt>요청사항 ID</dt>
							<dd><%=WebUtil.getValue(pwInfo.rid)%>&nbsp;</dd>
							<dt>담당자</dt>
							<dd><%=WebUtil.getValue(pwInfo.userName)%>&nbsp;</dd>
							<dt>내용</dt>
							<dd><%=WebUtil.getMultiLineValue(pwInfo.content)%>&nbsp;</dd>
							<dt>이슈</dt>
							<dd><%=WebUtil.getMultiLineValue(pwInfo.issue)%>&nbsp;</dd>
							<dt>상태</dt>
							<dd><%=WebUtil.getValue(pwInfo.getStatusString())%>&nbsp;</dd>
						</dl>
					</div>
				<% } %>
			<% } %>
		</div>
	</div>
</div>

<%@include file="../inc/footer.jsp"%>