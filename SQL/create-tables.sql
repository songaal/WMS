CREATE TABLE `approval_info` (
  `id` int(11) NOT NULL auto_increment,
  `aprv_type` char(1) NOT NULL,
  `aprv_id` int(11) NOT NULL,
  `req_user` char(4) NOT NULL,
  `req_datetime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `res_user1` char(4) NOT NULL,
  `res_user2` char(4) default NULL,
  `res_user3` char(4) default NULL,
  `res_datetime1` timestamp NULL default NULL,
  `res_datetime2` timestamp NULL default NULL,
  `res_datetime3` timestamp NULL default NULL,
  `res_result1` char(1) default NULL,
  `res_result2` char(1) default NULL,
  `res_result3` char(1) default NULL,
  `result_memo1` varchar(255) default NULL,
  `result_memo2` varchar(255) default NULL,
  `result_memo3` varchar(255) default NULL,
  `status` char(1) default NULL,
  `res_user_count` int(11) NOT NULL,
  `res_user_step` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `req_user` USING BTREE (`req_user`),
  KEY `res_user1` USING BTREE (`res_user1`),
  KEY `res_user2` USING BTREE (`res_user2`),
  KEY `res_user3` USING BTREE (`res_user3`),
  KEY ```status``` USING BTREE (`status`),
  KEY `aprv_type` USING BTREE (`aprv_type`),
  KEY `aprv_id` USING BTREE (`aprv_id`),
  KEY `req_datetime` USING BTREE (`req_datetime`),
  KEY `res_datetime1` USING BTREE (`res_datetime1`),
  KEY `res_datetime2` USING BTREE (`res_datetime2`),
  KEY `res_datetime3` USING BTREE (`res_datetime3`),
  KEY `res_result1` USING BTREE (`res_result1`),
  KEY `res_result2` USING BTREE (`res_result2`),
  KEY `res_result3` USING BTREE (`res_result3`)
) ENGINE=MyISAM AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;


CREATE TABLE `approval_setting` (
  `type` char(1) NOT NULL COMMENT '어떤 결재인지. 휴가,비용,일반결재.',
  `res_user_count` int(11) NOT NULL,
  `res_user1` char(4) default '0',
  `res_user2` char(4) default NULL,
  `res_user3` char(4) default NULL,
  PRIMARY KEY  (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



CREATE TABLE `client_info` (
  `id` int(11) NOT NULL auto_increment,
  `client_name` varchar(40) default NULL,
  `phone` varchar(15) default NULL,
  `address` varchar(255) default NULL,
  `memo` varchar(255) default NULL,
  `type` char(1) default NULL,
  `regdate` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;


CREATE TABLE `client_person` (
  `id` int(11) NOT NULL auto_increment,
  `client_id` int(11) NOT NULL,
  `person_name` varchar(40) NOT NULL,
  `phone` varchar(20) default NULL,
  `cell_phone` varchar(20) default NULL,
  `email` varchar(50) default NULL,
  `memo` varchar(255) default NULL,
  `type` char(1) default NULL,
  `regdate` date NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=103 DEFAULT CHARSET=utf8;


CREATE TABLE `File_List` (
  `id` int(11) NOT NULL auto_increment,
  `user_sid` char(4) NOT NULL,
  `regdate` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `project_id` int(11) NOT NULL,
  `fileName` text NOT NULL,
  `storeName` text NOT NULL,
  `descript` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=77 DEFAULT CHARSET=utf8;


CREATE TABLE `live_info` (
  `serialId` char(4) NOT NULL,
  `livedate` date NOT NULL COMMENT '적용날짜',
  `regtime` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP COMMENT '데이터를 처음 등록한 시각',
  `check_in` timestamp NULL default NULL,
  `check_out` timestamp NULL default NULL,
  `status` varchar(10) default NULL COMMENT '정상/외근/지각/휴가/반차/휴일근무/야근 등등..',
  `memo` varchar(255) default NULL,
  PRIMARY KEY  (`serialId`,`livedate`),
  KEY `serialId` (`serialId`),
  KEY `livedate` (`livedate`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `memo_info` (
  `id` int(11) NOT NULL auto_increment,
  `user_sid` char(4) NOT NULL,
  `content` text NOT NULL,
  `regdate` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `user_sid` (`user_sid`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `message_info` (
  `id` int(11) NOT NULL auto_increment,
  `sender` char(4) NOT NULL,
  `receiver` char(4) NOT NULL,
  `referencer` char(4) default NULL,
  `title` varchar(255) default NULL,
  `message` text NOT NULL,
  `send_date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `receive_date` timestamp NULL default NULL,
  PRIMARY KEY  (`id`),
  KEY `send_date` USING BTREE (`send_date`),
  KEY `receiver` USING HASH (`receiver`)
) ENGINE=MyISAM AUTO_INCREMENT=294 DEFAULT CHARSET=utf8;

