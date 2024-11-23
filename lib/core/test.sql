STOP SLAVE;
CHANGE MASTER TO
  MASTER_HOST = 'luckyjayagroup.com',
  MASTER_USER = 'replica_user',
  MASTER_PORT = 3307,
  MASTER_PASSWORD = 'password',
  MASTER_LOG_FILE = 'ON.000016',
  MASTER_LOG_POS =  335;
START SLAVE;



(mysqldump --host=luckyjayagroup.com --port=3307 --user=sic --password=Duaribu12  --result-file="/home/sparepart.sql" --add-drop-database --no-data --routines --triggers --no-create-info --skip-triggers sparepart) && (mysqldump --host=luckyjayagroup.com --port=3307 --user=sic --password=Duaribu12  --no-create-db  --routines sparepart >> /home/sparepart.sql)

(mysql -u sic -pDuaribu12 -e "DROP DATABASE IF EXISTS sparepart;" ) && (mysql -u sic -pDuaribu12 -e "create database sparepart;" ) && (mysql -u sic -pDuaribu12 sparepart < /home/sparepart.sql)