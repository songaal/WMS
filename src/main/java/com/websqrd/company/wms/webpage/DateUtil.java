package com.websqrd.company.wms.webpage;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class DateUtil {
	
	private static SimpleDateFormat shortDashedDateFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	public static String getDateStr(Date date){
		if(date == null){
			return "";
		}
		return shortDashedDateFormat.format(date);
	}
	
	public static String getNextDateStr(Date date){
		if(date == null){
			return "";
		}
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.DATE, 1);
		
		return getDateStr(cal.getTime());
	}
}
