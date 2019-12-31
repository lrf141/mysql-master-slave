#!/bin/sh

if [ -v MYSQL_REPLICATION_USER -a -v MYSQL_REPLICATION_PASSWORD ]; then
    mysql -u root -v mysql <<SQL
        CREATE USER '$MYSQL_REPLICATION_USER'@'%' IDENTIFIED BY '$MYSQL_REPLICATION_PASSWORD';
        GRANT REPLICATION SLAVE ON *.* TO '$MYSQL_REPLICATION_USER'@'%';
SQL
fi

mysql -u root -v mysql <<SQL
    RESET MASTER;
    FLUSH TABLES WITH READ LOCK;
SQL
