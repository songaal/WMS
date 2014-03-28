package com.websqrd.company.wms.webpage;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class WebUtil {
	
	protected static Logger logger = LoggerFactory.getLogger(WebUtil.class);
	private static SimpleDateFormat hangulYearMonthFormat = new SimpleDateFormat("yyyy년 M월");
	
	private static SimpleDateFormat miniDateFormat = new SimpleDateFormat("MM.dd");
	private static SimpleDateFormat shortDateFormat = new SimpleDateFormat("yyyy.MM.dd");
	private static SimpleDateFormat shortDashedDateFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	private static SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");
	private static SimpleDateFormat dashedTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private static SimpleDateFormat shortTimeFormat = new SimpleDateFormat("HH시 mm분");
	private static SimpleDateFormat miniTimeFormat = new SimpleDateFormat("HH:mm");
	
	
	public static String getPageName(String url){
		
		int end = url.indexOf(".jsp");
		int start = url.lastIndexOf('/', end);
		if(end > 0 && start > 0 && start < end){
			return url.substring(start + 1, end + 4);
		}else{
			return null;
		}
		
	}

	public static String getLastURLPath(String url){
		
		int start = url.indexOf("/WMS/");
		int end = url.indexOf('/', start + 5);
		if(end > 0 && start > 0 && start < end){
			return url.substring(start, end + 1);
		}else{
			return url.substring(start);
		}
		
	}
	public static boolean isNotEmpty(String value){
		return value != null && value.trim().length() > 0;
	}
	public static Timestamp getTimestampValue(String value){
		if(value == null){
			return null;
		}else{
			try{
				Date date = shortDateFormat.parse(value);
				return new Timestamp(date.getTime());
			} catch (ParseException e) {
				logger.error("", e);
				return null;
			}
		}
	}
	
	public static java.sql.Date getSQLDateValue(String value){
		if(value == null){
			return null;
		}else{
			try{
				Date date = shortDateFormat.parse(value);
				return new java.sql.Date(date.getTime());
			} catch (ParseException e) {
				logger.error("", e);
				return null;
			}
		}
	}
	
	public static int getIntValue(String value){
		if(value == null){
			return -1;
		}else{
			try{
				int a = Integer.parseInt(value);
				return a;
			}catch(NumberFormatException e){
				
			}
			return -1;
		}
	}
	
	public static String getMultiLineValue(Object value){
		if(value == null){
			return "";
		}else{
			return value.toString().replaceAll("\n", "<br/>");
		}
	}
	
	public static String getValue(Object value){
		if(value == null){
			return "";
		}else{
			return value.toString();
		}
	}
	public static String getValue(Object value, String defaultValue){
		if(value == null || value.equals("")){
			return defaultValue;
		}else{
			return value.toString();
		}
	}
	
	public static String getValue(Object value, int summarySize){
		if(value == null){
			return "";
		}else{
			String content = value.toString();
			if(content.length() > summarySize){
				return content.substring(0, summarySize)+"..";
			}else{
				return content;
			}
		}
	}
	public static String toHangulYearMonthString(Date date){
		if(date == null){
			return "";
		}
		return hangulYearMonthFormat.format(date);
	}
	
	public static String toDateString(Timestamp ts){
		if(ts == null){
			return "";
		}
		return shortDateFormat.format(ts);
	}
	public static String toDateString(Date date){
		if(date == null){
			return "";
		}
		return shortDateFormat.format(date);
	}
	public static String toDashedDateString(Date date){
		if(date == null){
			return "";
		}
		return shortDashedDateFormat.format(date);
	}
	public static String toDateStringWithYoil(Date date){
		if(date == null){
			return "";
		}
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		String yoil = getYoilString(cal);
		return toDateString(date)+" ("+yoil+")";
	}
	
	public static String toShortDateTimeString(Date date){
		if(date == null){
			return "";
		}
		return dateTimeFormat.format(date);
	}
	
	public static String toMiniDateString(Date date){
		if(date == null){
			return "";
		}
		return miniDateFormat.format(date);
	}
	
	public static String toDateTimeString(Date date){
		if(date == null){
			return "";
		}
		return dashedTimeFormat.format(date);
	}
	
	public static String toTimeString(Date date){
		if(date == null){
			return "";
		}
		return shortTimeFormat.format(date);
	}
	
	public static String toMiniTimeString(Date date){
		if(date == null){
			return "";
		}
		return miniTimeFormat.format(date);
	}
	public static String getYoilString(Calendar cal){
		
		switch (cal.get(Calendar.DAY_OF_WEEK)){
	    case 1:
	        return ("일요일");
	    case 2:
	        return ("월요일");
	    case 3:
	        return ("화요일");
	    case 4:
	        return ("수요일");
	    case 5:
	        return ("목요일");
	    case 6:
	        return ("금요일");
	    case 7:
	        return ("토요일");
	    }
		
		return "";
	}
	public static String getShortYoilString(Calendar cal){
		
		switch (cal.get(Calendar.DAY_OF_WEEK)){
	    case 1:
	        return ("일");
	    case 2:
	        return ("월");
	    case 3:
	        return ("화");
	    case 4:
	        return ("수");
	    case 5:
	        return ("목");
	    case 6:
	        return ("금");
	    case 7:
	        return ("토");
	    }
		
		return "";
	}
	
	public static String toDateYoilString(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		return getShortYoilString(cal)+" "+toDateString(date);
	}
	
	public static String toMonthWeekString(Date date){
		Calendar cal = Calendar.getInstance();
		return toHangulYearMonthString(date)+" "+cal.get(Calendar.WEEK_OF_MONTH)+"주";
	}
	
	//2012-10-10 11:11:00
	public static Date parseDatetime(String str){
		if(str != null && str.length() > 0){
			logger.debug("parseDatetime >> {}", str);
			try {
				return dashedTimeFormat.parse(str);
			} catch (ParseException e) {
				//e.printStackTrace();
			}
		}
		return null;
		
	}
	
	public static Date parseDate(String str){
		if(str != null){
			try {
				return shortDateFormat.parse(str);
			} catch (ParseException e) {
				//e.printStackTrace();
			}
		}
		return null;
		
	}
	
	//오늘인지여부.
	public static boolean isToday(Date date){
		if(date == null){
			return false;
		}
		return isTheSameDay(Calendar.getInstance().getTime(), date);
	}
	
	public static boolean isTheSameDay(Date date1, Date date2){
		Calendar today = Calendar.getInstance();
		today.setTime(date1);
		Calendar cal = Calendar.getInstance();
		cal.setTime(date2);
		
		if( (today.get(Calendar.YEAR) == cal.get(Calendar.YEAR))
			&& (today.get(Calendar.MONTH) == cal.get(Calendar.MONTH))
			&& (today.get(Calendar.DATE) == cal.get(Calendar.DATE)) ){
			return true;
		}
		
		return false;
		
	}
	
	public static boolean isPrevYear(Date date1, Date date2){

		if(date1 == null || date2 == null){
			return true;
		}
		//if date1 가 date2이전의 year이면 true
		if(date1.before(date2)){
			Calendar cal1 = Calendar.getInstance();
			cal1.setTime(date1);
			Calendar cal2 = Calendar.getInstance();
			cal2.setTime(date2);
			
			//같은 년도가 아니면 true
			if(cal1.get(Calendar.YEAR) != cal2.get(Calendar.YEAR)){
				return true;
			}
		}
		
		return false;
	}
	
	public static boolean isPrevMonth(Date date1, Date date2){

		if(date1 == null || date2 == null){
			return true;
		}
		//if date1 가 date2이전의 월(month)이면 true
		if(date1.before(date2)){
			Calendar cal1 = Calendar.getInstance();
			cal1.setTime(date1);
			Calendar cal2 = Calendar.getInstance();
			cal2.setTime(date2);
			
			//같은 달이 아니면 true
			if(cal1.get(Calendar.MONTH) != cal2.get(Calendar.MONTH)){
				return true;
			}
		}
		
		return false;
	}
	
	public static List<Date> getListOfThisWeek(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		
		//1: sun 2: mon .. 7: sat
		int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
		if(dayOfWeek == 1) {
			dayOfWeek = 8;
		}
		cal.add(Calendar.DATE, (2 - dayOfWeek));
		
		List<Date> result = new ArrayList<Date>();
//		logger.debug("{} {}", toDateString(cal.getTime()), getYoilString(cal));
		result.add(cal.getTime());
		for(int i=0; i< 6; i++){
			cal.add(Calendar.DATE, 1);
			result.add(cal.getTime());
//			logger.debug("{} {}", toDateString(cal.getTime()), getYoilString(cal));
		}
		return result;
	}
	
	public static Date[] getRangeOfThisWeek(Date date){
		Date[] result = new Date[2];
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		
		//1: sun 2: mon .. 7: sat
		int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
		if(dayOfWeek == 1) {
			dayOfWeek = 8;
		}
		cal.add(Calendar.DATE, (2 - dayOfWeek));
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		
		
		result[0] = cal.getTime();
		
		cal.add(Calendar.DATE, 7);
		
		result[1] = cal.getTime();
		
		return result;
	}
	public static String getDueDateDisplayStr(Date date){
		if(date == null){
			return "미정";
		}
		Calendar cal = Calendar.getInstance();
//		cal.setTime(reqDate);
		Date today = cal.getTime();
		cal.add(Calendar.DATE, -1);
		Date yesterday = cal.getTime();
		cal.add(Calendar.DATE, 2);
		Date tomorrow = cal.getTime();
		//오늘 날짜라면
		if(isTheSameDay(today, date)) {
			return "오늘";
		}else if(isTheSameDay(yesterday, date)) {
			return "어제";
		}else if(isTheSameDay(tomorrow, date)) {
			return "내일";
		}else{
			Calendar cal2 = Calendar.getInstance();
			cal2.setTime(date);
			return miniDateFormat.format(date) + "("+ getShortYoilString(cal2) + ")";
		}
		
	}
	
	public static Date get0Time(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}
	
	public static String getEscapeHtml(String html){
		return html.replaceAll("<", "&lt;").replaceAll("\"", "\\\"");
	}
	
	
	public static void main(String[] args) {
//		String str = "2012.12.1";
//		Date date = WebUtil.parseDate(str);
//		WebUtil.getListOfThisWeek(date);
		String url = "http://localhost:8080/WMS/project/doProject.jsp?ajsdfh=ak/askfjas/sadf&jksdh=22";
		System.out.println(WebUtil.getPageName(url));
		
	}
}
