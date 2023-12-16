#!/bin/bash

# POST: Deletes old backups of all users
readonly date=$(date +%F_%H-%M)
readonly one_year=$(date -d "1 year ago" +%F_%H-%M)

strmember=$(ls /home/xarxes/backups/)
members=( $strmember )

for m in "${members[@]}"; do
    dir="/home/xarxes/backups/${m}"

    # Delete users with 1 year of inactivity
    last=$(ls $dir | grep -v '^db_' | sort -V | tail -n 1)

    if [[ "${one_year}" > "${last}" ]]; then
      rm -rf $dir
      continue
    fi 

    weekday="$(date +%a)"
    daynum=$(date +%d)
    hour=$(date +%H)

    # Monthly
    if [[ "${weekday}" = "Sun" && "${daynum}" -le 7 && "${hour}" -eq 2 ]]; then
      delete_backup.sh 4 $dir
    # Weekly
    elif [[ "${weekday}" = "Sun" && "${hour}" -eq 2 ]]; then
      delete_backup.sh 3 $dir
    # Daily
    elif [[ "${hour}" -eq 2 ]]; then
      delete_backup.sh 2 $dir
    fi
done
