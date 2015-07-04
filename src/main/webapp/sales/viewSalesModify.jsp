<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.dao.SalesDAO" %>
<%@ page import="co.fastcat.wms.bean.SalesInfo" %>
<%@include file="../inc/session.jsp"%>
<%
	SalesDAO salesDAO = new SalesDAO();
	request.setCharacterEncoding("utf-8");

	String salesId = request.getParameter("salesId");
	SalesInfo salesInfo = salesDAO.select(salesId);
	
%>
<form id="salesForm2" method="post" action="doSales.jsp">
	<input type="hidden" name="action" />
	<input type="hidden" name="id" value="<%=salesId%>" />
	<input type="hidden" name="reporter" value="<%=myUserInfo.userName%>" />
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>
			<tr>
				<th>일자</th>
				<td><input type="text" name="regdate" class="small"
					value="<%=WebUtil.toDateString(salesInfo.regdate)%>" />
				</td>
			</tr>
			<tr>
				<th>업체명</th>
				<td><input type="text" name="company"
					value="<%=salesInfo.company%>" /></td>
			</tr>
			<tr>
				<th>문의내용</th>
				<td><textarea name="memo" class="mid"><%=salesInfo.memo%></textarea>
				</td>
			</tr>
			<tr>
				<th>담당자</th>
				<td><input type="text" name="person"
					value="<%=salesInfo.person%>" /></td>
			</tr>
			<tr>
				<th>연락처</th>
				<td><textarea name="contact" class="small"><%=salesInfo.contact%></textarea>
				</td>
			</tr>
			<tr>
				<th>문의방법</th>
				<td><input type="text" name="method"
					value="<%=salesInfo.method%>" /></td>
			</tr>
			<tr>
				<th>예상금액</th>
				<td><input type="text" name="budget"
					value="<%=salesInfo.budget%>" /></td>
			</tr>
			<tr>
				<th>예상시기</th>
				<td><input type="text" name="startDay"
					value="<%=WebUtil.getValue(salesInfo.startDay)%>" /></td>
			</tr>
			<tr>
				<th>결과</th>
				<td>
					<%
					String result = WebUtil.getValue(salesInfo.result);
					%>
					<select name="result">
						<option value="A" <%="A".equals(result)?"selected":"" %> >미정</option>
						<option value="B" <%="B".equals(result)?"selected":"" %> >계약</option>
						<option value="C" <%="C".equals(result)?"selected":"" %> >보류</option>
						<option value="D" <%="D".equals(result)?"selected":"" %> >취소</option>
						<option value="E" <%="E".equals(result)?"selected":"" %> >실패</option>
						<option value="F" <%="F".equals(result)?"selected":"" %> >기타</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>결과내용</th>
				<td><textarea name="resultMemo" class="mid"><%=WebUtil.getValue(salesInfo.resultMemo)%></textarea>
				</td>
			</tr>
			<tr>
				<th>결과처리일자</th>
				<%
				String resultDate = WebUtil.toDateString(salesInfo.resultDate);
				if(resultDate.length() == 0){
					resultDate = WebUtil.toDateString(new Date());
				}
				%>
				<td><input type="text" name="resultDate" class="small" value="<%=resultDate %>" />
				</td>
			</tr>
		</tbody>
	</table>
</form>
