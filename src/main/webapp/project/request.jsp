<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.ProjectRequestDAO" %>
<%@ page import="co.fastcat.wms.dao.ProjectWorkDAO" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>
<%@ page import="co.fastcat.wms.bean.ProjectRequest2" %>

<%@include file="../inc/header.jsp"%>

<%
	String pid = request.getParameter("pid");
	String status = request.getParameter("status");
	
	ProjectRequestDAO dao = new ProjectRequestDAO();
	List<DAOBean> list = dao.selectProject(pid);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	String nowDate = sdf.format(new Date());
	
%>

<div class="modal hide" id="insertModal" tabindex="-1" role="dialog"
	aria-labelledby="insertModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">×</button>
		<h3 id="insertModalLabel">요청사항추가</h3>
	</div>
	<div class="modal-body">
		<form id="projectForm" method="post" action="doRequest.jsp">
			<input type="hidden" name="action" /> 
			<input type="hidden" name="pid" value="<%=pid%>" /> 
			<input type="hidden" name="statusFilter" value="<%=status%>" /> 
			<input type="hidden" name="userId" value="<%=myUserInfo.serialId%>" /> 
			<input type="hidden" name="status" value="접수" />			
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>

					<tr>
						<th>요청일</th>
						<td>
							<div name="reqDate" id="reqDate" class="input-append date required" data-date="" data-date-format="yyyy.mm.dd">
							<input class="input-small uneditable-input" size="10" name="regdate" type="text" value="<%=nowDate%>"> 
							<span class="add-on"><i
									class="icon-calendar"></i></span>
							</div>

						</td>
					</tr>

					<tr>
						<th>요청자</th>
						<td><select name="clientId" id="clientId"></select> <select
							name="clientPersonId" id="clientPersonId" class="required"></select>
							<div id="newClientPersonId" class="hide">
								<input type='text' name='newClientPersonName'
									placeholder='이름 직함'></input>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-home"></i></span> <input
										type='text' name='newClientPersonPhone' placeholder='회사전화번호'></input>
								</div>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-user"></i></span> <input
										type='text' name='newClientPersonCellPhone' placeholder='핸드폰'></input>
								</div>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-envelope"></i></span> <input
										type='text' name='newClientPersonEmail' placeholder='이메일'></input>
								</div>
							</div></td>
					</tr>
					<tr>
						<th>요청방법</th>
						<td><select name="method" class="span2 required">
								<option value="">:: 선택 ::</option>
								<option value="이메일">이메일</option>
								<option value="전화">전화</option>
								<option value="구두">구두</option>
								<option value="기타">기타</option>
						</select></td>
					</tr>
					<tr>
						<th>요청내용</th>
						<td><textarea name=content class="mid required"></textarea></td>
					</tr>
					<tr>
						<th>기한일자</th>
						<td>
							<div name="dueDate" id="dueDate" class="input-append date"
								data-date="" data-date-format="yyyy.mm.dd">
								<input class="input-small uneditable-input" size="10"
									name="dueDate" type="text"> <span class="add-on"><i
									class="icon-calendar"></i></span>
							</div> 
						</td>
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
		<h3 id="modifyModalLabel">요청사항 수정</h3>
	</div>
	<div id="request-content" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifyProjectRequest()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-danger" onclick="deleteProjectRequest()">삭제</button>
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
					onClick="viewInsertProjectRequest()">요청사항추가</button>
			</p>

			<%
				if(list.size() == 0){
			%>
			<table class="table table-bordered table-condensed">
				<tr>
					<td>요청내역이 없습니다.</td>
				</tr>
			</table>
			<%
				}
			%>

			<%
				Date prevDate = null;
				for(int i=0; i<list.size(); i++){
					ProjectRequest2 info = (ProjectRequest2) list.get(i);
				
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
						<th>일자</th>
						<td><%=WebUtil.toDateStringWithYoil(info.regdate)%></td>
					</tr>
					<tr>
						<th>담당자</th>
						<td><%=info.userName%><a name="<%=WebUtil.getValue(info.rid) %>"></a></td>
					</tr>
					<tr>
						<th>요청자</th>
						<td><%=info.clientPersonName != null ? info.clientPersonName : "" %></td>
					</tr>
					<tr>
						<th>요청방법</th>
						<td><%=WebUtil.getValue(info.method)%></td>
					</tr>
					<tr>
						<th>요청내용</th>
						<td><%=WebUtil.getMultiLineValue(info.content)%></td>
					</tr>
					<tr>
						<th>기한일자</th>
						<td><%=WebUtil.toDateString(info.dueDate)%></td>
					</tr>
					<tr>
						<th>처리일자</th>
						<td><%=WebUtil.toDateString(info.doneDate)%></td>
					</tr>
					<tr class="warning">
						<th>진행상태</th>
						<td>
						
						<%
						ProjectWorkDAO pwDAO = new ProjectWorkDAO();
						if ( pwDAO.isWorkExists(info.pid+"", info.rid+"") == false ) 
						{
						%>
						<form id="appendWorkForm_<%=info.pid%>_<%=info.rid%>" method="post" action="doRequest.jsp" style="margin:0 0 0px;">
						
						<input type="hidden" name="action" value="appendWork"/>
						<input type="hidden" name="rid" value="<%=info.rid%>"/>
						<input type="hidden" name="content" value="<%=info.content%>"/>
						<input type="hidden" name="userId" value="<%=myUserInfo.serialId%>"/>
						<input type="hidden" name="project_id" value="<%=info.pid%>"/>
						</form>
						
						<%=WebUtil.getValue(info.getStatusString())%>
						<button class="btn btn-info btn-small" onClick="if(confirm('추가할까요?')){$('#appendWorkForm_<%=info.pid%>_<%=info.rid%>').submit();}" >
						작업추가
						</button>
						
						<%}						
						else
						{
						%>
						<a href="/WMS/project/work.jsp?pid=<%=info.pid%>" >작업할당</a>
						<%
						}
						%>
						
						<button class="btn btn-info btn-small"
						        onClick="javascript:viewModifyRequestInfo('<%=info.rid%>')">
						요청 수정 						        
						</button>						
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



