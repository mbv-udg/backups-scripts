#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Wrong parameters: ./deleteUser.sh [username]"
    exit 1
fi

chown -R $1 /home/$1 &> /dev/null || { echo 'Error: check if you have the permissions needed'; exit 1; }
userdel -r $1 &> /dev/null

# Delete DB user
mysql -u root -e "drop database $1; delete from mysql.user where user = '$1'; drop user $1; flush privileges;"
