<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.ClientPersonInfo2" %>
<%@ page import="co.fastcat.wms.dao.ClientPersonDAO" %>
<%@ page import="co.fastcat.wms.bean.DAOBean" %>
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


