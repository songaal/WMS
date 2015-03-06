<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	String status = WebUtil.getValue(request.getParameter("status"), ProjectInfo.STATUS_ONGOING);
	ProjectDAO projectDAO = new ProjectDAO();

	ProjectHistoryDAO historyDAO = new ProjectHistoryDAO();
	
	//List<DAOBean> list = historyDAO.selectByDate(new Date(), 7);
	List<DAOBean> list = historyDAO.selectLimit(0, 30);
	
	int showColumnCount = 6;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	String nowDate = sdf.format(new Date());
%>

<!-- 추가폼 -->
<div class="modal hide" id="insertModal" tabindex="-1" role="dialog"
	aria-labelledby="insertModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">×</button>
		<h3 id="insertModalLabel">프로젝트추가</h3>
	</div>
	
	
	<div class="modal-body">
		<form id="projectForm" method="post" action="doProject.jsp">
			<input type="hidden" id="pmIdValue" value="<%=myUserInfo.serialId%>" />
			<input type="hidden" name="action" /> <input type="hidden"
				name="status" value="<%=ProjectInfo.STATUS_ONGOING%>" /> <input
				type="hidden" name="type" value="O" />
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					<tr>
						<th>프로젝트명</th>
						<td><input type="text" name="name" class="input-xlarge required" /></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><textarea name=description class="mid"></textarea></td>
					</tr>

					<tr>
						<th>담당자</th>
						<td><select name="pmId" id="pmId"></select></td>
					</tr>
					<tr>
						<th>고객사</th>
						<td><select name="clientId" id="clientId"></select><span
							id="newClientId" class="hide"><input type='text'
								name='newClientName' placeholder='회사명'></input></span></td>
					</tr>
					<tr>
						<th>고객담당자</th>
						<td><select name="clientPersonId" id="clientPersonId"></select>
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
						<th>구축업체</th>
						<td><select name="resellerId" id="resellerId"></select><span
							id="newResellerId" class="hide"><input type='text'
								name='newResellerName' placeholder='회사명'></input></span></td>
					</tr>
					<tr>
						<th>구축업체담당자</th>
						<td><select name="resellerPersonId" id="resellerPersonId"></select>
							<div id="newResellerPersonId" class="hide">
								<input type='text' name='newResellerPersonName'
									placeholder='이름 직함'></input>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-home"></i></span> <input
										type='text' name='newResellerPersonPhone' placeholder='회사전화번호'></input>
								</div>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-user"></i></span> <input
										type='text' name='newResellerPersonCellPhone'
										placeholder='핸드폰'></input>
								</div>
								<div class="input-prepend">
									<span class="add-on"><i class="icon-envelope"></i></span> <input
										type='text' name='newResellerPersonEmail' placeholder='이메일'></input>
								</div>
							</div></td>
					</tr>
					<tr>
						<th>시작일</th>
						<td>
							<div id="dp1" class="input-append date" data-date=""
								data-date-format="yyyy.mm.dd">
								<input class="input-small uneditable-input required" size="10"
									id="startDate" name="startDate" type="text" value="<%=nowDate%>"> <span
									class="add-on"><i class="icon-th"></i></span>
							</div> <script>
								$('#dp1').datepicker();
								$('#dp1').datepicker().on('changeDate',
										function(ev) {
											$(this).blur();
											$('#dp1').datepicker('hide');
										});
							</script>
						</td>
					</tr>
					<tr>
						<th>종료일</th>
						<td>
							<div id="dp2" class="input-append date" data-date=""
								data-date-format="yyyy.mm.dd">
								<input class="input-small uneditable-input" size="10"
									id="endDate" name="endDate" type="text"> <span
									class="add-on"><i class="icon-th"></i></span>
							</div> <script>
								$('#dp2').datepicker()
								$('#dp2').datepicker().on('changeDate',
										function(ev) {
											$(this).blur();
											$('#dp2').datepicker('hide');
										});
							</script>
						</td>
					</tr>
					<tr>
						<th>제품</th>
						<td><input type="text" class="input-xlarge,required" name="solution">
						</td>
					</tr>
					<tr>
						<th>라이센스</th>
						<td><input type="text" class="input-xlarge,required" name="license">
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="insertProject()">저장</button>
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
				<button onClick="viewInsertProjectRequest()"
					class="btn btn-info btn-small pull-right">프로젝트추가</button>
			<br/>
			<br/>
			<table class="table table-bordered table-hover table-condensed">
				<colgroup>
					<col width="150">
					<col width="100">
					<col width="100">
					<col width="100">
					<col width="*">
				</colgroup>
				<tbody>
				<tr>
					<th>날자</th>
					<th>구분</th>
					<th>프로젝트명</th>
					<th>담당자</th>
					<th>내용</th>
				</tr>
				<% if(list.size() == 0){ %>
				<tr>
				<td colspan="4">히스토리 내역이 없습니다.</td>
				</tr>
				<% } %>
				<%
				Date prevDate = null;
				String anchor = "";
				for(int i=0; i<list.size(); i++){
					ProjectHistory2 info = (ProjectHistory2) list.get(i);
					anchor = "/WMS/project/";
					
					if ( info.type.equals("회의록")) {
						anchor = anchor + "meetings.jsp?pid=";	
					} else if ( info.type.equals("요청") ) {
						anchor = anchor + "request.jsp?pid=";	
					} else if ( info.type.equals("정기점검")) {
						anchor = anchor + "maint.jsp?pid=";
					} else if ( info.type.equals("작업")) {
						anchor = anchor + "work.jsp?pid=";
					} else if ( info.type.equals("작업내역")) {
						anchor = "/WMS/todo/index.jsp?wid="+info.wid+"&pid=";
					} else {
						anchor = anchor + "info.jsp?pid=";
					}
					
					anchor = anchor + info.pid + "&status=B#" + info.wid+"";	
					
					if(info.projectName==null) {
						anchor="";
					}
					
					if(WebUtil.isPrevYear(info.regdate, prevDate)){
						String dateStr = WebUtil.toHangulYearMonthString(info.regdate);
					%>
						<tr class="info">
						<td colspan="5"><strong><%=dateStr.substring(0, 5) %></strong></td>
						</tr>
					<%
					}
					
					if(WebUtil.isPrevMonth(info.regdate, prevDate)){
						String dateStr = WebUtil.toHangulYearMonthString(info.regdate);
					%>
						<tr class="warning">
						<td colspan="5"><strong><%=dateStr.substring(6) %></strong></td>
						</tr>
					<%
					}
					
					prevDate = info.regdate;
				%>
				<tr>
					<td><%=WebUtil.toDateStringWithYoil(info.regdate) %></td>
					<td><%=WebUtil.getValue(info.type) %></td>
					<td><%=WebUtil.getValue(info.projectName) %></td>
					<td><%=info.userName %></td>
					<td>
					<%if(!"".equals(anchor)) {%>
						<a href="<%=anchor %>"><%=WebUtil.getMultiLineValue(info.memo) %></a>
					<% } else { %>
						<%=WebUtil.getMultiLineValue(info.memo) %>
					<% } %>
					</td>
				</tr>
				<%
				}
				%>
				</tbody>
			</table>
		</div>
	</div>
</div>

<%@include file="../inc/footer.jsp"%>



