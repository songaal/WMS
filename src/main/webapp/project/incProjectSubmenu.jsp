<%@page import="java.util.regex.Pattern"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
String uri = request.getRequestURI();
String pageId = null;
if(uri!=null) {
	String[] uriArr = uri.split("/");
	if(uriArr.length > 3) {
		if("project".equals(uriArr[2])) {
			pageId = uriArr[3];
		}
	}
}
%>
<div class="btn-group pagination-centered">
	<a class="btn btn-small <%="info.jsp".equals(pageId)?"active":"" %>" href="info.jsp?pid=<%=pid%>&status=<%=status%>">요약</a>
	<a class="btn btn-small <%="environment.jsp".equals(pageId)?"active":"" %>" href="environment.jsp?pid=<%=pid%>&status=<%=status%>">환경정보</a>
	<a class="btn btn-small <%="development.jsp".equals(pageId)?"active":"" %>" href="development.jsp?pid=<%=pid%>&status=<%=status%>">구축내역</a>
	<%--<a class="btn btn-small <%="request.jsp".equals(pageId)?"active":"" %>" href="request.jsp?pid=<%=pid%>&status=<%=status%>">요청내용</a>--%>
	<%--<a class="btn btn-small <%="work.jsp".equals(pageId)?"active":"" %>" href="work.jsp?pid=<%=pid%>&status=<%=status%>">작업내역</a>--%>
	<a class="btn btn-small <%="etcLog.jsp".equals(pageId)?"active":"" %>" href="etcLog.jsp?pid=<%=pid%>&status=<%=status%>">기타</a>
	<a class="btn btn-small <%="meetings.jsp".equals(pageId)?"active":"" %>" href="meetings.jsp?pid=<%=pid%>&status=<%=status%>">회의록</a>
	<a class="btn btn-small <%="maint.jsp".equals(pageId)?"active":"" %>" href="maint.jsp?pid=<%=pid%>&status=<%=status%>">정기점검</a>
	<a class="btn btn-small <%="history.jsp".equals(pageId)?"active":"" %>" href="history.jsp?pid=<%=pid%>&status=<%=status%>">히스토리</a>
	<%--<a class="btn btn-small <%="attach.jsp".equals(pageId)?"active":"" %>" href="attach.jsp?pid=<%=pid%>&status=<%=status%>">파일</a>--%>
</div>