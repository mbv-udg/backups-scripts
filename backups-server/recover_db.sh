#!/bin/bash

readonly remote='192.168.126.189'

if [ $# -ne 2 ]; then
     echo "Usage: ./recover_db.sh user backup"
     exit 1
fi

file="/home/xarxes/backups/$1/$2"

ssh syncbackup@$remote "mysql $1" < $file &> /dev/null

if [ $? -eq 1 ]; then
    ssh syncbackup@$remote "mysql -e \"CREATE DATABASE $1; \""
    ssh syncbackup@$remote "mysql $1" < $file
fi
