# 서버에서 실행되는 스크립트. 톰캣에 deploy한다.
# /home/websqrd/ 하위에 설치되야 한다.

DATETIME=`date +%Y%m%d%H%M%S`
mv /home/websqrd/tomcat6/webapps/WMS.war /home/websqrd/tomcat6/backup/WMS_$DATETIME.war
rm -rf /home/websqrd/tomcat6/webapps/WMS
cp /home/websqrd/WMS.war /home/websqrd/tomcat6/webapps/