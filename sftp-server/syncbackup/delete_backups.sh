#!/bin/bash

if [[ $1 -gt 3 ]]; then
    # Find first Sunday of the month
    month=$(date -d "2 months ago" +%m)
    year=$(date -d "2 months ago" +%Y)
    firstday=$(date -d "$year-$month-01" +%u)
    daystosun=$((7-$firstday))

    start=$((1+daystosun+7))
    end=$(date -d "$year-$month-01  +1 month -1 day" +%d)

    # Delete all weeks of 2 months ago
    hora="02-00"
    for i in $(seq -w $start 7 $end); do
      name="${year}-${month}-${i}_${hora}"
      rm -rf $2/$name
      rm -f $2/"db_${name}"
    done
fi

if [[ $1 -gt 2 ]]; then
    # Delete all days of 2 weeks ago
    hora="02-00"
    for i in $(seq -w 08 13); do
      date=$(date -d "${i} days ago" +%F)
      name="${date}_${hora}"
      rm -rf $2/$name
      rm -f $2/"db_${name}"
    done
fi

if [[ $1 -gt 1 ]]; then
    # Delete all hours of two days before
    date=$(date -d "2 days ago" +%F)
    for i in $(seq -w 00 23); do
      if [[ $((10#$i)) -ne 2 ]]; then
        name="${date}_${i}-00"
        rm -rf $2/$name
        rm -f $2/"db_${name}"
      fi
    done
fi

