<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@include file="../inc/session.jsp"%>
<%
	request.setCharacterEncoding("utf-8");
	String action = request.getParameter("action");

	if("select".equals(action)){
		MemoDAO memoDAO = new MemoDAO();
		MemoInfo info = memoDAO.selectOne(myUserInfo.serialId);
		if(info != null){
			out.println(info.content);
		}
		return;
	}else if("update".equals(action)){
		if(!request.getMethod().equalsIgnoreCase("POST")){
			out.println("{\"result\": false}");
			return;
		}
		//String id = request.getParameter("id");
		Map<String, String[]> paramMap = request.getParameterMap();
		MemoInfo memoInfo = new MemoInfo();
		memoInfo.map(paramMap);
		MemoDAO memoDAO = new MemoDAO();
		memoInfo.userSID = myUserInfo.serialId;
		
		/* if(id.equals("")){
			//생성.
			String key = memoDAO.create(memoInfo);
			if(key != null){
				//성공. key 리턴필요.
				out.println("{\"result\": true, \"create\": true, \"id\": \""+key+"\"}");
			}else{
				out.println("{\"result\": false}");
			}
			
		}else{
			//업데이트
			
			if(memoDAO.modify(memoInfo) > 0){
				out.println("{\"result\": true, \"create\": false}");
			}else{
				out.println("{\"result\": false}");
				
			}
		} */
		
		if(memoDAO.update(memoInfo)){
			out.println("{\"result\": true}");
		}else{
			//생성.
			String key = memoDAO.create(memoInfo);
			if(key != null){
				//성공. key 리턴필요.
				out.println("{\"result\": true}");
			}else{
				out.println("{\"result\": false}");
			}
			
		}
		
		return;
	}
%>


