#!/bin/bash
set -x

sudo su - postgres <<EOF

#stop the running instance. If we dont stop also, it will work. But we will need to restart later. 
/usr/local/pgsql12/bin/pg_ctl -D /usr/local/pgsql12/data stop

EOF

sudo su - <<EOF

#download the binaries
/usr/bin/wget https://ftp.postgresql.org/pub/source/v12.2/postgresql-12.2.tar.gz

rm -rf postgresql-12.2

/bin/tar -xzf postgresql-12.2.tar.gz
cd postgresql-12.2
/root/postgresql-12.2/configure --prefix=/usr/local/pgsql12/
make
make install

EOF

sudo su - postgres <<EOF

#Start PG
/usr/local/pgsql12/bin/pg_ctl -D /usr/local/pgsql12/data start

EOF

