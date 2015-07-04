<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.SalesDAO" %>
<%@ page import="co.fastcat.wms.bean.SalesInfo" %>

<%@include file="../inc/header.jsp"%>

<%
	SalesDAO salesDAO = new SalesDAO();
	request.setCharacterEncoding("utf-8");
	
	String type = WebUtil.getValue(request.getParameter("type"), "A");
	List<SalesInfo> list = null;
	if(type.equals("Z")){
		//전체리스트
		list = salesDAO.select();
	}else{
		list = salesDAO.selectType(type);
	}
	
	int showColumnCount = 10;
%>

<!-- 추가폼 -->
<div class="modal hide" id="insertModal" tabindex="-1" role="dialog" aria-labelledby="insertModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="insertModalLabel">영업내용추가</h3>
	</div>
	<div class="modal-body">
		<form id="salesForm" method="post" action="doSales.jsp">
			<input type="hidden" name="action" />
			<input type="hidden" name="result" value="A"/>
			<input type="hidden" name="reporter" value="<%=myUserInfo.userName%>" />
			<table class="table table-hover table-condensed table-striped">
				<colgroup>
					<col width="160">
					<col width="">
				</colgroup>
				<tbody>
					<tr>
						<th>날짜</th>
						<td><input type="text" name="regdate" value="<%=WebUtil.toDateString(new Date())%>"/></td>
					</tr>
					<tr>
						<th>업체명</th>
						<td><input type="text" name="company" /></td>
					</tr>
					<tr>
						<th>문의내용</th>
						<td><textarea name="memo" class="mid"></textarea></td>
					</tr>
					<tr>
						<th>담당자</th>
						<td><input type="text" name="person" /></td>
					</tr>
					<tr>
						<th>연락처</th>
						<td><textarea name="contact" class="small"></textarea></td>
					</tr>
					<tr>
						<th>문의방법</th>
						<td><input type="text" name="method" /></td>
					</tr>
					<tr>
						<th>예상금액</th>
						<td><input type="text" name="budget" /></td>
					</tr>
					<tr>
						<th>예상시기</th>
						<td><input type="text" name="startDay" /></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="insertSales()">저장</button>
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
		<h3 id="modifyModalLabel">영업내용수정</h3>
	</div>
	<div id="sales-content" class="modal-body"></div>
	<div class="modal-footer">
		<button class="btn btn-primary" onclick="modifySales()">저장</button>
		<button class="btn" data-dismiss="modal" aria-hidden="true">닫기</button>
		<button class="btn btn-danger" onclick="deleteSales()">삭제</button>
	</div>
</div>
<!--// 수정폼 -->

