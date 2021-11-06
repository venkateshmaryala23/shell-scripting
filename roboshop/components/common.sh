#!/bin/bash

Print() {
  echo -n -e "\e[1m$1\e[0m ....."
  echo -e "\n\e[36m==============================$1==============================\e[0m" >>$LOG
}

Stat() {
  if [ $1 -eq 0 ]; then
   echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo -e "\e[1;33mScript is failed and plese check the details in $LOG file\e[0m"

  fi
}

LOG=/tmp/roboshop.log
rm -f $LOG