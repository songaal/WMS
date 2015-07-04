package co.fastcat.wms.bean;

import co.fastcat.wms.annotation.DBField;
import co.fastcat.wms.annotation.DBTable;

@DBTable("approval_setting")
public class ApprovalSetting extends DAOBean{
	
	@DBField(column="type", pk=true)
	public String type;
	@DBField(column="res_user_count", type=DBField.Type.Int)
	public int resUserCount;
	
	@DBField(column="res_user1")
	public String resUser1;
	@DBField(column="res_user2")
	public String resUser2;
	@DBField(column="res_user3")
	public String resUser3;
	
}
