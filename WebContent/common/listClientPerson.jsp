<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@include file="../inc/session.jsp"%>
<%
	String cid = request.getParameter("cid");
	ClientPersonDAO dao = new ClientPersonDAO();
	List<DAOBean> list = dao.selectByCompany(cid);
%>
[
<%
	for(int i=0; list != null && i< list.size(); i++){
		ClientPersonInfo2 info = (ClientPersonInfo2) list.get(i);
		
%>
		{"name": "<%=info.personName %>", "value": "<%=info.id %>"}
<%	
		if(i < list.size() - 1){
			out.println(",");	
		}
	}
%>
]


