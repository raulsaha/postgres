#!/bin/bash

# Variables
POSTGRES_VERSION=17.2
INSTALL_DIR=/usr/local/pgsql
DATA_DIR=/usr/local/pgsql/data

# Update package list and install dependencies
sudo apt-get update
sudo apt-get install -y wget build-essential libreadline-dev zlib1g-dev

# Download PostgreSQL source code
wget https://ftp.postgresql.org/pub/source/v$POSTGRES_VERSION/postgresql-$POSTGRES_VERSION.tar.gz
tar -xzf postgresql-$POSTGRES_VERSION.tar.gz
cd postgresql-$POSTGRES_VERSION

# Configure, compile, and install PostgreSQL
./configure --prefix=$INSTALL_DIR
make
sudo make install

# Create PostgreSQL user and data directory
sudo useradd postgres
sudo mkdir -p $DATA_DIR
sudo chown postgres $DATA_DIR

# Initialize the database
sudo -u postgres $INSTALL_DIR/bin/initdb -D $DATA_DIR

# Create a systemd service file for PostgreSQL
sudo bash -c 'cat <<EOF > /etc/systemd/system/postgresql.service
[Unit]
Description=PostgreSQL database server
After=network.target

[Service]
Type=forking
User=postgres
ExecStart=$INSTALL_DIR/bin/pg_ctl start -D $DATA_DIR -l $DATA_DIR/logfile
ExecStop=$INSTALL_DIR/bin/pg_ctl stop -D $DATA_DIR
ExecReload=$INSTALL_DIR/bin/pg_ctl reload -D $DATA_DIR
PIDFile=$DATA_DIR/postmaster.pid

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd, enable and start PostgreSQL service
sudo systemctl daemon-reload
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "PostgreSQL $POSTGRES_VERSION installation completed."