<div class="container ">
	<div class="row">
		<div class="span12">
			<h2 id="body-copy">영업</h2>
		</div>
		
		<!-- 좌측메뉴 -->
		<div class="span3 bs-docs-sidebar">
			<ul class="nav nav-list bs-docs-sidenav">
				<li class="active"><a href="index.jsp"><i class="icon-chevron-right"></i>영업관리</a></li>
			</ul>
		</div>
		<!--// 좌측메뉴 -->
	
		<!-- 메인내용 -->
		<div class="span9">
			<h4>영업관리</h4>
			<div class="btn-group pagination-centered">
				<button class="btn btn-small <%="A".equals(type)?"active":"" %>" onClick="viewSalesList('A')">문의</button>
				<button class="btn btn-small <%="B".equals(type)?"active":"" %>" onClick="viewSalesList('B')">계약</button>
				<button class="btn btn-small <%="C".equals(type)?"active":"" %>" onClick="viewSalesList('C')">보류</button>
				<button class="btn btn-small <%="D".equals(type)?"active":"" %>" onClick="viewSalesList('D')">취소</button>
				<button class="btn btn-small <%="E".equals(type)?"active":"" %>" onClick="viewSalesList('E')">실패</button>
				<button class="btn btn-small <%="F".equals(type)?"active":"" %>" onClick="viewSalesList('F')">기타</button>
				<button class="btn btn-small <%="Z".equals(type)?"active":"" %>" onClick="viewSalesList('Z')">전체</button>
				
			</div>
			<p>
				총 <span class="label label-info"><%=list.size()%></span>건
				<button onClick="viewInsertSalesInfo()"
					class="btn btn-info btn-small pull-right">내용추가</button>
			</p>
			<table class="table table-bordered table-hover table-condensed">
				<colgroup>
					<col width="50" />
					<col width="80" />
					<col width="100" />
					<col width="150"/>
					<col width="100" />
					<col width="100" />
					<col width="150" />
					<% if(type.equals("Z")){ %>
					<col width="50" />
					<% } %>
					<col width="60" />
				</colgroup>
			
				<thead>
					<tr>
						<th>순번</th>
						<th>일자</th>
						<th>업체명</th>
						<th>내용</th>
						<th>담당자</th>
						<th>예상금액</th>
						<th>예상시기</th>
						<% if(type.equals("Z")){ %>
						<th>결과</th>
						<% } %>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<%
						if (list.size() == 0) {
					%>
					<tr class="warning">
						<td colspan="<%=showColumnCount%>">영업내역이 없습니다.</td>
					</tr>
					<%
						} else {
							for (int i = 0; i < list.size(); i++) {
								SalesInfo salesInfo = list.get(i);
								String cssClass = "";
								String result = "";
								
								if ("A".equals(salesInfo.result)) {
									result = "미정";
								} else if ("B".equals(salesInfo.result)) {
									result = "계약";
									cssClass = "success";
								} else if ("C".equals(salesInfo.result)) {
									result = "보류";
								} else if ("D".equals(salesInfo.result)) {
									result = "취소";
								} else if ("E".equals(salesInfo.result)) {
									result = "실패";
									cssClass = "error";
								} else if ("F".equals(salesInfo.result)) {
									result = "기타";
								}
								
								
					%>
					<tr class="<%=cssClass%>" id="td_<%=salesInfo.id%>">
						<td class="clickable"
							onClick="expandDetail('<%=salesInfo.id%>')"><%=list.size() - i%></td>
						<td class="clickable"
							onClick="expandDetail('<%=salesInfo.id%>')"><%=WebUtil.toDateString(salesInfo.regdate)%></td>
						<td class="clickable"
							onClick="expandDetail('<%=salesInfo.id%>')"><%=WebUtil.getValue(salesInfo.company)%></td>
						<td class="clickable"
							onClick="expandDetail('<%=salesInfo.id%>')"><%=WebUtil.getValue(salesInfo.memo, 20)%></td>
						<td class="clickable"
							onClick="expandDetail('<%=salesInfo.id%>')"><%=WebUtil.getValue(salesInfo.person)%></td>
						<td class="clickable"
							onClick="expandDetail('<%=salesInfo.id%>')"><%=WebUtil.getValue(salesInfo.budget)%></td>
						<td class="clickable"
							onClick="expandDetail('<%=salesInfo.id%>')"><%=WebUtil.getValue(salesInfo.startDay)%></td>
						<% if(type.equals("Z")){ %>
						<td class="clickable"
							onClick="expandDetail('<%=salesInfo.id%>')"><%=result%></td>
						<% } %>
						<td><button
								onClick="viewModifySalesInfo('<%=salesInfo.id %>')"
								class="btn btn-small" type="button">수정</button></td>
					</tr>
					<%
							}
						}
					%>
				</tbody>
			</table>

			<%
				if (list.size() > 0) {
					for (int i = 0; i < list.size(); i++) {
						SalesInfo salesInfo = list.get(i);
			%>

			<div id="detail_<%=salesInfo.id %>" class="hide">
				<dl class="dl-horizontal">
					<dt>내용</dt>
					<dd><%=WebUtil.getMultiLineValue(salesInfo.memo) %>&nbsp;</dd>
					<dt>연락처</dt>
					<dd><%=WebUtil.getValue(salesInfo.contact)%>&nbsp;</dd>
					<dt>문의방식</dt>
					<dd><%=WebUtil.getValue(salesInfo.method)%>&nbsp;</dd>
					<dt>처리인</dt>
					<dd><%=WebUtil.getValue(salesInfo.reporter)%>&nbsp;</dd>
					<dt>결과내용</dt>
					<dd><%=WebUtil.getValue(salesInfo.resultMemo)%>&nbsp;</dd>
					<dt>결과처리일</dt>
					<dd><%=WebUtil.toDateString(salesInfo.resultDate)%>&nbsp;</dd>
				</dl>
			</div>
			<%
				}
				}
			%>
		</div>
	</div>

</div>

<%@include file="../inc/footer.jsp"%>



