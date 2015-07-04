<%@ page contentType="text/html; charset=UTF-8"%>
<%@include file="../inc/header.jsp" %>
<%@page import="java.util.*" %>
<%@page import="co.fastcat.wms.*" %>
<script>
$(document).ready(function(){
	$("#addForm").validate();
});

function addUser(){
	if($("#addForm").valid()){
		$("#addForm").submit();		
	}
}
</script>

</head>
<body>
<h1>직원추가</h1>
<form class="addForm" id="addForm" method="post" action="userDo.jsp">
<input type="hidden" name="cmd" value="add"/>
 <fieldset>
   <legend>직원정보</legend>
   <p>
     <label for="userName">이름</label>
     <em>*</em><input id="userName" name="userName" size="10" class="required" minlength="2" />
   </p>
   <p>
     <label for="userId">이메일아이디</label>
     <em>*</em><input id="userId" name="userId" size="10" class="required" minlength="5" />
   </p>
   <p>
     <label for="admin">관리자여부</label>
     <em>  </em><input type="checkbox" id="admin" name="admin" value="" />
   </p>
   <p>
     <label for="part">소속팀</label>
     <em>*</em><input id="part" name="part" size="15" class="required"></input>
   </p>
   <p>
     <label for="title">직함</label>
     <em>*</em><input id="title" name="title" size="10" class="required"></input>
   </p>
   <p>
     <label for="enterDate">입사일</label>
     <input id="enterDate" name="enterDate" size="10"></input>
   </p>
   <p>
     <input class="submit" type="button" value="확인" onClick="javascript:addUser()"/>
   </p>
 </fieldset>
 </form>
 
<%@include file="../inc/footer.jsp" %>