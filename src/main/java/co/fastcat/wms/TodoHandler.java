//package co.fastcat.wms;
//
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.sql.Statement;
//import java.sql.Timestamp;
//import java.util.ArrayList;
//import java.util.List;
//
//public class TodoHandler extends DAOHandler{
//	
//	private String selectAllSQL = "select id, title, content, regDate, status, startDate, endDate, parentTask from Todo";
//	private String insertSQL = "insert Todo (title, content, regDate, status, startDate, endDate, parentTask) values (?,?,?,?,?,?,?)";
//	private String updateSQL = "update Todo set title=?, content=?, regDate=?, status=?, startDate=?, endDate=?, parentTask=? where id = ?";
//	
//	public boolean insert(Todo todo){
//		try{
//			PreparedStatement pstmt = conn.prepareStatement(insertSQL);
//			int columnIndex = 1;
//			pstmt.setString(columnIndex++, todo.title);
//			pstmt.setString(columnIndex++, todo.content);
//			pstmt.setTimestamp(columnIndex++, new Timestamp(System.currentTimeMillis()));
//			pstmt.setString(columnIndex++, todo.status);
//			pstmt.setTimestamp(columnIndex++, todo.startDate);
//			pstmt.setTimestamp(columnIndex++, todo.endDate);
//			pstmt.setInt(columnIndex++, todo.parentTask);
//			return pstmt.executeUpdate() > 0;
//		} catch (SQLException e) {
//			logger.error("", e);
//		}
//		return false;
//	}
//	
//	public boolean update(Todo todo){
//		try{
//			PreparedStatement pstmt = conn.prepareStatement(updateSQL);
//			int columnIndex = 1;
//			pstmt.setString(columnIndex++, todo.title);
//			pstmt.setString(columnIndex++, todo.content);
//			pstmt.setTimestamp(columnIndex++, todo.regDate);
//			pstmt.setString(columnIndex++, todo.status);
//			pstmt.setTimestamp(columnIndex++, todo.startDate);
//			pstmt.setTimestamp(columnIndex++, todo.endDate);
//			pstmt.setInt(columnIndex++, todo.parentTask);
//			pstmt.setInt(columnIndex++, todo.id);
//			return pstmt.executeUpdate() > 0;
//		} catch (SQLException e) {
//			logger.error("", e);
//		}
//		return false;
//	}
//	
//	public List<Todo> selectAll(){
//		List<Todo> list = new ArrayList<Todo>();
//		
//		try {
//			Statement stmt = conn.createStatement();
//			ResultSet rs = stmt.executeQuery(selectAllSQL);
//			while(rs.next()){
//				Todo todo = new Todo();
//				todo.readFrom(rs);
//				list.add(todo);
//			}
//		
//		} catch (SQLException e) {
//			logger.error("", e);
//		}
//		return list;
//	}
//	
//	public Todo select(int id){
//		try {
//			String selectSQL = selectAllSQL + " where userid = ?";
//			Statement stmt = conn.createStatement();
//			ResultSet rs = stmt.executeQuery(selectSQL);
//			if(rs.next()){
//				Todo todo = new Todo();
//				todo.readFrom(rs);
//				return todo;
//			}
//		
//		} catch (SQLException e) {
//			logger.error("", e);
//		}
//		return null;
//	}
//	
//
//	
//}
