<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	String ctype = WebUtil.getValue(request.getParameter("ctype"), "A");
	ClientPersonDAO dao = new ClientPersonDAO();
	List<DAOBean> list = null;
	String cname = WebUtil.getValue(request.getParameter("cname"));
	if ( cname == null || cname.isEmpty() )
		list = dao.select2();
	else
		list = dao.personSearch(cname);
		
	ClientDAO clientDAO = new ClientDAO();
	List<ClientInfo> clientList = clientDAO.select();
	
%>
<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog"
	aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">임직원정보수정</h3>
	</div>
	<div id="client-info" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifyClientPerson()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-danger" onclick="deleteClientPerson()">삭제</button>
	</div>
</div>
<!--// 수정폼 -->

<div class="container ">
	<div class="row">

		<div class="span12">
			<h2 id="body-copy">고객정보</h2>
		</div>
			
		<!-- 좌측메뉴 -->
		<div class="span3 bs-docs-sidebar">

			<ul class="nav nav-list bs-docs-sidenav">
				<li><a href="index.jsp"><i class="icon-chevron-right"></i>회사정보</a></li>
				<li class="active"><a href="clientPerson.jsp"><i class="icon-chevron-right"></i>임직원정보</a></li>
			</ul>
		</div>
		<!--// 좌측메뉴 -->
		
		<!-- 메인내용 -->
		<div class="span9">
			<h4>임직원정보</h4>
			<form class="form-search" action="clientPerson.jsp" method="post">
				<div class="input-append">
					<input type="text" class="span2 search-query" name="cname" id="cname">
					<button type="submit" class="btn">검색</button>
				</div>
			</form>
			<p>
				총 <span class="label label-info"><%=list.size() %></span>개
				<button onClick="viewInsertClientPersonInfo()"
					class="btn btn-info btn-small pull-right">임직원정보추가</button>
			</p>
			<div class="alert hide" id="addClientPerson">
				<form id="addForm" action="doClientPerson.jsp" method="post">
					<input type="hidden" name="action" value="insert">
					<input type="hidden" name="regdate" value="<%=WebUtil.toDateString(new Date()) %>">
					<input type="text" name="personName"  placeholder="이름 직함">
					<br/>
					<select name="cid">
						<option> :: 회사 :: </option>
 						<%
						for(int i=0; i<clientList.size(); i++){
							ClientInfo cinfo = clientList.get(i);
						%>
						<option value="<%=cinfo.cid %>"><%=cinfo.clientName %></option>
						<%
						}
						%>
					</select>
					<br/><br/>
					<input type="text" name="phone" class="input-medium" placeholder="전화번호">
					<br/>
					<input type="text" name="cellPhone" class="input-medium" placeholder="핸드폰">
					<br/>
					<input type="text" name="email" class="input-large" placeholder="이메일">
					<br/>
					<textarea name="memo" class="mid" placeholder="메모"></textarea>
					<br/>
					<button type="submit" class="btn btn-primary">추가</button>
					<button type="button" class="btn" onClick="javascript:$('#addClientPerson').hide()">닫기</button>
				</form>
			</div>
			
			<table class="table table-bordered">
				<colgroup>
					<col width="50" />
					<col width="" />
					<col width="" />
					<col width=""/>
					<col width="" />
					<col width="" />
					<col width="" />
					<col width="70" />
				</colgroup>
				<thead>
				<tr>
				<th>번호</th>
				<th>이름</th>
				<th>회사</th>
				<th>전화번호</th>
				<th>핸드폰</th>
				<th>이메일</th>
				<th>메모</th>
				<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
			<%
				for(int i=0; i<list.size(); i++){
					ClientPersonInfo2 info = (ClientPersonInfo2) list.get(i);
			%>
				<tr>
				<td><%=list.size() - i %></td>
				<th><%=info.personName %></th>
				<td><%=WebUtil.getValue(info.clientName) %></td>
				<td><%=WebUtil.getValue(info.phone) %></td>
				<td><%=WebUtil.getValue(info.cellPhone) %></td>
				<td><%=WebUtil.getValue(info.email) %></td>
				<td><%=WebUtil.getValue(info.memo) %></td>
				<td><button onClick="viewModifyClientPersonInfo('<%=info.id%>')" class="btn btn-small" type="button">수정</button></td>
				</tr>
			<%
				}
			%>
				</tbody>
			</table>
		</div>

	</div>
	<!-- row -->
</div>
<!-- container -->
<script>
$(document).ready(function(){
	$('#addForm').validate(
			{
				rules : {
					personName : {required : true, minlength : 2},
					phone : {required : true, minlength : 8 },					
					cellPhone : {required : true, minlength : 8 },
					email : {required : true, email : true },
				}
			}
	);
});
</script>
<%@include file="../inc/footer.jsp"%>



