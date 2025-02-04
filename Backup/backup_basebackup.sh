#!/bin/bash

# Configuration
PG_USER="your_pg_user"
PG_PASSWORD="your_pg_password"
PG_HOST="your_pg_host"
PG_PORT="your_pg_port"
BACKUP_DIR="/path/to/backup/dir"
LOG_FILE="/path/to/log/file"

# Export password for non-interactive authentication
export PGPASSWORD=$PG_PASSWORD

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Perform the base backup
pg_basebackup -h $PG_HOST -p $PG_PORT -U $PG_USER -D $BACKUP_DIR -F t -z -P -v > $LOG_FILE 2>&1

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Base backup completed successfully."
else
    echo "Base backup failed. Check the log file for details."
fi

# Unset the password
unset PGPASSWORD