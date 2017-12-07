#!/bin/env bash
dbs=(fpn_filestorage postgres)
psql -t -c "select usename from pg_user where usename not in  ('postgres', 'read', 'write', 'portal', 'zabbix', 'mobile', 'ipoteka', 'css', 'css_hide', 'sber_calc', 'cas_admin', 'mamonsu');" > /tmp/user

while read USER
do
	if [ $USER ]
	then
		for db in ${dbs[*]}
			do
				echo "Delete user "$USER
			        psql -d $db -c "REVOKE ALL ON DATABASE $db FROM  $USER ;"
			        psql -d $db -c "REVOKE USAGE ON SCHEMA public FROM  $USER ;"
			        psql -d $db -c "REVOKE ALL PRIVILEGES ON ALL sequences in schema public FROM  $USER cascade;"
			        psql -d $db -c "REVOKE ALL PRIVILEGES ON ALL FUNCTIONS in schema public FROM  $USER cascade;"
			        psql -d $db -c "REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM  $USER CASCADE;"
			done
		psql -d $db -c "DROP USER  $USER;"
	fi
done < /tmp/user

rm -f /tmp/user
