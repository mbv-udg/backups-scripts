#!/bin/bash

# PRE: files must exist.

if [ $# -ne 5 ]; then
    echo "Usage: ./recover_files.sh user backup path file isDir"
    exit 1
fi

readonly remote='192.168.18.131'
readonly user=$1
readonly backup=$2
path=$3
file=$4
isDir=$5

# Create folder if it doesn't exist
ssh syncbackup@$remote mkdir -p $path

# Different command depending it it's a directory or file
if [ $isDir -eq 0 ]; then
    error=$(rsync -ar --no-perms /home/xarxes/backups/$user/$backup/$path/$file syncbackup@$remote:/home/$user/files/$path/$file 2>&1> /dev/null)
else
    error=$(rsync -ar --no-perms /home/xarxes/backups/$user/$backup/$path/$file syncbackup@$remote:/home/$user/files/$path 2>&1> /dev/null)
fi

# Don't show one specific error
if [ $? -eq 23 ]; then
    lines=$(echo "$error" | wc -l)
    [ $lines -eq 2 ] && [[ "$error" == *"failed to set times on \"/home/$user/files/.\""* ]]
elif [ $? -ne 0 ]; then
    exit $?
fi

ssh syncbackup@$remote "sudo chown -R $user:sftp /home/$user/files/"
