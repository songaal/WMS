<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@include file="../inc/session.jsp"%>
<%
	ProjectWorkDAO pwDAO = new ProjectWorkDAO();
	request.setCharacterEncoding("utf-8");

	String wid = request.getParameter("wid");
	ProjectWork pwInfo = pwDAO.selectWork(wid);
	if ( pwInfo == null )
		return;
	
	String content = pwInfo.content;
	String issue = "";
	if ( pwInfo.issue != null && pwInfo.issue.isEmpty() == false )
		issue = pwInfo.issue;
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
	
	String strDoneDate = "";
	if ( pwInfo.doneDate != null )	
		strDoneDate = sdf.format(pwInfo.doneDate);
	
	
	String strRegDate = "";
	if ( pwInfo.regdate != null )	
		strRegDate = sdf.format(pwInfo.regdate);
	
%>
<form id="workModify" name="workModify" method="post" action="doWork.jsp">
	<input type="hidden" name="action" />
	<input type="hidden" name="wid" value="<%=wid%>" />
	<input type="hidden" name="pid" value="<%=pwInfo.pid%>" />	
	<input type="hidden" name="userId" value="<%=myUserInfo.serialId%>" />
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>
			<tr>
				<th>일자</th>
				<td>
					<div name="rdate" id="rdate" class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="regdate" type="text" value='<%=strRegDate%>'> 
					<span class="add-on"><i	class="icon-calendar"></i></span>
					</div>
				</td>
			</tr>
			<tr>
				<th>종료일자</th>
				<td>
					<div name="dDate" id="dDate" class="input-append date" data-date="" data-date-format="yyyy.mm.dd">
					<input class="input-small uneditable-input" size="10" name="doneDate" id="doneDate" type="text" value='<%=strDoneDate%>'> 
					<span class="add-on">
					<i	class="icon-calendar"></i>
					</span>
					</div>
				</td>
			</tr>
			<th>진행상태</th>
				<td>
					<select name="status" id="status" >
					<option value="A" <%= pwInfo.status.equals("A") ? "selected" : "" %> >등록</option>
					<option value="B" <%= pwInfo.status.equals("B") ? "selected" : "" %> >진행</option>
					<option value="C" <%= pwInfo.status.equals("C") ? "selected" : "" %> >완료 </option>
					</select>					
				</td>
			<tr>
				<th>작업내용</th>
				<td>
				<textarea name="content" class="mid"><%=content%></textarea>				
				</td>
			</tr>
			<tr>
				<th>이슈</th>
				<td><textarea name="issue" class="mid"><%=issue%></textarea>
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
