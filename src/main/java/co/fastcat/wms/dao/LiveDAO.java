package co.fastcat.wms.dao;

import java.util.Date;
import java.util.List;

import co.fastcat.wms.webpage.WebUtil;
import co.fastcat.wms.bean.LiveInfo;

public class LiveDAO extends Mapper<LiveInfo> {

	@Override
	public LiveInfo createBean(){
		return new LiveInfo();
	}
	
	//특정인 조회
	//일별, 월별 가능하다.
	public List<LiveInfo> selectMonth(String serialId, Date date){
		String livedate = WebUtil.toDashedDateString(date);
		String month = livedate.substring(0, 7);
		String where = "where serialId = '" + serialId + "' and livedate >= '"+ month +"-01' and livedate <= '"+ month +"-31'";
		String orderby = "order by livedate asc";
		
		return super.select(where, orderby);
	}
	
	//특정인, 특정날짜로만조회.
	public LiveInfo select(String serialId, Date date){
		String livedate = WebUtil.toDashedDateString(date);
		String where = "where serialId = '" + serialId + "' and livedate = '" + livedate + "'";
		List<LiveInfo> list = super.select(where, null);
		if(list != null && list.size() > 0){
			return list.get(0);
		}
		return null;
	}
		
}
