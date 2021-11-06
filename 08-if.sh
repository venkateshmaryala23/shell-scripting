#!/bin/bash

read -p 'enter user name :' username

if [ "$username" == "root" ]; then
  echo "Hey, You are root user"
else
  echo  "you are a non root user"
fi