package com.websqrd.company.wms.webpage;

import java.util.Calendar;

import com.websqrd.company.wms.bean.ApprovalInfo;
import com.websqrd.company.wms.bean.LiveInfo;
import com.websqrd.company.wms.bean.ProjectInfo;
import com.websqrd.company.wms.bean.ProjectRequest;
import com.websqrd.company.wms.bean.RestData;
import com.websqrd.company.wms.bean.RestData2;
import com.websqrd.company.wms.bean.RestInfo;

public class BusinessUtil {
	
	public static final int CheckInTime = 9;
	public static final int CheckInTimeCompromise = 10;
	public static final int WorkLateTime = 22;
	
	//지각, 정상 구분.
	public static String getCheckInStatusString(long time){
		
		if(isAfterHour(CheckInTime, time)){
			return LiveInfo.LATE;
		}else{
			return LiveInfo.OK;
		}
	}
	
	public static boolean isAfterHour(int standardHour, long compareTime){
		Calendar okTime = Calendar.getInstance();
		okTime.setTimeInMillis(compareTime);
		okTime.set(Calendar.HOUR_OF_DAY, standardHour);
		okTime.set(Calendar.MINUTE, 1);
		// 입력된 시간대의 1분 이후 부터 지각 처리. 
		// 기존코드는 0분 부터 지각 처리 되었음 
		okTime.set(Calendar.SECOND, 0);
		okTime.set(Calendar.MILLISECOND, 0);
		
		Calendar myTime = Calendar.getInstance();
		myTime.setTimeInMillis(compareTime);
		
		return myTime.after(okTime);
	}
	public static String getLiveStatusString(String status){
		return getLiveStatusString(status, false, "");
	}
	public static String getLiveStatusString(String status, String count){
		return getLiveStatusString(status, false, count);
	}
	public static String getLiveStatusString(String status, boolean addEvent, String count){
		if(count == null){
			count ="";
		}
		if(count.length() > 0){
			count = (" " + count); //사이에 공백을 넣어준다.
		}
		StringBuilder sb = new StringBuilder();
		if(status.contains(LiveInfo.OK)){
			sb.append("<span class=\"label label-success\">정상"+count+"</span> ");
		}
		if(status.contains(LiveInfo.LATE)){
			if(addEvent){
				sb.append("<span class=\"label label-important wms_late\">지각"+count+"</span>");
			}else{
				sb.append("<span class=\"label label-important\">지각"+count+"</span>");
			}
		}
		if(status.contains(LiveInfo.OUTTER)){
			sb.append("<span class=\"label label-info\">외근"+count+"</span> ");
		}
		if(status.contains(LiveInfo.REST)){
			sb.append("<span class=\"label\">휴가"+count+"</span> ");
		}
		if(status.contains(LiveInfo.HALF_REST)){
			sb.append("<span class=\"label\">반차"+count+"</span> ");
		}
		if(status.contains(LiveInfo.SPECIAL_WORK)){
			sb.append("<span class=\"label label-warning\">휴일근무"+count+"</span> ");
		}
		if(status.contains(LiveInfo.NIGHT_WORK)){
			sb.append("<span class=\"label label-warning\">야근"+count+"</span> ");
		}
		return sb.toString();
	}
	
	
	public static String getProjectStatus(String status){
		if(ProjectInfo.STATUS_ONGOING.equals(status)){
			return "진행중";
		}else if(ProjectInfo.STATUS_DONE.equals(status)){
			return "완료";
		}else if(ProjectInfo.STATUS_MAINTAIN.equals(status)){
			return "유지보수";
		}else if(ProjectInfo.STATUS_DUMP.equals(status)){
			return "계약종료";
		}
		return "";
	}
	
	public static int monthsBetween(Calendar startDate, Calendar endDate) {
        startDate.set(Calendar.DATE, 1);
        endDate.set(Calendar.DATE, 1);
        int months = 0;
        while (startDate.before(endDate)) {
        	startDate.add(Calendar.MONTH, 1);
            months++;
        }
        return months;
    }
	
	public static String userYearMonth(Calendar enterDate) {
		Calendar today = Calendar.getInstance();
		int months = monthsBetween(enterDate, today);
		return (months / 12) +"년 "+(months % 12)+ "개월";
    }
	
	public static String getRestTypeName(String code){
		if(code == null){
			return "";
		}else if(code.equals(RestData.TYPE_ISSUE)){
			return "휴가발급";
		}else if(code.equals(RestData.TYPE_SPEND)){
			return "휴가사용";
		}
		return "";
	}
	public static String getRestCategoryName(String code){
		if(code == null){
			return "";
		}else if(code.equals(RestData.CATEGORY_ISSUE_SPECIAL)){
			return "특별휴가";
		}else if(code.equals(RestData.CATEGORY_ISSUE_YEAR)){
			return "연차";
		}else if(code.equals(RestData.CATEGORY_SPEND_VACATION)){
			return "휴가";
		}else if(code.equals(RestData.CATEGORY_SPEND_MONTH)){
			return "월차";
		}else if(code.equals(RestData.CATEGORY_SPEND_HALF)){
			return "반차";
		}else if(code.equals(RestData.CATEGORY_SPEND_ETC)){
			return "기타";
		}
		return "";
	}
	
