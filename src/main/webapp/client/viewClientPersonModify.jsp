<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.bean.ClientInfo" %>
<%@ page import="co.fastcat.wms.bean.ClientPersonInfo" %>
<%@ page import="co.fastcat.wms.dao.ClientDAO" %>
<%@ page import="co.fastcat.wms.dao.ClientPersonDAO" %>
<%@include file="../inc/session.jsp"%>
<script src="/WMS/assets/js/jquery-1.8.2.js"></script>
<script src="/WMS/assets/js/jquery.validate.min.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<script src="/WMS/assets/js/bootstrap.js"></script>
<script src="/WMS/assets/js/bootstrap-datepicker.js"></script>
<script src="/WMS/assets/js/bootbox.js"></script>
<script src="/WMS/assets/js/wms.js"></script>
<script src="/WMS/assets/ckeditor2/ckeditor.js"></script>
<script src="/WMS/assets/js/client.js" type="text/javascript"></script>
<script src="/WMS/assets/js/jquery.validate.min.js" type="text/javascript"></script>
<%
	ClientPersonDAO dao = new ClientPersonDAO();
	List<ClientPersonInfo> list = dao.select();
	
	ClientDAO clientDAO = new ClientDAO();
	List<ClientInfo> clientList = clientDAO.select();

	String id = request.getParameter("id");
	
	ClientPersonInfo info = dao.select2(id);
	
	
%>
<form id="updateForm" method="post" action="doClientPerson.jsp">
	<input type="hidden" name="action" /> 
	<input type="hidden" name="id" value="<%=id%>" />
	<table class="table table-hover table-condensed table-striped">
		<colgroup>
			<col width="160">
			<col width="">
		</colgroup>
		<tbody>
			<tr>
				<th>이름 직함</th>
				<td><input type="text" name="personName" class="required" value="<%=info.personName%>"></td>
			</tr>
			<tr>
				<th>회사</th>
				<td>
				<select name="cid">
					<option> :: 선택 :: </option>
					<%
					for(int i=0; i<clientList.size(); i++){
						ClientInfo cinfo = clientList.get(i);
						String classStr = "";
						if(info.cid == cinfo.cid){
							classStr = "selected";
						}
						
					%>
					<option value="<%=cinfo.cid %>" <%=classStr %>><%=cinfo.clientName %></option>
					<%
					}
					%>
				</select>
				</td>
			</tr>
			<tr>
				<th>전화번호</th>
				<td><input type="text" name="phone" class="required" value="<%=info.phone%>" /></td>
			</tr>
			<tr>
				<th>핸드폰</th>
				<td><input type="text" name="cellPhone" class="required" value="<%=info.cellPhone%>" /></td>
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" name="email"class="required"  value="<%=info.email%>" /></td>
			</tr>
			<tr>
				<th>메모</th>
				<td><textarea class="mid" name="memo"><%=info.memo%></textarea></td>
			</tr>
		</tbody>
	</table>
</form>

