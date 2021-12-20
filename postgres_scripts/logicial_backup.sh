#!/bin/bash
## Backup Script of Postgres
## Script will take backup of individual database and global objects. Script is good if DB size is small and do not need backup of WAL Files
## Author - rahulsaha0309@gmail.com

set -x

export PGPASSWORD=PassWord!
DATE=`(date +"%Y-%m-%d")`
SIMPLE_DATE=`(date +"%Y%m%d")`
BACKUP_DIRECTORY=/tmp/postgres_backup/$SIMPLE_DATE
BACKUP_USER=postgres
PG_DUMP=/data/postgres/bin/pg_dump
PORT=5432
PSQL=/data/postgres/bin/psql
DUMPALL=/data/postgres/bin/pg_dumpall


if [ ! -d $BACKUP_DIRECTORY ]
then
 /bin/mkdir  -p $BACKUP_DIRECTORY
else
 echo " Backup Directory exist"
 
fi

TABLE_EXIST=`$PSQL -d audit -t -c "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE  table_schema = 'public' AND table_name='backup_logs')"`

if [ $TABLE_EXIST = f ]
    then
        $PSQL -d audit -c "create table backup_logs(date date, database varchar, status varchar, backup_location varchar)"
else
    echo "table_exist"
fi


LIST_DB=`$PSQL -t -d postgres -c "select datname from pg_database where datname not like 'postgres';"`

array1=($LIST_DB)
echo ${array1[@]}

for database in "${array1[@]}"

do
 BACKUP_DATABASE="$PG_DUMP -U$BACKUP_USER -p $PORT -d $database -f $BACKUP_DIRECTORY/backup_$database.sql"
    echo "Taking backup of DATABASE $database"
 $BACKUP_DATABASE
 
 if [ $? -eq 0 ]
 then
  $PSQL -d audit -c "insert into backup_logs values(current_timestamp, '$database', 'Success', '$BACKUP_DIRECTORY/backup_$database.sql')"
 else
  $PSQL -d audit -c "insert into backup_logs values(current_timestamp, '$database', 'Failed', '$BACKUP_DIRECTORY/backup_$database.sql')"
 fi

done

echo "BACKUP_GLOBAL_ROLES"

$DUMPALL -U$BACKUP_USER -p $PORT -g -f $BACKUP_DIRECTORY/backup_roles.sql
