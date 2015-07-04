package co.fastcat.wms.bean;

import java.sql.Date;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("rest_info")
public class RestInfo2 extends RestInfo{
	
	@DBField(column="user_name")
	public String userName; //이름
	@DBField(column="enter_date", type=DBField.Type.Date)
	public Date enterDate; //입사일
}
