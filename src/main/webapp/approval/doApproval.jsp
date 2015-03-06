<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.websqrd.company.wms.*"%>
<%@page import="com.websqrd.company.wms.dao.*"%>
<%@page import="com.websqrd.company.wms.bean.*"%>
<%@page import="com.websqrd.company.wms.webpage.*"%>
<%@include file="../inc/session.jsp"%>

<%
	String action = request.getParameter("action");
	
	if("approve".equals(action)){
		if(request.getMethod().equalsIgnoreCase("POST")){
			ApprovalDAO dao = new ApprovalDAO();
			
			String id = request.getParameter("id");
			ApprovalInfo approvalInfo = dao.select(id);
			
			String type = request.getParameter("type");
			String memo = request.getParameter("memo");
			
			if(approvalInfo.resUserStep == 0 ||  approvalInfo.resUserStep >  approvalInfo.resUserCount){
				//에러.
				logger.error("[승인] approvalInfo.resUserStep={},  approvalInfo.resUserCount={}", approvalInfo.resUserStep, approvalInfo.resUserCount);
			}else{
			
				ApprovalSettingDAO settingDAO = new ApprovalSettingDAO();
				if(settingDAO.hasApprovalAuth(myUserInfo.serialId, type, approvalInfo.resUserStep)){
			
					boolean hasNext = approvalInfo.resUserStep < approvalInfo.resUserCount;
					
					int result = dao.updateApproval(id, approvalInfo.resUserStep, memo, hasNext);
					logger.info("[승인] id={}, step={}, memo={}, hasNext={}, result={}", new Object[]{id, approvalInfo.resUserStep, memo, hasNext, result});
					if(result > 0){
						boolean isSuccess = true;
						if(!hasNext){
							isSuccess = false;
							//최종승인이라면 결재정보를 승인으로 업데이트한다.
							if(type.equalsIgnoreCase(ApprovalInfo.TYPE_REST)){
								// 휴가사용/발급 통괄처리.
								RestDataDAO restDataDAO = new RestDataDAO();
								String restId = approvalInfo.aprvId + "";
								
								isSuccess = restDataDAO.updateApprovalStatus(restId, ApprovalInfo.STATUS_APRVD);
								logger.info("[승인]휴가 restId={}, isSuccess={}", restId, isSuccess);
								if(isSuccess){
									RestData2 restData = restDataDAO.select(restId);
									String restCategory = restData.category;
									RestDAO restDAO = new RestDAO();
									RestInfo restInfo = restDAO.select(restData.userSID);
									//차감 또는 중가한다.
									BusinessUtil.updateRestInfo(restInfo, restData);
									
									isSuccess = restDAO.modify(restInfo) > 0;
									
									if(isSuccess && restData.type.equals(RestData.TYPE_SPEND)){
										//해당일의 상태를 휴가로 변경한다.
										String status = null;
										//반차는 반차로, 나머지는 다 휴가로 입력한다.
										if(restData.category.equals(RestData.CATEGORY_SPEND_HALF)){
											status = LiveInfo.HALF_REST;
										}else{
											status = LiveInfo.REST;
										}
										logger.debug("적용할 LiveInfo 휴가 상태 = {}, 적용일 = {}", status, Math.ceil(restData.amount));
										
										LiveDAO liveDAO = new LiveDAO();
										Date applyDate = restData.applyDate;
										Calendar cal = Calendar.getInstance();
										cal.setTime(applyDate);
										for(int i = 0; i< Math.ceil(restData.amount); i++){
											long thatTime = cal.getTimeInMillis();
											LiveInfo liveInfo = liveDAO.select(restData.userSID, new Date(thatTime));
											if(liveInfo == null){
												liveInfo = new LiveInfo();
												liveInfo.serialId = restData.userSID;
												liveInfo.liveDate = new java.sql.Date(thatTime);
												liveInfo.regTime = new java.sql.Timestamp(System.currentTimeMillis());
												liveInfo.status = status;
												if(liveDAO.create(liveInfo) != null){
													logger.debug("liveDAO 휴가 상태생성 성공! {}, {}", restData.userSID, new Date(thatTime));
												}else{
													logger.debug("liveDAO 휴가 상태생성 실패! {}, {}", restData.userSID, new Date(thatTime));
												}
											}else{
												liveInfo.status += status;
												if(liveDAO.modify(liveInfo) > 0){
													logger.debug("liveDAO 휴가 상태변경 성공! {}, {}", restData.userSID, new Date(thatTime));
												}else{
													logger.debug("liveDAO 휴가 상태변경 실패! {}, {}", restData.userSID, new Date(thatTime));
												}
											}
											cal.add(Calendar.DATE, 1); //하루씩 더해간다.
											
										}
										
										
									}
								}
								
							}else if(type.equals(ApprovalInfo.TYPE_COMMON)){
								//TODO
								
								
							}
						}else{
							isSuccess = true;
						}
						
						if(isSuccess){
							out.println("성공! id="+id);
						}
					}
					//여기오면 실패이다.
					response.sendRedirect(pageFrom);	
				}else{
					out.println("권한부족");
					response.sendRedirect(pageFrom);
					
				}
			}
		}
	}else if("reject".equals(action)){
		if(request.getMethod().equalsIgnoreCase("POST")){
			ApprovalDAO dao = new ApprovalDAO();
			
			String id = request.getParameter("id");
			ApprovalInfo approvalInfo = dao.select(id);
			
			String type = request.getParameter("type");
			String memo = request.getParameter("memo");
			ApprovalSettingDAO settingDAO = new ApprovalSettingDAO();
			
			if(approvalInfo.resUserStep == 0 ||  approvalInfo.resUserStep >  approvalInfo.resUserCount){
				//에러.
			}else{
			
				if(settingDAO.hasApprovalAuth(myUserInfo.serialId, type, approvalInfo.resUserStep)){
		
					int result = dao.updateReject(id, approvalInfo.resUserStep, memo);
					logger.info("[반려] id={}, step={}, memo={}, result={}", new Object[]{id, approvalInfo.resUserStep, memo, result});
					if(result > 0){
						boolean isSuccess = true;
						
						if(type.equalsIgnoreCase(ApprovalInfo.TYPE_REST)){
							// 휴가사용/발급 통괄처리.
							RestDataDAO restDataDAO = new RestDataDAO();
							String restId = approvalInfo.aprvId + "";
							isSuccess = restDataDAO.updateApprovalStatus(restId, ApprovalInfo.STATUS_REJECT);
						}else if(type.equals(ApprovalInfo.TYPE_COMMON)){
							//TODO
							
						}
						
						if(isSuccess){
							out.println("성공! id="+id);
						}
					}
					
					response.sendRedirect(pageFrom);
				}else{
					out.println("권한부족");
					response.sendRedirect(pageFrom);
					
				}
			}
		}
	}
%>




