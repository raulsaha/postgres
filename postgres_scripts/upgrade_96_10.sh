#!/bin/bash
set -x

sudo su - postgres <<EOF

/usr/local/pgsql10/bin/pg_ctl -D /usr/local/pgsql10/data stop
/usr/local/pgsql96/bin/pg_ctl -D /usr/local/pgsql96/data stop

EOF

sleep 10

sudo su - postgres <<EOF
#upgrade Step

/usr/local/pgsql10/bin/pg_upgrade -d /usr/local/pgsql96/data -D /usr/local/pgsql10/data -b /usr/local/pgsql96/bin -B /usr/local/pgsql10/bin

EOF

sleep 10

sudo su - postgres <<EOF

/usr/local/pgsql10/bin/pg_ctl -D /usr/local/pgsql10/data start

EOF

