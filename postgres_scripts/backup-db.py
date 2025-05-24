import subprocess
import datetime
import os

# Configuration
DB_NAME = "your_database"
DB_USER = "your_username"
DB_HOST = "localhost"
BACKUP_DIR = "./backups"
DATE_STR = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
BACKUP_FILE = f"{BACKUP_DIR}/{DB_NAME}_backup_{DATE_STR}.sql"

# Ensure backup directory exists
os.makedirs(BACKUP_DIR, exist_ok=True)

# Command to run pg_dump
dump_command = [
    "pg_dump",
    "-h", DB_HOST,
    "-U", DB_USER,
    "-F", "c",  # custom format
    "-b",       # include blobs
    "-f", BACKUP_FILE,
    DB_NAME
]

print(f"Backing up database '{DB_NAME}' to '{BACKUP_FILE}'...")
try:
    subprocess.run(dump_command, check=True)
    print("Backup completed successfully.")
except subprocess.CalledProcessError as e:
    print(f"Backup failed: {e}")

# Note: Set the PGPASSWORD environment variable or use a .pgpass file for password authentication.