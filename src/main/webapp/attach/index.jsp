<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.ProjectInfo" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>
<%@ page import="co.fastcat.wms.bean.FileInfo2" %>
<%@ page import="co.fastcat.wms.dao.ProjectDAO" %>
<%@ page import="co.fastcat.wms.dao.FileInfoDAO" %>

<%@include file="../inc/header.jsp"%>
<link href="/WMS/assets/css/bootstrap-fileupload.css" rel="stylesheet">
<%
	FileInfoDAO fDAO = new FileInfoDAO();
	List<DAOBean> list = fDAO.selectUser(myUserInfo.serialId);
	
	ProjectDAO pDAO = new ProjectDAO();
	List<ProjectInfo> pList = pDAO.selectAll();
%>


<div class="container">
	<div class="row">
		<div>
			<h2 id="body-copy">파일 리스트</h2>
		</div>		
			
		<div class="btn-toolbar">
		<div class="btn-group">
			<button class="btn btn-info" href="#fileInsertModal" role="button" data-toggle="modal">파일 추가</button>
		</div>
		</div>

		<table class="table table-bordered table-hover table-condensed fc-border-separate" style="margine-left: 0px">
			<thead>
				<tr>
					<th style="text-align: center;">순번</th>
					<th style="text-align: center;">사용자</th>
					<th style="text-align: center;">프로젝트</th>
					<th style="text-align: center;">파일명</th>
					<th style="text-align: center;">등록 날짜</th>
					<th style="text-align: center;">설명</th>
					<th style="text-align: center;">tool</th>					
				</tr>
			</thead>
			<%
			if ( list != null ) 
			{
				int idx = 1;
				for ( int i = 0 ; i < list.size() ; i ++, idx++ )
				{
					FileInfo2 fInfo = (FileInfo2)list.get(i);
					%>
					<tbody>
						<tr>
						<th><%=idx%></th>
						<td><%=fInfo.userName%></td>
						<td><%=fInfo.projectName == null ? "기타":fInfo.projectName %></td>
						<td><a href="/WMS/download?id=<%=fInfo.id%>"><%=fInfo.fileName%></a></td>
						<td><%=fInfo.regdate%></td>
						<td><%=fInfo.desc%></td>
						<td>						
							<button class="btn btn-mini btn-danger" role="button" onClick="javascript:deleteFileInfo('<%=fInfo.id %>')">삭제</button>
							<button class="btn btn-mini btn-info" role="button" onClick="javascript:copyUrl('<%=fInfo.id%>')">url복사</button>
						</td>
						</tr>
					</tbody>
					<%
				}
			}
			%>
			
		</table>

	</div>
	<!-- row -->
</div>
<%@include file="../inc/footer.jsp"%>



<!--// 파일추가폼 -->
	<div class="modal hide" id="fileInsertModal" tabindex="-1" role="dialog" aria-labelledby="fileInsertModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">X</button>
			<h3 id="fileinsertModalLabel">파일 추가</h3>
		</div>
		<div class="modal-body" style="padding-bottom: 0">
			<form id="file_upload2" class="myform" name="file_upload2" 	method="post" action="fileInsertService" enctype="multipart/form-data" encoding="multipart/form-data">				
				<input type="hidden" name="userid" value = "<%=myUserInfo.serialId%>" >
				<table class="table table-hover table-condensed table-striped"	style="margin-bottom: 5px;">
					<colgroup>
						<col width="160">
						<col width="">
					</colgroup>
					<tbody>
						<tr>
							<th>사용자</th>
							<td><%=myUserInfo.userName%></td>
						</tr>
						<tr>
							<th>프로젝트</th>
							<td>
								<select name="projectSelect" >
								<option value="-1" selected>:::선택:::</option>
								<%
								if ( pList != null )
								{
									for ( int i = 0 ; i < pList.size() ; i ++ )
										{
										ProjectInfo pInfo = pList.get(i);										
									%>
									<option value="<%=pInfo.pid%>"><%=pInfo.name%></option>
									<%
										}
								}
								%>
								</select>
							</td>
						</tr>
						<tr>
							<th>설명</th>
							<td><textarea name="desc" style="width : 300px"></textarea></td>
						</tr>
						
						<tr>							
							<th>파일</th>
							<td>
								<div class="fileupload fileupload-new"
									data-provides="fileupload">
									<div class="input-append">
										<div class="uneditable-input span3">
											<i class="icon-file fileupload-exists"></i> <span class="fileupload-preview"></span>
										</div>
										<span class="btn btn-file"> 
										<span class="fileupload-new">Select file</span> 
										<span class="fileupload-exists">Change</span> 
										<input name="file" 	id="file" type="file" />
										</span> <a href="#" class="btn fileupload-exists" data-dismiss="fileupload">Remove</a>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<div class="modal-footer">
			<button class="btn btn-primary" onclick="javascript:uploadFile()">저장</button>
			<button class="btn" data-dismiss="modal" aria-hidden="true" onClick="$('#fileInsertModal').modal('hide')">닫기</button>
		</div>

<script type="text/javascript" src="/WMS/assets/js/bootstrap-fileupload.js"></script>
<script type="text/javascript" src="/WMS/assets/js/jquery.form.js"></script>
<script type="text/javascript" src="/WMS/assets/js/file.js"></script>
<script>
selectUser = "<%=myUserInfo.serialId%>";	
</script>


