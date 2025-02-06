import subprocess
import datetime

def backup_database(db_name, user, password, host, port, backup_dir):
    # Get current date and time for the backup file name
    current_time = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    backup_file = f"{backup_dir}/{db_name}_backup_{current_time}.sql"

    # Construct the pg_dump command
    command = [
        "pg_dump",
        f"--dbname=postgresql://{user}:{password}@{host}:{port}/{db_name}",
        "-F", "c",  # Custom format
        "-f", backup_file
    ]

    try:
        # Execute the pg_dump command
        subprocess.run(command, check=True)
        print(f"Backup successful: {backup_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error during backup: {e}")

if __name__ == "__main__":
    # Database connection details
    db_name = "your_db_name"
    user = "your_username"
    password = "your_password"
    host = "localhost"
    port = "5432"
    backup_dir = "/path/to/backup/directory"

    backup_database(db_name, user, password, host, port, backup_dir)