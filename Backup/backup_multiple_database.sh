#!/bin/bash

# Database credentials
HOST="localhost"
USER="your_username"
PASSWORD="your_password"

# Backup directory
BACKUP_DIR="/path/to/backup/directory"

# Get the list of databases
DATABASES=$(psql -h $HOST -U $USER -d postgres -t -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

# Export password to avoid password prompt
export PGPASSWORD=$PASSWORD

# Loop through each database and create a backup
for DB in $DATABASES; do
    echo "Backing up database: $DB"
    pg_dump -h $HOST -U $USER -d $DB -F c -b -v -f "$BACKUP_DIR/$DB.backup"
done

# Unset the password
unset PGPASSWORD

echo "Backup completed."