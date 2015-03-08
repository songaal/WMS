VERSION=1.0.1
CMD1='tomcat6/bin/shutdown.sh'
CMD2='sh deploy_WMS.sh'
CMD3='tomcat6/bin/startup.sh'

#deploy 실행.
echo START!!

#서버로 카피한다.
echo scp ./target/WMS-$VERSION/WMS.war websqrd@websqrd.com:~/
scp ./target/WMS-$VERSION/WMS.war websqrd@websqrd.com:~/

echo ssh websqrd@websqrd.com $CMD1
ssh websqrd@websqrd.com $CMD1

echo ssh websqrd@websqrd.com $CMD2
ssh websqrd@websqrd.com $CMD2

echo ssh websqrd@websqrd.com $CMD3
ssh websqrd@websqrd.com $CMD3

echo DONE!!!