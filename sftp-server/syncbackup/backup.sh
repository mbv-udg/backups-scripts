#!/bin/bash

readonly date=$(date +%F_%H-%M)
readonly remote="192.168.126.35"

strmember=$(getent group sftp | awk -F: '{print $4}' | tr "," " ")
members=( $strmember )

for m in "${members[@]}"; do
    dir="/home/xarxes/backups/${m}"
    sourcedir="/home/${m}/files/"
    path="${dir}/${date}"

    # Files backups
    rsync -az --rsync-path="mkdir -p ${path} && rsync" $sourcedir xarxes@$remote:$path

    # DB backups
    db="${dir}/db_${date}"
    mysqldump $m | ssh xarxes@$remote "cat > $db"
done
