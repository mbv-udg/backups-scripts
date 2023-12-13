#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Wrong parameters: ./createUser.sh [username]"
    exit 1
fi

echo -e "$1\n$1" | adduser $1 --gecos "" &> /dev/null || { echo 'Error: root permissions needed'; exit 1; }

usermod -aG sftp $1 

chown root:sftp /home/$1/
chmod 755 /home/$1/

mkdir -m 707 /home/$1/files/
chown $1:sftp /home/$1/files/

# Create DB user
mysql -u root -e "create user $1@'%' identified by '$1'; create database $1; grant all privileges on $1.* to '$1'@'%' identified by '$1'; grant all privileges on $1.* to backups@'localhost'; flush privileges;"
