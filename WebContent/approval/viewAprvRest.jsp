<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="org.slf4j.*"%>
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
		//완료목록이라면 모든 결재라인을 보여주고, 결재대상이라면 내 하위까지만 보여준다.
		int limit = isDone ? approvalInfo.resUserCount : approvalInfo.resUserStep;
		for(int k=0; k < limit; k++){
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
		
		<%
		if(!isDone){//완료목록에서는 보여주지 않는다.
		%>
		<tr>
			<th>의견</th>
			<td><input type="text" class="input-xlarge" id="memo_<%=approvalInfo.id %>"/></td>
		</tr>
		<tr>
			<th>결재</th>
			<td><button class="btn btn-small btn-success" onClick="approvalRequest(<%=approvalInfo.id %>, '<%=ApprovalInfo.TYPE_REST %>')">승인</button>
			<button class="btn btn-small btn-danger" onClick="rejectRequest(<%=approvalInfo.id %>, '<%=ApprovalInfo.TYPE_REST %>')">반려</button></td>
		</tr>
		<%
		}
		%>
	</tbody>
</table>
