#!/bin/bash

read -p 'enter user name :' username

if [ "$username" == "root" ]; then
  echo "Hey, You are root user"
else
  echo  "you are a non root user"
fi

if [ $UID -eq 0 ]; then
  echo  you are  root user
else
  echo you are a non root user
fi

ram

if [ $? -eq 0 ]; then
  echo  executed successfully
fi