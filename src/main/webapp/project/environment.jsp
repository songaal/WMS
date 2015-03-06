<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>

<%@include file="../inc/header.jsp"%>

<%
	String status = WebUtil.getValue(request.getParameter("status"), ProjectInfo.STATUS_ONGOING);
	String pid = request.getParameter("pid");
	String logType = String.valueOf(ProjectLogInfo.LOG_ENVIRONMENT);
	ProjectLogDAO projectLogDAO = new ProjectLogDAO();
	ProjectLogInfo projectLog = projectLogDAO.get(pid, logType);
	
	String logText = "";
	
	if(projectLog!=null) {
		logText = projectLog.logText;
	}
%>

<div class="container ">
	<div class="row">
		<div class="span12">
		<h2 id="body-copy">프로젝트</h2>
		</div>
		<br>
		<!-- 왼쪽 프로젝트 리스트 -->
		<%@include file="incProjectLeft.jsp"%>

		<!-- 메인 내용 -->
		<div class="span9">
			<%@include file="incProjectSubmenu.jsp" %>			
			<% if (projectLog!=null) {%>
			<div id="previewArea">
				<p>
					<button class="btn btn-small pull-right" onclick="toggleArea('previewArea','editArea')">수정</button>
				</p>
				<br/>
				<br/>
				<div id="">
					<div class="logtext">
					<%=logText %>
					</div>
				</div>
			</div>
			<% } %>
			<div id="editArea" style="display:<%=projectLog!=null?"none":""%>">
				<form id="environmentForm" action="writeLog.jsp" method="POST">
					<p>
						<button class="btn btn-info btn-small pull-right">저장</button>
					</p>
					<br/>
					<br/>
					<input type="hidden" name="action" value="<%=projectLog==null?"writeLog":"updateLog" %>"/>
					<input type="hidden" name="pid" value="<%=projectLog!=null?projectLog.pid:"" %>"/>
					<input type="hidden" name="projectId" value="<%=pid%>"/>
					<input type="hidden" name="type" value="<%=logType%>"/>
					<textarea style="width:100%; height:500px" id="logText" name="logText"><%=logText %></textarea>
					<br/>
				</form>
			</div>
			
			<div id="sampleContent">
			<link href="/WMS/assets/css/bootstrap.css" rel="stylesheet">
			<link href="/WMS/assets/css/bootstrap-responsive.css" rel="stylesheet">
			<br/>
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="10%"></col>
					<col width="30%"></col>
					<col width="60%"></col>
				</colgroup>
				<tbody>
					<tr><th rowspan="9"><br/>검<br/>색<br/>서<br/>버</th>
						<td>OS</td><td>&nbsp;</td></tr>
					<tr><td>CPU, MEM</td><td>&nbsp;</td></tr>					
					<tr><td>IP</td><td>&nbsp;</td></tr>
					<tr><td>PORT</td><td>&nbsp;</td></tr>
					<tr><td>계정</td><td>&nbsp;</td></tr>
					<tr><td>접속방식</td><td>&nbsp;</td></tr>
					<tr><td>방화벽정보</td><td>&nbsp;</td></tr>
					<tr><td>터널링정보</td><td>&nbsp;</td></tr>
				</tbody>
			</table>
					
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="10%"></col>
					<col width="30%"></col>
					<col width="60%"></col>
				</colgroup>
				<tbody>
					<tr><th rowspan="12"><br/>검<br/>색<br/>엔<br/>진<br/></th>
						<td>관리도구 URL</td><td>&nbsp;</td></tr>
					<tr><td>관리도구 계정/암호</td><td>&nbsp;</td></tr>
					<tr><td>설치위치</td><td>&nbsp;</td></tr>
					<tr><td>검색엔진버전</td><td>&nbsp;</td></tr>					
				</tbody>
			</table>
			
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="10%"></col>
					<col width="30%"></col>
					<col width="60%"></col>
				</colgroup>
				<tbody>
					<tr><th rowspan="3"><br/>D<br/>B<br/></th>
					<tr><td>JDBC URL</td><td>&nbsp;</td></tr>					
					<tr><td>계정</td><td>&nbsp;</td></tr>										
				</tbody>
			</table>
					
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="10%"></col>
					<col width="30%"></col>
					<col width="60%"></col>
				</colgroup>
				<tbody>
					<tr><th rowspan="5"><br/>웹<br/>서<br/>버<br/></th>
						<td>종류</td><td>&nbsp;</td></tr>
					<tr><td>IP</td><td>&nbsp;</td></tr>
					<tr><td>PORT</td><td>&nbsp;</td></tr>
					<tr><td>계정</td><td>&nbsp;</td></tr>
					<tr><td>페이지위치</td><td>&nbsp;</td></tr>					
					</tr>
				</tbody>
			</table>
			
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="10%"></col>
					<col width="30%"></col>
					<col width="60%"></col>
				</colgroup>
				<tbody>
					<tr><th rowspan="9"><br/>컬<br/>렉<br/>션<br/></th>
						<td>이름</td><td>&nbsp;</td></tr>
					<tr><td>데이터소스정보</td><td>&nbsp;</td></tr>
					<tr><td>첨부파일문서위치</td><td>&nbsp;</td></tr>
					<tr><td>전체색인주기</td><td>&nbsp;</td></tr>
					<tr><td>증분색인주기</td><td>&nbsp;</td></tr>					
				</tbody>
			</table>
			
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="10%"></col>
					<col width="30%"></col>
					<col width="60%"></col>
				</colgroup>
				<tbody>
					<tr><th rowspan="3"><br/>검색<br/>페이지<br/></th>
						<td>접속 URL</td><td>&nbsp;</td></tr>
					<tr><td>계정</td><td>&nbsp;</td></tr>
					<tr><td>페이지구성설명</td><td>&nbsp;</td></tr>					
				</tbody>
			</table>
			
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="10%"></col>					
					<col width="60%"></col>
				</colgroup>
				<tbody>
					<tr><th>기타정보</th>
						<td>&nbsp;</td></tr>										
				</tbody>
			</table>
			
			<table class="table table-bordered table-condensed">
				<colgroup>
					<col width="10%"></col>					
					<col width="60%"></col>
				</colgroup>
				<tbody>
					<tr><th>주의사항</th>
						<td>&nbsp;</td></tr>										
				</tbody>
			</table>
			</div>
		</div>
	</div>
</div>

<%@include file="../inc/footer.jsp"%>



