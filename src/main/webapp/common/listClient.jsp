<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.ClientInfo" %>
<%@ page import="co.fastcat.wms.dao.ClientDAO" %>
<%@include file="../inc/session.jsp"%>
<%
	String type = request.getParameter("type");
	ClientDAO dao = new ClientDAO();
	List<ClientInfo> list = null;
	if("A".equals(type)){
		list = dao.selectA();
	}else if("B".equals(type)){
		list = dao.selectB();
	}
%>
[
<%
	for(int i=0; list != null && i< list.size(); i++){
		ClientInfo info = list.get(i);
		
%>
		{"name": "<%=info.clientName %>", "value": "<%=info.cid %>"}
<%	
		if(i < list.size() - 1){
			out.println(",");	
		}
	}
%>
]


