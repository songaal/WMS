<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="java.util.*"%>
<%
	String userId = WebUtil.getValue(request.getParameter("userId"));
	String passwd = WebUtil.getValue(request.getParameter("passwd"));
	String action = request.getParameter("action");
	String redirectUrl = request.getParameter("redirectUrl");
	if(redirectUrl != null){
		String pageName = WebUtil.getPageName(redirectUrl);
		if(pageName != null && pageName.startsWith("do")) {
			//do 페이지에서 세션을 잃었다면 다시 리다이렉트하지 않는다. post일 경우가 많고, 단순 view페이지의 경우에만 redirect시켜준다.
			redirectUrl = null;
		}
	}
	//패스워드가 존재할때에만 암호화 비교한다.
	//초기에 생성시에는 없다.
	if("login".equals(action)){
		UserDAO userDAO = new UserDAO();
		UserInfo userInfo = userDAO.login(userId, passwd);
		if(userInfo != null){
			//세션처리.
			session.setMaxInactiveInterval(8 * 3600); //8시간 동안 아무것도 안하면 세션 소멸
			session.setAttribute("WMS_MEMBER", userInfo);
			out.println("로긴성공 >> "+userInfo.serialId+", redirectUrl ="+redirectUrl);
			if(redirectUrl != null){
				response.sendRedirect(redirectUrl);
				return;
			}
			return;
		}else{
			//실패
			if(redirectUrl != null){
				response.sendRedirect("/WMS/?redirectUrl="+redirectUrl);
				return;
			}
		}
	}else if("logout".equals(action)){
		session.removeAttribute("WMS_MEMBER");
	}
	
	response.sendRedirect("/WMS/");
	
%>