CREATE TABLE `project_history` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) NOT NULL,
  `type` varchar(10) NOT NULL,
  `regdate` date NOT NULL,
  `user_id` char(4) NOT NULL,
  `memo` text NOT NULL,
  `work_id` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=162 DEFAULT CHARSET=utf8;


CREATE TABLE `project_info` (
  `id` int(11) NOT NULL auto_increment,
  `pm_id` char(4) default NULL,
  `sales_id` int(11) default NULL,
  `client_id` int(11) default NULL,
  `client_person_id` int(11) default NULL,
  `reseller_id` int(11) default NULL,
  `reseller_person_id` int(11) default NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `startdate` date NOT NULL,
  `enddate` date default NULL,
  `status` char(1) NOT NULL default '0',
  `solution` varchar(50) default NULL,
  `license` varchar(30) default NULL,
  `mstartdate` date default NULL,
  `menddate` date default NULL,
  `type` char(1) NOT NULL default 'O' COMMENT '내부프로젝트인지 외부인지. 내부:I, 외부:O',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;

CREATE TABLE `project_info_temp` (
  `id` int(11) NOT NULL auto_increment,
  `pm_id` char(4) default NULL,
  `sales_id` int(11) default NULL,
  `client_id` int(11) default NULL,
  `client_person_id` int(11) default NULL,
  `reseller_id` int(11) default NULL,
  `reseller_person_id` int(11) default NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `startdate` date NOT NULL,
  `enddate` date default NULL,
  `status` char(1) NOT NULL default '0',
  `solution` varchar(50) default NULL,
  `license` varchar(30) default NULL,
  `mstartdate` date default NULL,
  `menddate` date default NULL,
  `type` char(1) NOT NULL default 'O' COMMENT '내부프로젝트인지 외부인지. 내부:I, 외부:O',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


CREATE TABLE `project_logs` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) default NULL,
  `type` int(11) default NULL,
  `ver` varchar(45) default NULL,
  `user_id` varchar(45) default NULL,
  `log_text` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


CREATE TABLE `project_maintain` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) NOT NULL,
  `maintain_date` date default NULL,
  `done_date` date default NULL,
  `user_id` char(4) default NULL,
  `maintain_list` text,
  `result` text,
  `comment` text,
  `task_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


CREATE TABLE `project_meeting` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) NOT NULL,
  `meet_date` date NOT NULL,
  `place` varchar(80) NOT NULL,
  `user_id` char(4) NOT NULL,
  `websqrd_user` varchar(255) default NULL,
  `client_user` varchar(255) default NULL,
  `content` text NOT NULL,
  `next_schedule` text,
  `next_todo` text,
  `regdate` date NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `project_request` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) NOT NULL,
  `user_id` char(4) NOT NULL,
  `client_person_id` int(11) default NULL,
  `client_pname` varchar(20) default NULL COMMENT '고객사 담당자 이름 직함',
  `method` varchar(5) default NULL,
  `type` char(1) default NULL,
  `title` varchar(255) default NULL,
  `content` text,
  `regdate` date default NULL,
  `due_date` date default NULL,
  `result` text,
  `task_id` int(11) default NULL,
  `done_date` date default NULL,
  `status` varchar(5) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;

CREATE TABLE `project_work` (
  `id` int(11) NOT NULL auto_increment,
  `project_id` int(11) default NULL,
  `request_id` int(11) default NULL,
  `user_id` varchar(45) default NULL,
  `content` text,
  `issue` text,
  `regdate` datetime default NULL,
  `done_date` datetime default NULL,
  `status` varchar(2) default NULL,
  `user_name` varchar(45) default NULL,
  `project_name` varchar(45) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `rest_data` (
  `id` int(11) NOT NULL auto_increment,
  `aprv_status` char(1) NOT NULL COMMENT '결재상태',
  `user_sid` char(4) NOT NULL,
  `type` char(1) NOT NULL COMMENT '발급=A, 사용=B 구분 ',
  `category` char(1) NOT NULL COMMENT '연차/반차/특별휴가...',
  `memo` varchar(255) default NULL,
  `apply_date` date NOT NULL COMMENT '적용날짜',
  `amount` float NOT NULL COMMENT '휴가기간',
  `regdate` date NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;

CREATE TABLE `rest_info` (
  `id` int(11) NOT NULL auto_increment,
  `user_sid` char(4) NOT NULL,
  `remain` float NOT NULL,
  `get_year` float NOT NULL COMMENT '발급된 연차',
  `get_special` float NOT NULL COMMENT '발급된 특별휴가',
  `spent_half` float NOT NULL COMMENT '반차',
  `spent_month` float NOT NULL COMMENT '월차',
  `spent_vacation` float NOT NULL COMMENT '휴가',
  `spent_etc` float NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;


CREATE TABLE `sales_info` (
  `id` int(11) NOT NULL auto_increment COMMENT '순번',
  `regdate` date default NULL COMMENT '일자',
  `company` varchar(30) default NULL COMMENT '업체명',
  `memo` text COMMENT '내용',
  `person` varchar(255) default NULL COMMENT '담당자',
  `contact` varchar(255) default NULL COMMENT '연락처',
  `method` varchar(30) default NULL COMMENT '문의방법',
  `reporter` varchar(30) default NULL COMMENT '처리인',
  `budget` varchar(30) default NULL COMMENT '예상비용',
  `startday` varchar(30) default NULL COMMENT '예상시기',
  `result` varchar(2) default NULL COMMENT '결과',
  `resultmemo` text COMMENT '결과내용',
  `resultdate` date default NULL COMMENT '결과처리일자',
  PRIMARY KEY  (`id`),
  KEY `regdate` (`regdate`),
  KEY `result` (`result`)
) ENGINE=MyISAM AUTO_INCREMENT=153 DEFAULT CHARSET=utf8;

CREATE TABLE `sales_payment` (
  `id` int(11) NOT NULL,
  `type` char(1) NOT NULL,
  `cost` int(11) NOT NULL,
  `status` char(1) NOT NULL,
  `regdate` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `schedule_info` (
  `id` int(11) NOT NULL auto_increment,
  `user_sid` char(4) NOT NULL,
  `title` varchar(255) NOT NULL,
  `start` datetime default NULL,
  `end` datetime default NULL,
  `all_day` int(1) NOT NULL default '0',
  `location` varchar(100) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=97 DEFAULT CHARSET=utf8;


CREATE TABLE `support_history` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `issue_id` int(11) NOT NULL default '0',
  `support_level` char(1) NOT NULL,
  `regdate` datetime NOT NULL,
  `handler` varchar(30) NOT NULL,
  `client_person` varchar(255) NOT NULL,
  `solution` text NOT NULL,
  `cause` text NOT NULL,
  `status` char(1) NOT NULL,
  `startdate` datetime default NULL,
  `enddate` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `support_status` (
  `client_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `support_count` int(11) NOT NULL default '0',
  `support_limit` int(11) NOT NULL default '7',
  `free_support_count` int(11) NOT NULL default '0',
  `support_level` char(1) NOT NULL,
  PRIMARY KEY  (`project_id`,`client_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `task_list` (
  `tid` int(11) NOT NULL auto_increment,
  `user_sid` char(4) NOT NULL,
  `regdate` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `taskdate` date NOT NULL,
  `content` text,
  `issue` text,
  `flag` smallint(10) default '0',
  PRIMARY KEY  (`tid`,`user_sid`,`taskdate`)
) ENGINE=MyISAM AUTO_INCREMENT=761 DEFAULT CHARSET=utf8;


CREATE TABLE `user_info` (
  `serial_id` varchar(10) NOT NULL,
  `user_id` varchar(30) NOT NULL,
  `user_name` varchar(16) NOT NULL,
  `user_type` varchar(8) default '',
  `part` varchar(32) default NULL,
  `title` varchar(32) NOT NULL,
  `enter_date` date NOT NULL,
  `avg_grade` int(11) default NULL,
  `type` char(1) default NULL,
  `passwd` varchar(64) default NULL,
  PRIMARY KEY  (`serial_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `user_report` (
  `user_sid` char(4) NOT NULL,
  `report_to` char(4) default NULL,
  `reference_to` char(4) default NULL,
  `another_list` varchar(255) default NULL,
  PRIMARY KEY  (`user_sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;





