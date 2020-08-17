#!/bin/bash
set -x

sudo su - postgres <<EOF

/usr/local/pgsql96/bin/pg_ctl -D /usr/local/pgsql96/data start

EOF

sudo su - <<EOF

#/usr/bin/yum -y install gcc
#/usr/bin/yum -y install readline-devel
#/usr/bin/yum -y install zlib-devel


echo "Adding User for Postgres server"

#/usr/sbin/useradd -d /home/postgres -m postgres
#read -s -p "Enter password for postgres: " password
#echo $password |passwd --stdin postgres
#chage postgres -M -1


#/usr/sbin/useradd -d /home/postgres -m postgres
#passwd postgres
#read -p "New password:" postgres
#read -p "Retype new password " postgres

/usr/bin/wget https://ftp.postgresql.org/pub/source/v9.6.18/postgresql-9.6.18.tar.gz
rm -rf postgresql-9.6.18
/bin/tar -xzf postgresql-9.6.18.tar.gz
cd postgresql-9.6.18
/root/postgresql-9.6.18/configure --prefix=/usr/local/pgsql96/
make
make install

rm -rf /usr/local/pgsql96/data
/bin/mkdir /usr/local/pgsql96/data
/bin/chown postgres:postgres -R /usr/local/pgsql96

EOF

sudo su - postgres <<EOF

cd /usr/local/pgsql96/bin
/usr/local/pgsql96/bin/initdb -D /usr/local/pgsql96/data
/usr/bin/perl -i -p -e "s/\#listen_addresses = 'localhost'/listen_addresses = '*'/;" /usr/local/pgsql96/data/postgresql.conf
/usr/bin/perl -i -p -e "s/\#port = 5432/port = 5433/;" /usr/local/pgsql96/data/postgresql.conf
/usr/local/pgsql96/bin/pg_ctl -D /usr/local/pgsql96/data start

EOF

