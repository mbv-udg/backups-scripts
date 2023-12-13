#!/bin/bash

readonly date=$(date +%F_%H-%M)
readonly remote="192.168.126.35"

strmember=$(getent group sftp | awk -F: '{print $4}' | tr "," " ")
members=( $strmember )

for m in "${members[@]}"; do
    dir="/home/xarxes/backups/${m}"
    sourcedir="/home/${m}/files/"
    path="${dir}/${date}"

    # Setmanals es faran el diumenge i mensuals el primer diumenge del mes
    weekday="$(date +%a)"
    daynum=$(date +%d)
    hour=$(date +%H)

    # Full backup - monthly
    if [[ "${weekday}" = "Sun" && "${daynum}" -le 7 && "${hour}" -eq 2 ]]; then
      rsync -azu --rsync-path="mkdir -p ${path} && rsync" $sourcedir xarxes@$remote:$path

      # Links change
      ssh xarxes@$remote 'bash -s' < links-change.sh 4 $dir $path

      # Delete old backups
      ssh xarxes@$remote 'bash -s' < delete_backups.sh 4 $dir

    # Diferential backup - weekly
    elif [[ "${weekday}" = "Sun" && "${hour}" -eq 2 ]]; then
      rsync -azu --rsync-path="mkdir -p ${path} && rsync" $sourcedir --link-dest $dir/weekly xarxes@$remote:$path

      # Links change
      ssh xarxes@$remote 'bash -s' < links-change.sh 3 $dir $path

      # Delete old backups
      ssh xarxes@$remote 'bash -s' < delete_backups.sh 3 $dir

    # Incremental backup - daily
    elif [[ "${hour}" -eq 2 ]]; then
      rsync -azu --rsync-path="mkdir -p ${path} && rsync" $sourcedir --link-dest $dir/daily xarxes@$remote:$path

      # Links change
      ssh xarxes@$remote 'bash -s' < links-change.sh 2 $dir $path

      # Delete old backups
      ssh xarxes@$remote 'bash -s' < delete_backups.sh 2 $dir

    # Hourly
    else
      rsync -azu --rsync-path="mkdir -p ${path} && rsync" $sourcedir --link-dest $dir/hourly xarxes@$remote:$path

      # Links change
      ssh xarxes@$remote 'bash -s' < links-change.sh 1 $dir $path

    fi

    # DB backups
    db="${dir}/db_${date}"
    mysqldump $m | ssh xarxes@$remote "cat > $db"
done
