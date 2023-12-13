#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <username> <password> <remote_ip>"
  exit 1
fi

# Try to connect to the sftp session
echo "exit" | sshpass -p "${2}" sftp  $1@$3 &> /dev/null

if [ "$?" -eq 0 ]; then
    exit 0
fi
exit 2

