package co.fastcat.wms;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import co.fastcat.wms.dao.Mapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.websqrd.tool.db.DBConnectionPool;
import com.websqrd.tool.db.DBConnectionPoolManager;
import com.websqrd.tool.db.JDBCProfile;

public class DAOHandler {
	protected static Logger logger = LoggerFactory.getLogger(DAOHandler.class);
	
	private static Object lock = new Object();
	private static DAOHandler instance;
	private static String confFileName = "wms2.conf";
	
	public static DAOHandler getInstance(){
		if(instance == null){
			
			synchronized(lock){
				if(instance == null){
					instance = new DAOHandler(); 
				}
			}
		}
		
		return instance;
	}
	
	private DAOHandler(){
		Properties props = new Properties();
		InputStream is = getClass().getClassLoader().getResourceAsStream(confFileName);
		try {
			props.load(is);
			is.close();
		} catch (IOException e) {
			logger.error("", e);
		}
		WMSConf conf = WMSConf.getInstance();
		conf.init(props);
		DBConnectionPoolManager poolManager = DBConnectionPoolManager.getInstance();
		//String database, String host, String port, String username, String password
		String database = conf.get("jdbc.database");
		
		String host = conf.get("jdbc.host");
		String port = conf.get("jdbc.port");
		String username = conf.get("jdbc.username");
		String password = conf.get("jdbc.password");

		//int maxTotal, int maxIdle, int maxWait, int maxAge
		int maxTotal = conf.getInt("pool.maxTotal", 5);
		int maxIdle = conf.getInt("pool.maxIdle", 1);
		int maxWait = conf.getInt("pool.maxWait", 3);
		int maxAge = conf.getInt("pool.maxAge", 300);
		
		JDBCProfile jdbcProfile = new JDBCProfile (database, host, port, username, password) {
			@Override
			protected String getDefaultPort() { return "3306"; }
			@Override
			//public String getDriverClassName() { return "org.mariadb.jdbc.Driver"; }
			public String getDriverClassName() { return "com.mysql.jdbc.Driver"; }
			@Override
			public String getUrl() {
				String url = "jdbc:mysql://"+host+":"+getPort()+"/"+database;
				return url;
			}
			@Override
			public String getValidationSQL() { return "SELECT NOW()"; }
			
		};
		jdbcProfile.addParameter("characterEncoding", "utf-8");
		DBConnectionPool.Settings poolSettings = new DBConnectionPool.Settings(maxTotal, maxIdle, maxWait, maxAge);
		poolManager.register(Mapper.PoolName, jdbcProfile, poolSettings);

	}
	
	public DBConnectionPool getConnectionPool(String poolName){
		return DBConnectionPoolManager.getInstance().getDBConnectionPool(poolName);
	}
	
	protected boolean convToBoolean(String value){
		if(value.equalsIgnoreCase("Y"))
			return true;
		else
			return false;
	}
	
	protected char convToChar(String value) {
		if(value == null)
			return 0;
		else
			return value.charAt(0);
	}
	
}
