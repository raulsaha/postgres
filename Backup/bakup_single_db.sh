#!/bin/bash

# Variables
DB_NAME="your_database_name"
DB_USER="your_database_user"
BACKUP_DIR="/path/to/backup/directory"
DATE=$(date +%Y%m%d%H%M%S)
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$DATE.sql"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Take backup
pg_dump -U $DB_USER -F c -b -v -f $BACKUP_FILE $DB_NAME

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
else
    echo "Backup failed"
    exit 1
fi