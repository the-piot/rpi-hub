#!/bin/sh

if (  [ -z "${MYSQL_HOST}" ] || [ -z "${MYSQL_PORT}" ] || [ -z "${MYSQL_DATABASE}" ] || [ -z "${MYSQL_USER}" ] || [ -z "${MYSQL_PASSWORD}" ]); then
  echo "MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE, MYSQL_USER or MYSQL_PASSWORD not defined"
  exit 1
fi

sed -i -e "s/MYSQL_HOST/${MYSQL_HOST}/g" /credentials/mysql-account.json
sed -i -e "s/MYSQL_PORT/${MYSQL_PORT}/g" /credentials/mysql-account.json
sed -i -e "s/MYSQL_DATABASE/${MYSQL_DATABASE}/g" /credentials/mysql-account.json
sed -i -e "s/MYSQL_USER/${MYSQL_USER}/g" /credentials/mysql-account.json
sed -i -e "s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g" /credentials/mysql-account.json


if (  [ -z "${MOSQUITTO_HOST}" ] || [ -z "${MOSQUITTO_PORT}" ] || [ -z "${MOSQUITTO_USERNAME}" ] || [ -z "${MOSQUITTO_PASSWORD}" ]); then
  echo "MOSQUITTO_HOST, MOSQUITTO_PORT, MOSQUITTO_USERNAME or MOSQUITTO_PASSWORD not defined"
  exit 1
fi

sed -i -e "s/MOSQUITTO_HOST/${MOSQUITTO_HOST}/g" /credentials/mqtt-account.json
sed -i -e "s/MOSQUITTO_PORT/${MOSQUITTO_PORT}/g" /credentials/mqtt-account.json
sed -i -e "s/MOSQUITTO_USERNAME/${MOSQUITTO_USERNAME}/g" /credentials/mqtt-account.json
sed -i -e "s/MOSQUITTO_PASSWORD/${MOSQUITTO_PASSWORD}/g" /credentials/mqtt-account.json

n8n import:workflow --separate --input=/workflows/

for file in /credentials/*; do 
    if [ -f "$file" ]; then 
        n8n import:credentials --input=$file
    fi 
done



exec "$@"