#!/bin/bash

# PRE: files must exist.

if [ $# -ne 4 ]; then
    echo "Usage: ./recover_files.sh user backup path file"
    exit 1
fi

readonly remote='192.168.126.189'
readonly user=$1
readonly backup=$2
path=$3
file=$4
isDir=$5

ssh syncbackup@$remote mkdir -p $path

if [ $isDir -eq 0 ]; then
    error=$(rsync -aru --no-perms /home/xarxes/backups/$user/$backup/$path/$file syncbackup@$remote:/home/$user/files/$path/$file 2>&1> /dev/null)
else
    error=$(rsync -aru --no-perms /home/xarxes/backups/$user/$backup/$path/$file syncbackup@$remote:/home/$user/files/$path 2>&1> /dev/null)
fi

if [ $? -eq 23 ]; then
    lines=$(echo "$error" | wc -l)
    [ $lines -eq 2 ] && [[ "$error" == *"failed to set times on \"/home/$user/files/.\""* ]] && exit 0
fi
