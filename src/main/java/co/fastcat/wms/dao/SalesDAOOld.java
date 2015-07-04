package co.fastcat.wms.dao;

import co.fastcat.wms.bean.SalesInfo;


public class SalesDAOOld extends Mapper<SalesInfo>{
	
	public SalesDAOOld(){ }
	
	@Override
	public SalesInfo createBean() {
		return new SalesInfo();
	}
	
//	public SalesInfo getSaleInfo(int salesId){
//		
//		Connection conn = getPool().getConnection();
//		
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		try{
//			pstmt = conn.prepareStatement("select id, regdate, company, memo, person, contact, method, reporter, budget, startday, result, resultmemo, resultdate" +
//				" from sales_info where id = ?");
//			pstmt.setInt(1, salesId);
//			rs = pstmt.executeQuery();
//			if(rs.next()){
//				//FIXME
//				SalesInfo salesInfo = null;//SalesInfo.map(rs);
//				return salesInfo;
//			}
//		}catch(SQLException e){
//			logger.error("", e);
//		}finally{
//			close(pstmt);
//			close(rs);
//			getPool().returnConnection(conn);
//		}
//		
//		return null;
//	}

//	public List<SalesInfo> getSaleInfoListAll(){
//		
//		List<SalesInfo> list = new ArrayList<SalesInfo>();
//		Connection conn = getPool().getConnection();
//		
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		try{
//			pstmt = conn.prepareStatement("select id, regdate, company, memo, person, contact, method, reporter, budget, startday, result, resultmemo, resultdate" +
//				" from sales_info order by regdate desc");
//			rs = pstmt.executeQuery();
//			while(rs.next()){
//				//FIXME
//				SalesInfo salesInfo = null;//SalesInfo.map(rs);
//				list.add(salesInfo);
//			}
//		}catch(SQLException e){
//			
//		}finally{
//			close(pstmt);
//			close(rs);
//			getPool().returnConnection(conn);
//		}
//		
//		return list;
//	}
	
//	public boolean insert(SalesInfo info){
//		Connection conn = getPool().getConnection();
//		
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		try{
//			pstmt = conn.prepareStatement("insert into sales_info (regdate, company, memo, person, contact, method, reporter, budget, startday) values" +
//					" (?, ?, ?, ?, ?, ?, ?, ?, ?)");
//			int idx = 1;
//			pstmt.setTimestamp(idx++, info.getRegdate());
//			pstmt.setString(idx++, info.getCompany());
//			pstmt.setString(idx++, info.getMemo());
//			pstmt.setString(idx++, info.getPerson());
//			pstmt.setString(idx++, info.getContact());
//			pstmt.setString(idx++, info.getMethod());
//			pstmt.setString(idx++, info.getReporter());
//			pstmt.setString(idx++, info.getBudget());
//			pstmt.setString(idx++, info.getStartday());
//			
//			return pstmt.executeUpdate() > 0;
//			
//		}catch(SQLException e){
//			
//		}finally{
//			close(pstmt);
//			close(rs);
//			getPool().returnConnection(conn);
//		}
//		
//		return false;
//	}

//	public boolean modify(SalesInfo info){
//		Connection conn = getPool().getConnection();
//		
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		try{
//			pstmt = conn.prepareStatement("update sales_info set regdate=?, company=?, memo=?, person=?, contact=?, method=?, reporter=?, budget=?, startday=?, result=?, resultmemo=?, resultdate=?" +
//					" where id = ?");
//			int idx = 1;
//			pstmt.setTimestamp(idx++, info.getRegdate());
//			pstmt.setString(idx++, info.getCompany());
//			pstmt.setString(idx++, info.getMemo());
//			pstmt.setString(idx++, info.getPerson());
//			pstmt.setString(idx++, info.getContact());
//			pstmt.setString(idx++, info.getMethod());
//			pstmt.setString(idx++, info.getReporter());
//			pstmt.setString(idx++, info.getBudget());
//			pstmt.setString(idx++, info.getStartday());
//			pstmt.setString(idx++, info.getResult());
//			pstmt.setString(idx++, info.getResultMemo());
//			pstmt.setTimestamp(idx++, info.getResultDate());
//			pstmt.setInt(idx++, info.getId());
//			
//			return pstmt.executeUpdate() > 0;
//			
//		}catch(SQLException e){
//			e.printStackTrace();
//		}finally{
//			close(pstmt);
//			close(rs);
//			getPool().returnConnection(conn);
//		}
//		
//		return false;
//	}
	
//	public boolean delete(SalesInfo info){
//		Connection conn = getPool().getConnection();
//		
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		try{
//			pstmt = conn.prepareStatement("delete from sales_info where id = ?");
//			int idx = 1;
//			pstmt.setInt(idx++, info.getId());
//			
//			return pstmt.executeUpdate() > 0;
//			
//		}catch(SQLException e){
//			e.printStackTrace();
//		}finally{
//			close(pstmt);
//			close(rs);
//			getPool().returnConnection(conn);
//		}
//		
//		return false;
//	}

	

}
