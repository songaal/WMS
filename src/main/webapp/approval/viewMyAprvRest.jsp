<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
<%@ page import="co.fastcat.wms.dao.RestDataDAO" %>
<%@ page import="co.fastcat.wms.dao.ApprovalDAO" %>
<%@ page import="co.fastcat.wms.webpage.BusinessUtil" %>
<%@ page import="co.fastcat.wms.bean.RestData2" %>
<%@ page import="co.fastcat.wms.bean.ApprovalInfo2" %>
<%@ page import="co.fastcat.wms.webpage.WebUtil" %>
<%@include file="../inc/session.jsp"%>
<%
	RestDataDAO dao = new RestDataDAO();
	ApprovalDAO approvalDAO = new ApprovalDAO();
	
	String id = request.getParameter("id");
	String aprvId = request.getParameter("aprvId");
	String showType = WebUtil.getValue(request.getParameter("showType"), "notYet");
	boolean isDone = showType.equals("done");//완료인지.
	RestData2 restData = dao.select(aprvId);
	ApprovalInfo2 approvalInfo = approvalDAO.select(id);
	Calendar cal = Calendar.getInstance();
	cal.setTime(restData.applyDate);
%>
<table class="table table-hover table-condensed table-striped">
	<colgroup>
		<col width="160">
		<col width="*">
	</colgroup>
	<tbody>
		<tr>
			<th>결재구분</th>
			<td><%=BusinessUtil.getRestTypeName(restData.type) %></td>
		</tr>
		<tr>
			<th>대상자</th>
			<td><%=restData.userName %>&nbsp;</td>
		</tr>
		<tr>
			<th>휴가종류</th>
			<td><%=BusinessUtil.getRestCategoryName(restData.category) %>&nbsp;</td>
		</tr>
		<tr>
			<th>적용일자</th>
			<td><%=WebUtil.toDateString(restData.applyDate) %> (<%=WebUtil.getYoilString(cal) %>)&nbsp;</td>
		</tr>
		<tr>
			<th>기간</th>
			<td><%=restData.amount %>일</td>
		</tr>
		<tr>
			<th>내용</th>
			<td><%=WebUtil.getMultiLineValue(restData.memo) %>&nbsp;</td>
		</tr>
		<tr>
		<%
		for(int k=0; k < approvalInfo.resUserCount; k++){
			java.sql.Timestamp aprvTime = (k == 0 ? approvalInfo.resDatetime1 : (k == 1 ? approvalInfo.resDatetime2 : approvalInfo.resDatetime3));
			String resResult = (k == 0 ? approvalInfo.resResult1 : (k == 1 ? approvalInfo.resResult2 : approvalInfo.resResult3));
			String resultMemo = (k == 0 ? approvalInfo.resultMemo1 : (k == 1 ? approvalInfo.resultMemo2 : approvalInfo.resultMemo3));
			String label = (k == approvalInfo.resUserCount - 1) ? "최종" : (k+1)+"단계 ";
		%>
			<th><%=label %>결재자</th>
			<td><%=WebUtil.getValue(k == 0 ? approvalInfo.resUserName1 : (k == 1 ? approvalInfo.resUserName2 : approvalInfo.resUserName3)) %></td>
		</tr>
		<tr>
			<th><%=label %>결재시각</th>
			<td><%=WebUtil.toDateTimeString(aprvTime) %>&nbsp;</td>
		</tr>
		<tr>
			<th><%=label %>결재결과</th>
			<td><%=BusinessUtil.getApprovalResultDisplayName(resResult) %>&nbsp;</td>
		</tr>
		<tr>
			<th><%=label %>결재자의견</th>
			<td><%=WebUtil.getValue(resultMemo) %>&nbsp;</td>
		</tr>
		<%
		}
		%>
	</tbody>
</table>
