<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.dao.ApprovalSettingDAO" %>
<%@ page import="co.fastcat.wms.bean.ApprovalSetting" %>
<%@include file="../inc/session.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	ApprovalSettingDAO dao = new ApprovalSettingDAO();
	
	String action = request.getParameter("action");
	String type = request.getParameter("type");
	ApprovalSetting setting = new ApprovalSetting();
	Map<String, String[]> paramMap = request.getParameterMap();
	setting.map(paramMap);
	out.println("action = "+action);
	
	if("update".equals(action)){
		if(dao.modify(setting) == 0){
			//업데이트할 데이터가 없으면 생성.
			String key = dao.create(setting);
		}
		
	}
	
	response.sendRedirect("approval.jsp?type="+type);
	
%>




