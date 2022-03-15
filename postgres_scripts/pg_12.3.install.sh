#!/bin/bash
set -x

sudo su - <<EOF

/usr/bin/yum -y install gcc
/usr/bin/yum -y install readline-devel
/usr/bin/yum -y install zlib-devel


echo "Adding User for Postgres server"

/usr/sbin/useradd -d /home/postgres -m postgres
read -s -p "Enter password for postgres: " password
echo $password |passwd --stdin postgres
chage postgres -M -1


#/usr/sbin/useradd -d /home/postgres -m postgres
#passwd postgres
#read -p "New password:" postgres
#read -p "Retype new password " postgres

/usr/bin/wget https://ftp.postgresql.org/pub/source/v12.3/postgresql-12.3.tar.gz
/bin/tar -xzf postgresql-12.3.tar.gz
cd postgresql-12.3
/root/postgresql-12.3/configure --prefix=/usr/local/pgsql12/
make
make install

/bin/mkdir /usr/local/pgsql12/data
/bin/chown postgres:postgres -R /usr/local/pgsql12

EOF

sudo su - postgres <<EOF

cd /usr/local/pgsql12/bin
/usr/local/pgsql12/bin/initdb -D /usr/local/pgsql12/data
/usr/local/pgsql12/bin/pg_ctl -D /usr/local/pgsql12/data start

EOF

sudo su - <<EOF

/bin/ln -s /usr/local/pgsql12/bin/psql /usr/bin

EOF
