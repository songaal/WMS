//package com.websqrd.company.wms;
//
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.sql.Statement;
//import java.util.ArrayList;
//import java.util.List;
//
//public class UserInfoHandler extends DAOHandler{
//	
//	private String selectAllSQL = "select userid, username, admin, part, title, enterDate, avgGrade from UserInfo";
//	private String insertSQL = "insert UserInfo (userid, username, admin, part, title, enterDate, avgGrade) values (?,?,?,?,?,?,?)";
//	private String updateSQL = "update UserInfo set username=?, admin=?, part=?, title=?, enterDate=?, avgGrade=? where userid = ?";
//	
//	public boolean insert(UserInfo userInfo){
//		try{
//			PreparedStatement pstmt = conn.prepareStatement(insertSQL);
//			int columnIndex = 1;
//			pstmt.setString(columnIndex++, userInfo.userId);
//			pstmt.setString(columnIndex++, userInfo.userName);
//			pstmt.setString(columnIndex++, userInfo.userType);
//			pstmt.setString(columnIndex++, userInfo.part);
//			pstmt.setString(columnIndex++, userInfo.title);
//			pstmt.setTimestamp(columnIndex++, userInfo.enterDate);
//			pstmt.setString(columnIndex++, userInfo.avgGrade+"");
//			return pstmt.executeUpdate() > 0;
//		} catch (SQLException e) {
//			logger.error("", e);
//		}
//		return false;
//	}
//	
//	public boolean update(UserInfo userInfo){
//		try{
//			PreparedStatement pstmt = conn.prepareStatement(updateSQL);
//			int columnIndex = 1;
//			pstmt.setString(columnIndex++, userInfo.userName);
//			pstmt.setString(columnIndex++, userInfo.userType);
//			pstmt.setString(columnIndex++, userInfo.part);
//			pstmt.setString(columnIndex++, userInfo.title);
//			pstmt.setTimestamp(columnIndex++, userInfo.enterDate);
//			pstmt.setString(columnIndex++, userInfo.avgGrade+"");
//			pstmt.setString(columnIndex++, userInfo.userId);
//			return pstmt.executeUpdate() > 0;
//		} catch (SQLException e) {
//			logger.error("", e);
//		}
//		return false;
//	}
//	
//	public List<UserInfo> selectAll(){
//		List<UserInfo> list = new ArrayList<UserInfo>();
//		
//		try {
//			Statement stmt = conn.createStatement();
//			ResultSet rs = stmt.executeQuery(selectAllSQL);
//			while(rs.next()){
//				UserInfo userInfo = new UserInfo();
//				userInfo.readFrom(rs);
//				list.add(userInfo);
//			}
//		
//		} catch (SQLException e) {
//			logger.error("", e);
//		}
//		return list;
//	}
//	
//	public UserInfo select(int id){
//		try {
//			String selectSQL = selectAllSQL + " where userid = ?";
//			Statement stmt = conn.createStatement();
//			ResultSet rs = stmt.executeQuery(selectSQL);
//			if(rs.next()){
//				UserInfo userInfo = new UserInfo();
//				userInfo.readFrom(rs);
//				return userInfo;
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
