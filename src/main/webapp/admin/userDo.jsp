<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*" %>
<%@page import="com.websqrd.company.wms.*" %>
<%@page import="org.slf4j.*" %>
<%! 
	Logger logger = LoggerFactory.getLogger("jsp");
%>
<%
	request.setCharacterEncoding("utf-8");
	String cmd = request.getParameter("cmd");

	logger.debug("cmd = {}, refer = {}", cmd, request.getHeader("referer"));
	
	if(cmd.equalsIgnoreCase("add")){
		String referer = request.getHeader("referer");
		//TODO
		/* UserInfoHandler userInfoHandler = new UserInfoHandler();
		Map<String, String[]> valueMap = request.getParameterMap();
		UserInfo userInfo = new UserInfo();
		userInfo.readFrom(valueMap);
		logger.debug("name >> {}", valueMap.get("userName")[0]);
		
		userInfoHandler.insert(userInfo);
		
		response.sendRedirect(referer); */
	}else if(cmd.equalsIgnoreCase("modify")){
		
		
	}else if(cmd.equalsIgnoreCase("delete")){
		
		
	}
%>