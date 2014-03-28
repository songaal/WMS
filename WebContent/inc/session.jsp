<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@page import="java.util.*"%>
<%@page import="org.slf4j.*"%>
<%!

	String AUTH_USER = "U"; //일반사용자.
	String AUTH_ADMIN = "A"; //관리자

	String PAGE_ROOT = "/WMS/";
	String PAGE_COMMON = "/WMS/common/";
	String PAGE_SALES = "/WMS/sales/";
	String PAGE_CLIENT = "/WMS/client/";
	String PAGE_SCHEDULE = "/WMS/schedule/";
	String PAGE_PROJECT = "/WMS/project/";
	String PAGE_TODO = "/WMS/todo/";
	String PAGE_MESSAGE = "/WMS/message/";
	String PAGE_APPROVAL = "/WMS/approval/";
	String PAGE_SETTINGS = "/WMS/settings/";
	String PAGE_USERSETTING = "/WMS/usersetting/";
	String PAGE_TASK = "/WMS/task/";
	String PAGE_ATTACH = "/WMS/attach/";
	
	Logger logger = LoggerFactory.getLogger("WMS");
	
	public void gotoMain(HttpServletResponse response){
		try{
			response.sendRedirect(PAGE_ROOT);
		}catch(Exception e){
			logger.error("", e);
		}
	}
	
	
%>
<%
	request.setCharacterEncoding("utf-8");
	String pageFrom = request.getHeader("referer");
	//등록된 사용자여부 세션처리.
	UserInfo myUserInfo= (UserInfo)session.getAttribute("WMS_MEMBER");
	boolean isLogin = (myUserInfo != null);
	boolean isPageAllowed = false;
	
	String thisPageName = WebUtil.getPageName(request.getRequestURL().toString());
	if(thisPageName == null){
		thisPageName = "index.jsp";
	}
	//out.println(thisPageName);
	Set<String> allowedList = new HashSet<String>();
	allowedList.add(PAGE_ROOT);//메인페이지는 로긴없이 접근가능하다.
	
	if(myUserInfo != null){
		//공통
		allowedList.add(PAGE_COMMON);
		allowedList.add(PAGE_CLIENT);
		allowedList.add(PAGE_MESSAGE);
		allowedList.add(PAGE_SCHEDULE);
		allowedList.add(PAGE_PROJECT);
		allowedList.add(PAGE_TODO);
		allowedList.add(PAGE_USERSETTING);
		allowedList.add(PAGE_APPROVAL);
		allowedList.add(PAGE_SALES);
		allowedList.add(PAGE_TASK);
		allowedList.add(PAGE_ATTACH);
		
		if(myUserInfo.userType.contains(AUTH_USER)){
			//일반사용자 user
		}
		
		if(myUserInfo.userType.contains(AUTH_ADMIN)){
			//관리자. admin
			allowedList.add(PAGE_SETTINGS);
		}
		
		//out.println(" userType >> "+myUserInfo.userType);
	}
	
	if(isLogin && myUserInfo.userType.equals("A")){
		//관리자는 모두 허용.
		isPageAllowed = true;
	}
	String myUrl = request.getRequestURL().toString();
	String myUrlPath = WebUtil.getLastURLPath(myUrl);
	//out.println("myUrlPath >>"+myUrlPath);
	
	if(allowedList.contains(myUrlPath)){
		isPageAllowed = true;
		//out.println(" 허용!");
	}else{
		//out.println(" 권한부족! ");
	}
	
	
	if(!isPageAllowed){
		//메인페이지로 이동시킨다.
		response.sendRedirect(PAGE_ROOT+"?redirectUrl="+request.getRequestURL().toString());
		return;
	}
%>
