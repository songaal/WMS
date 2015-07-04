<%@page import="java.sql.Timestamp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.io.*"%>
<%@page import="co.fastcat.wms.*"%>
<%@page import="co.fastcat.wms.dao.*"%>
<%@page import="co.fastcat.wms.bean.*"%>
<%@page import="co.fastcat.wms.webpage.*"%>
<%@ page import="co.fastcat.wms.bean.FileInfo" %>
<%@ page import="co.fastcat.wms.dao.FileInfoDAO" %>
<%@include file="../inc/session.jsp"%>
<%
	try {
		request.setCharacterEncoding("UTF-8");

		Map<String, String[]> paramMap = request.getParameterMap();
		Iterator itr = paramMap.keySet().iterator();

		while (itr.hasNext()) {
			String key = (String) itr.next();
			String[] value = paramMap.get(key);
			if (value != null) {
				//out.print(key + ":");
				for (int i = 0; i < value.length; i++) {
					//out.print(value[i]);
					//out.print(",");
				}
				//out.println();
			}
		}

		if (paramMap.size() == 0)
			out.println("there is no parameter");

		String id = request.getParameter("fileInfoId");
		String action = request.getParameter("action");

		if (action.equals("delete")) {
			FileInfoDAO fDAO = new FileInfoDAO();
			FileInfo info = fDAO.select(id);
			if (info != null) {
				fDAO.delete(info);

				String projectId = info.projectId;
				String storeFileName = info.storeName;
				if (projectId.equals("-1"))
					projectId = "etc";

				String serverHome = getServletContext().getRealPath("/attachFile");
				String storeFilePath = serverHome + "/" + projectId + "/" + storeFileName;
				File storeFile = new File(storeFilePath);
				if (storeFile.exists()) {
					storeFile.delete();
					out.clear();
					out.println("{\"result\":0, \"msg\":\" delete complete \"}");
					return;
				} else {
					out.println("{\"result\":0, \"msg\":\" " + storeFilePath + " is not exists \"}");
					return;
				}
			} else {
				out.clear();
				out.println("{\"result\":1, \"errmsg\":\" there is no fileInfo \"}");
				return;
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
		out.clear();
		out.println("{\"result\":1, \"errmsg\":\" there is Error \"}");
		return;
	}
%>




