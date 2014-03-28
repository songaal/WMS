package com.websqrd.company.wms.dao;

import java.util.List;

import com.websqrd.company.wms.bean.ProjectLogInfo;

public class ProjectLogDAO extends Mapper<ProjectLogInfo> {

	@Override
	public ProjectLogInfo createBean() {
		return new ProjectLogInfo();
	}
	
	public ProjectLogInfo get(String pid, String type) {
		String where="where project_id='"+pid+"' and type='"+type+"' ";
		String orderby="order by ver desc ";
		String limit="limit 1";
		List <ProjectLogInfo> list = super.select(where, orderby, limit);
		if(list != null && list.size() > 0) {
			return list.get(0);
		}
		return null;
	}
}
