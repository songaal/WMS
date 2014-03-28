<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@include file="../inc/session.jsp"%>
<script src="/WMS/assets/js/project.js"></script>
<%
	ProjectRequestDAO prDAO = new ProjectRequestDAO();
	request.setCharacterEncoding("utf-8");

	String rid = request.getParameter("rid");
	ProjectRequest2 info = prDAO.selectRequest(rid);
	if ( info == null )
		return;
	
	/*
	요청사항 해당 회사 알아 내기 
	*/
	
	ClientPersonInfo2 cp = new ClientPersonInfo2();
	ClientPersonDAO cpDAO = new ClientPersonDAO();
	cp = cpDAO.select2(info.clientPersonId+"");	
	
	String content = info.content;
	if ( content == null )
		content = "";
		
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	
	String strDoneDate = "";
	if ( info.doneDate != null )	
		strDoneDate = sdf.format(info.doneDate);
	
	String strDueDate = "";
	if ( info.dueDate != null )	
		strDueDate = sdf.format(info.dueDate);
		
	String strRegDate = "";
	if ( info.regdate != null )	
		strRegDate = sdf.format(info.regdate);
	
%>
<form id="requestModifyForm" method="post" action="doRequest.jsp">
	<input type="hidden" name="action" />
	<input type="hidden" name="rid"	value="<%=info.rid%>" /> 
	<input type="hidden" name="pid"	value="<%=info.pid%>" /> 
	<input type="hidden" name="statusFilter" value="<%=info.status%>" /> 
	<input type="hidden" name="userId"	value="<%=myUserInfo.serialId%>" />	
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>

			<tr>
				<th>요청일</th>
				<td>
					<div name="reqDate" id="reqDate" class="input-append date"	data-date="" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="regdate" type="text" value="<%=strRegDate%>"> 
							<span class="add-on"><i	class="icon-calendar"></i></span>
					</div>

				</td>
			</tr>

			<tr>
				<th>요청자</th>
				<td>
					<select name="clientId" id="clientId"></select> 
					<select	name="clientPersonId" id="clientPersonId"></select>
					<div id="newClientPersonId" class="hide">
						<input type='text' name='newClientPersonName' placeholder='이름 직함'></input>
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
					</div>
				</td>
			</tr>
			<tr>
				<th>요청방법</th>
				<td><select name="method" class="span2">
						<option value="">:: 선택 ::</option>
						<option value="이메일" <%=info.method.equals("이메일") ? "selected" : ""%> >이메일</option>
						<option value="전화"  <%=info.method.equals("전화") ? "selected"   : ""%> >전화</option>
						<option value="구두"  <%=info.method.equals("구두") ? "selected"   : ""%> >구두</option>
						<option value="기타"  <%=info.method.equals("기타") ? "selected"  : ""%> >기타</option>
				</select></td>
			</tr>
			<tr>
				<th>진행상태</th>
				<td><select name="status" class="span2">						
						<option value="A" <%=info.status.equals("A") ? "selected" : ""%> >등록</option>
						<option value="B" <%=info.status.equals("B") ? "selected" : ""%> >작업중</option>
						<option value="C" <%=info.status.equals("C") ? "selected" : ""%> >완료</option>						
				</select></td>
			</tr>
			<tr>
				<th>요청내용</th>
				<td><textarea name=content class="mid"><%=info.content%></textarea></td>
			</tr>
			<tr>
				<th>기한일자</th>
				<td>
					<div name="dueDate" id="dueDate" class="input-append date"
						data-date="" data-date-format="yyyy.mm.dd">
						<input class="input-small uneditable-input" size="10" name="dueDate" type="text" value="<%=strDueDate%>"> 
							<span class="add-on"><i class="icon-calendar"></i></span>
					</div>
				</td>
			</tr>
			
			<tr>
				<th>처리일자</th>
				<td>
					<div name="doneDate" id="doneDate" class="input-append date"
						data-date="" data-date-format="yyyy.mm.dd">
						<input class="input-small uneditable-input" size="10" name="doneDate" type="text" value="<%=strDoneDate%>"> 
							<span class="add-on"><i class="icon-calendar"></i></span>
					</div>
				</td>
			</tr>

		</tbody>
	</table>
</form>
<%if ( info.clientPersonId  > 0 )
	{
%>
<script>	
	$('select#clientId').val(<%=cp.cid%>).attr('selected', true);
	$('select#clientId').change();
	$('select#clientPersonId').val(<%=info.clientPersonId%>).attr('selected', true);
	$('select#clientPersonId').change();
</script>
<%
}
%>