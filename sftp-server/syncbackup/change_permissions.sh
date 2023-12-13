#!/bin/bash

strmember=$(getent group sftp | awk -F: '{print $4}' | tr "," " ")
members=( $strmember )

for m in "${members[@]}"; do
    chmod -R 707 /home/$m/files
    chown -R $m:sftp /home/$m/files
done
