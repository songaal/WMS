package co.fastcat.wms.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import co.fastcat.wms.bean.UserInfo;

public class UserDAO extends Mapper<UserInfo> {

	@Override
	public UserInfo createBean(){
		return new UserInfo();
	}
	
	public List<UserInfo> select(){
		String where = "where type='"+ UserInfo.TYPE_WEBSQRD +"'";
		String orderby = "order by serial_id";
		return select(where, orderby);
	}
	
	public UserInfo select(String serialId){
		String where = "where type='"+ UserInfo.TYPE_WEBSQRD +"' and serial_id = '" + serialId + "'";
		List<UserInfo> list = select(where, null);
		if(list != null && list.size() > 0){
			return list.get(0);
		}
		return null;
	}
	
	public List<UserInfo> selectApproval(){
		String where = "where type='"+ UserInfo.TYPE_WEBSQRD +"' and user_type like '%"+ UserInfo.AUTH_APPROVAL +"%'"; 
		String orderby = "order by serial_id";
		return select(where, orderby);
	}
	
	public UserInfo login(String userId, String passwd){
		//특수문자제거.
		String sql = "select serial_id from " + stub.getBeanInfo().getTableName() + " where user_id = ? and passwd = PASSWORD(?)";
		Connection conn = getPool().getConnection();
		try{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			int parameterIndex = 1;
			pstmt.setString(parameterIndex++, userId);
			pstmt.setString(parameterIndex++, passwd);
			logger.debug("userId >> {}, passwd >> {}", userId, passwd);
			ResultSet rs = pstmt.executeQuery();
			if(rs.next()){
				String serialId = rs.getString(1);
				logger.debug("serialId >> {}", serialId);
				return select(serialId);
			}
		} catch (SQLException e) {
			logger.error("", e);
		}finally{
			getPool().returnConnection(conn);
		}
		return null;
	}
	
	public boolean updatePasswd(String userSID, String oldPasswd, String newPasswd){
		String sql = "update " + stub.getBeanInfo().getTableName() + " set passwd = PASSWORD(?) where serial_id = ? and passwd = PASSWORD(?)";
//		logger.debug("updatePasswd >> {}, {}, {}", new Object[]{ userSID, oldPasswd, newPasswd });
//		logger.debug("updatePasswd >> {}", sql);
		Connection conn = getPool().getConnection();
		try{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			int parameterIndex = 1;
			pstmt.setString(parameterIndex++, newPasswd);
			pstmt.setString(parameterIndex++, userSID);
			pstmt.setString(parameterIndex++, oldPasswd);
			
			return pstmt.executeUpdate() > 0;
		} catch (SQLException e) {
			logger.error("", e);
		}finally{
			getPool().returnConnection(conn);
		}
		return false;
	}
	
	public boolean resetPasswd(String userSID){
		String sql = "update " + stub.getBeanInfo().getTableName() + " set passwd = PASSWORD(user_id) where serial_id = ? ";
		Connection conn = getPool().getConnection();
		try{
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userSID);
			
			return pstmt.executeUpdate() > 0;
		} catch (SQLException e) {
			logger.error("", e);
		}finally{
			getPool().returnConnection(conn);
		}
		return false;
	}
	
	public boolean suspend(UserInfo info){
		return false;
	}
	
	public boolean resume(UserInfo info){
		return false;
	}
	
}
