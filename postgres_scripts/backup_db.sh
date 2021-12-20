#!/bin/bash
## Backup Script of Postgres
## Script will take backup of individual database and global objects. Script is good if DB size is small and do not need backup of WAL Files
## Author - rahulsaha0309@gmail.com

set -x

DATE=`(date +"%Y-%m-%d")`
export PGPASSWORD=postgres
SIMPLE_DATE=`(date +"%Y%m%d")`
BACKUP_DIRECTORY=/opt/postgresql/postgres_backup/$SIMPLE_DATE
LOG_FILE_DIRECTORY=/opt/postgresql/postgres_backup/backup_log_file
BACKUP_USER=postgres
PG_DUMP=/opt/postgresql/pg96/bin/pg_dump
PORT=5432
PSQL=/opt/postgresql/pg96/bin/psql
DUMPALL=/opt/postgresql/pg96/bin/pg_dumpall

if [ ! -d $LOG_FILE_DIRECTORY ]
then
        /bin/mkdir  -p $LOG_FILE_DIRECTORY
else
        echo "Log File Directory exist"

fi

echo "Starting Backup of all databases"

if [ ! -d $BACKUP_DIRECTORY ]
then
 /bin/mkdir  -p $BACKUP_DIRECTORY
else
 echo "Backup Directory exist"
 
fi

LIST_DB=`$PSQL -t -d postgres -c "select datname from pg_database where datname not like 'template0' and datname not like 'template1';"`

array1=($LIST_DB)

for database in "${array1[@]}"

do
 BACKUP_DATABASE="$PG_DUMP -Fc -U$BACKUP_USER -p $PORT -d $database -f $BACKUP_DIRECTORY/backup_$database.sql"
    echo "Taking backup of DATABASE $database"
 $BACKUP_DATABASE
 
 if [ $? -eq 0 ] 
 then
            echo "Backup of $database completed successfully" 
 else
            echo "Backup of $database Failed" 
 fi

done

echo "BACKUP_GLOBAL_ROLES"

$DUMPALL -U$BACKUP_USER -p $PORT -g -f $BACKUP_DIRECTORY/backup_roles.sql

echo "Backup Completed sucessfully for all roles and databases"

echo " --------------------------"

echo "Cleaning up backup directory more than 7 days"

/bin/find /opt/postgresql/postgres_backup/* -type d -ctime +7 -exec rm -rf {} \;
/bin/find $LOG_FILE_DIRECTORY/* -mtime +7 -exec rm {} \;
#/bin/find /log/archivelog/* -mtime +2 -exec rm {} \;

echo "Cleanup job completed"
