#!/bin/shi

while ! mysqladmin ping -h master --silent; do
    sleep 1
done

if [ -v MYSQL_REPLICATION_USER -a -v MYSQL_REPLICATION_PASSWORD]; then
    mysql -u root -v mysql <<SQL
        CREATE USER '$MYSQL_REPLICATION_USER'@'%' IDENTIFIED BY '$MYSQL_REPLICATION_PASSWORD';
        GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPLICATION_USER'@'%';
SQL
fi
mysql -u root -v mysql <<SQL
    RESET MASTER;
    FLUSH TABLES WITH READ LOCK;
SQL
binlogfile=`mysql -u root -h master -e "SHOW MASTER STATUS\G" | grep File: | awk '{print $2}'`
position=`mysql -u root -h master -e "SHOW MASTER STATUS\G" | grep Position: | awk '{print $2}'`

mysqldump -u root -h master --all-databases --master-data > /tmp/master.sql
mysql -u root < /tmp/master.sql

mysql -u root -v -e "RESET SLAVE";
mysql -u root -v -e "CHANGE MASTER TO MASTER_HOST='master', MASTER_USER='root', MASTER_PASSWORD='', MASTER_LOG_FILE='${binlogfile}', MASTER_LOG_POS=${position};"
mysql -u root -v -e "START SLAVE;"

mysql -u root -h master -e "UNLOCK TABLES;"