	public static String getApprovalTypeName(String type){
		if(ApprovalInfo.TYPE_REST_SPEND.equals(type)){
			return "휴가사용";
		}else if(ApprovalInfo.TYPE_REST_ISSUE.equals(type)){
			return "휴가발급";
		}else if(ApprovalInfo.TYPE_CHARGE.equals(type)){
			return "비용청구";
		}else if(ApprovalInfo.TYPE_BOOK.equals(type)){
			return "도서구입";
		}
		return "알수없음";
	}
	
	public static String getApprovalResultDisplayName(String type){
		if(ApprovalInfo.STATUS_WAIT.equals(type)){
			return "<span class=\"label label-warning\">미결재</span>";
		}else if(ApprovalInfo.STATUS_APRVD.equals(type)){
			return "<span class=\"label label-success\">승인</span>";
		}else if(ApprovalInfo.STATUS_REJECT.equals(type)){
			return "<span class=\"label label-important\">반려</span>";
		}
		return "<span class=\"label label-warning\">미결재</span>";
	}
	
	public static String getApprovalResultName(String type){
		if(ApprovalInfo.STATUS_WAIT.equals(type)){
			return "미결재";
		}else if(ApprovalInfo.STATUS_APRVD.equals(type)){
			return "승인";
		}else if(ApprovalInfo.STATUS_REJECT.equals(type)){
			return "반려";
		}
		return "미결재";
	}
	
	
	public static void updateRestInfo(RestInfo restInfo, RestData2 restData){
		if(restData.type.equals(RestData.TYPE_ISSUE)){
			//증가.
			if(restData.category.equals(RestData.CATEGORY_ISSUE_SPECIAL)){
				restInfo.getSpecial += restData.amount;
				
			}else if(restData.category.equals(RestData.CATEGORY_ISSUE_YEAR)){
				restInfo.getYear += restData.amount;
			}
			
			
		}else if(restData.type.equals(RestData.TYPE_SPEND)){
			//차감.
			if(restData.category.equals(RestData.CATEGORY_SPEND_VACATION)){
				restInfo.spentVacation += restData.amount;
			}else if(restData.category.equals(RestData.CATEGORY_SPEND_MONTH)){
				restInfo.spentMonth += restData.amount;
			}else if(restData.category.equals(RestData.CATEGORY_SPEND_HALF)){
				restInfo.spentHalf += restData.amount;
			}else if(restData.category.equals(RestData.CATEGORY_SPEND_ETC)){
				restInfo.spentETC += restData.amount;
			}
		}
		
		/// 전체적인 재계산
		float getAll = restInfo.getYear + restInfo.getSpecial;
		float spentAll = restInfo.spentHalf + restInfo.spentMonth + restInfo.spentVacation + restInfo.spentETC;
		restInfo.remain = getAll - spentAll;
		
	}
	//전일 야근으로 지각이 아닌지 여부.
	//하지만 CheckInTimeCompromise시간 안에는 들어와야함.
//	public static boolean isNotLateBecauseWorkLate(int yesterdayHour, long thisTime){
//		
//		if(isAfterHour(CheckInTimeCompromise, thisTime)){
//			//이 시간보다 늦으면 지각이다.
//			return false;
//		}
//		
//		//어제 늦게까지 일한시각을 지났다면 야근한것임.
//		return yesterdayHour >= WorkLateTime;
//	}

	//전일야근으로 인해 허용가능한 지각시간.
	public static boolean isCompromisableLate(long thisTime){
		return !(isAfterHour(CheckInTimeCompromise, thisTime));
	}
	public static boolean isWorkLate(){
		int hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
		return hour >= WorkLateTime;
	}
	public static void main(String[] args) {
		
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.HOUR_OF_DAY, 9);
		cal.set(Calendar.MINUTE, 1);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		System.out.println(isCompromisableLate(cal.getTimeInMillis()));
	}
	
	public static String getTitleValue(String title){
		if(title == null || title.trim().length() == 0){
			return "제목없음";
		}else {
			return title;
		}
	}
	
	public static String getRequestStatusStr(String status){
		if(status == null || status.length() == 0){
			return "정보없음.";
		}else if(status.equals(ProjectRequest.STATUS_READY)){
			return "접수";
		}else if(status.equals(ProjectRequest.STATUS_WORKING)){
			return "진행중";
		}else if(status.equals(ProjectRequest.STATUS_DONE)){
			return "완료";
		}
		return "";
	}
}
