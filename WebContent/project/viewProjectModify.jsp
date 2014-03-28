<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@include file="../inc/session.jsp"%>

<%
	String pid = request.getParameter("pid");
	String statusFilter = request.getParameter("statusFilter"); //좌측리스트에 사용되는 상태필터값.
	ProjectDAO projectDAO = new ProjectDAO();
	ProjectInfo2 info = projectDAO.selectTypeOut(pid);
%>

<input type="hidden" id="pmIdValue" value="<%=info.pmId%>" />
<input type="hidden" id="clientIdValue" value="<%=info.clientId%>" />
<input type="hidden" id="clientPersonIdValue" value="<%=info.clientPersonId%>" />
<input type="hidden" id="resellerIdValue" value="<%=info.resellerId%>" />
<input type="hidden" id="resellerPersonIdValue" value="<%=info.resellerPersonId%>" />

<form id="projectForm" method="post" action="doProject.jsp">
	<input type="hidden" name="action" />
	<input type="hidden" name="pid" value="<%=pid%>"/>
	<input type="hidden" name="statusFilter" value="<%=statusFilter%>"/>
	<input type="hidden" name="type" value="<%=info.type %>"/>
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>
			<tr>
				<th>프로젝트명</th>
				<td><input type="text" name="name" class="input-xlarge" value="<%=info.name%>"/></td>
			</tr>
			<tr>
				<th>내용</th>
				<td><textarea name=description class="mid"><%=info.description %></textarea></td>
			</tr>
			
			<tr>
				<th>담당자</th>
				<td><select name="pmId" id="pmId"></select></td>
			</tr>
			<tr>
				<th>고객사</th>
				<td>
				<select name="clientId" id="clientId"></select><span id="newClientId" class="hide"><input type='text' name='newClientName' placeholder='회사명'></input></span>
				</td>
			</tr>
			<tr>
				<th>고객담당자</th>
				<td>
				<select name="clientPersonId" id="clientPersonId"></select>
				<div id="newClientPersonId" class="hide">
					<input type='text' name='newClientPersonName' placeholder='이름 직함'></input>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-home"></i></span>
						<input type='text' name='newClientPersonPhone' placeholder='회사전화번호'></input>
					</div>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-user"></i></span>
						<input type='text' name='newClientPersonCellPhone' placeholder='핸드폰'></input>
					</div>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-envelope"></i></span>
						<input type='text' name='newClientPersonEmail' placeholder='이메일'></input>
					</div>
				</div>
				</td>
			</tr>
			<tr>
				<th>구축업체</th>
				<td>
				<select name="resellerId" id="resellerId"></select><span id="newResellerId" class="hide"><input type='text' name='newResellerName' placeholder='회사명'></input></span>
				</td>
			</tr>
			<tr>
				<th>구축업체담당자</th>
				<td>
				<select name="resellerPersonId" id="resellerPersonId"></select>
				<div id="newResellerPersonId" class="hide">
					<input type='text' name='newResellerPersonName' placeholder='이름 직함'></input>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-home"></i></span>
						<input type='text' name='newResellerPersonPhone' placeholder='회사전화번호'></input>
					</div>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-user"></i></span>
						<input type='text' name='newResellerPersonCellPhone' placeholder='핸드폰'></input>
					</div>
					<div class="input-prepend">
						<span class="add-on"><i class="icon-envelope"></i></span>
						<input type='text' name='newResellerPersonEmail' placeholder='이메일'></input>
					</div>
				</div>
				
				</td>
			</tr>
			<tr>
				<th>프로젝트시작일</th>
				<td>
				<div  name="startDateId" id="startDateId" class="input-append date" data-date="<%=WebUtil.toDateString(info.startDate)%>" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="startDate" id="startDate" type="text" value="<%=WebUtil.toDateString(info.startDate)%>">
					<span class="add-on"><i class="icon-calendar"></i></span>
				</div>
				</td>
			</tr>
			<tr>
				<th>프로젝트종료일</th>
				<td>
				<div  name="endDateId" id="endDateId" class="input-append date" data-date="<%=WebUtil.toDateString(info.endDate)%>" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="endDate" type="text" value="<%=WebUtil.toDateString(info.endDate)%>">
					<span class="add-on"><i class="icon-calendar"></i></span>
				</div>
				</td>
			</tr>
			<tr>
				<th>상태</th>
				<td>
				<select name="status">
					<option value="<%=ProjectInfo.STATUS_ONGOING %>" <%=ProjectInfo.STATUS_ONGOING.equals(info.status)?"selected":"" %> >진행중</option>
					<option value="<%=ProjectInfo.STATUS_DONE %>" <%=ProjectInfo.STATUS_DONE.equals(info.status)?"selected":"" %> >완료</option>
					<option value="<%=ProjectInfo.STATUS_MAINTAIN %>" <%=ProjectInfo.STATUS_MAINTAIN.equals(info.status)?"selected":"" %> >유지보수</option>
					<option value="<%=ProjectInfo.STATUS_DUMP %>" <%=ProjectInfo.STATUS_DUMP.equals(info.status)?"selected":"" %> >계약종료</option>
				</select>
				</td>
			</tr>
			<tr>
				<th>유지보수시작일</th>
				<td>
				<div name="mStartDate" id="mStartDate" class="input-append date" data-date="<%=WebUtil.toDateString(info.mStartDate)%>" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="mStartDate" type="text" value="<%=WebUtil.toDateString(info.mStartDate)%>">
					<span class="add-on"><i class="icon-calendar"></i></span>
				</div>
				<script>
						
				</script>
				</td>
			</tr>
			<tr>
				<th>유지보수종료일</th>
				<td>
				<div name="mEndDate" id="mEndDate" class="input-append date" data-date="<%=WebUtil.toDateString(info.mEndDate)%>" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="mEndDate" type="text" value="<%=WebUtil.toDateString(info.mEndDate)%>">
					<span class="add-on"><i class="icon-calendar"></i></span>
				</div>				
				</td>
			</tr>
			<tr>
				<th>제품</th>
				<td>
					<input type="text" style="xlarge" name="solution" value="<%=info.solution%>" >
				</td>
			</tr>
			<tr>
				<th>라이센스</th>
				<td>
					<input type="text" style="xlarge" name="license" value=<%=info.license%> >
				</td>
			</tr>
		</tbody>
	</table>
</form>
<script type="text/javascript">
$(function() {
	$(".date").datepicker().on("changeDate", function(ev) {
		$(this).blur();
		$(this).datepicker('hide');
	});
	var element = $("#pmId");
	if(element[0]) {
		$.ajax({
			url: "/WMS/common/listUser.jsp"
			, async: false
			, dataType: "json"
			, success: function(j) {
				var options = '<option value="">:: 선택 ::</option>';
				for ( var i = 0; i < j.length; i++) {
					options += '<option value="' + j[i].value + '">' + j[i].name + '</option>';
				}
				element.html(options);
			}
		});
	}
});
</script>