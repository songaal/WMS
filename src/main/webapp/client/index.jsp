<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.ClientInfo" %>
<%@ page import="co.fastcat.wms.dao.ClientDAO" %>
<%@ page import="co.fastcat.wms.webpage.WebUtil" %>

<%@include file="../inc/header.jsp"%>

<%
	//String ctype = WebUtil.getValue(request.getParameter("ctype"), "");
	/* if(ClientInfo.ClientA.equals(ctype)){
		list = dao.selectA();
	}else if(ClientInfo.ClientB.equals(ctype)){
		list = dao.selectB();
	}else{ */
		
	
	ClientDAO dao = new ClientDAO();
	List<ClientInfo> list = null;
	
	String cname = WebUtil.getValue(request.getParameter("cname"));
	if ( cname == null || cname.isEmpty() ) {
		list = dao.select();
	} else {
		list = dao.clientSearch(cname);
	}
		
%>
  
<!-- 수정폼 -->
<div class="modal hide" id="modifyModal" tabindex="-1" role="dialog"
	aria-labelledby="modifyModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-hidden="true">×</button>
		<h3 id="modifyModalLabel">회사정보수정</h3>
	</div>
	<div id="client-info" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifyClient()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-danger" onclick="deleteClient()">삭제</button>
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
				<li class="active"><a href="index.jsp"><i class="icon-chevron-right"></i>회사정보</a></li>
				<li><a href="clientPerson.jsp"><i class="icon-chevron-right"></i>임직원정보</a></li>
			</ul>
		</div>
		<!--// 좌측메뉴 -->
		
		<!-- 메인내용 -->
		<div class="span9">
			<h4>회사정보</h4>
			
			<form class="form-search" action="index.jsp" method="post">
				<div class="input-append">
					<input type="text" class="span2 search-query" name ="cname" id = "cname" >
					<button type="submit" class="btn">검색</button>
				</div>
			</form>
			
			<div class="btn-group pagination-centered">
			</div>
			
			<p>
				총 <span class="label label-info"><%=list.size() %></span>개
				<button onClick="viewInsertClientInfo()"
					class="btn btn-info btn-small pull-right">회사정보추가</button>
			</p>
			<div class="alert hide" id="addClient">
				<form id="addForm" action="doClient.jsp" method="post">
					<input type="hidden" name="action" value="insert">
					<input type="hidden" name="regdate" value="">
					<input type="text" name="clientName" class="input required" placeholder="회사명">
					<br/>
					<input type="text" name="phone" class="input-medium" placeholder="전화번호">
					<br/>
					<input type="text" name="address" class="input-xxlarge" placeholder="주소">
					<br/>
					<textarea name="memo" class="mid" placeholder="메모"></textarea>
					<br/>
					<button type="submit" class="btn btn-primary">추가</button>
					<button type="button" class="btn" onClick="javascript:$('#addClient').hide()">닫기</button>
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
					<col width="70" />
				</colgroup>
				<thead>
				<tr>
				<th>번호</th>
				<th>고객사명</th>
				<th>전화번호</th>
				<th>주소</th>
				<th>메모</th>
				<th>등록일</th>
				<th>&nbsp;</th>
				</tr>
				</thead>
				<tbody>
			<%
				for(int i=0; i<list.size(); i++){
					ClientInfo info = list.get(i);
			%>
				<tr>
				<td><%=list.size() - i %></td>
				<th><%=info.clientName %></th>
				<td><%=WebUtil.getValue(info.phone) %></td>
				<td><%=WebUtil.getValue(info.address) %></td>
				<td><%=WebUtil.getValue(info.memo) %></td>
				<td><%=WebUtil.toDateString(info.regdate)%></td>
				<td><button onClick="viewModifyClientInfo('<%=info.cid%>')" class="btn btn-small" type="button">수정</button></td>
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

<%@include file="../inc/footer.jsp"%>



