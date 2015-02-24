#Clean
rm WMS_*.tar

#ZIP
DATE=`date +%Y%m%d`
FILENAME="WMS_$DATE.tar"
cd release/
tar cvf $FILENAME WMS

#Send
scp $FILENAME websqrd@websqrd.com:~/tomcat6/

#Clean
rm $FILENAME
