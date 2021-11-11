#!/bin/bash

Print() {
  #LSPACE=$(echo $1 | aws '{print length}')
  #echo $LSPACE
  echo -n -e "\e[1m$1\e[0m ....."
  echo -e "\n\e[36m==============================$1==============================\e[0m" >>$LOG
}

Stat() {
  if [ $1 -eq 0 ]; then
   echo -e "\e[1;32mSUCCESS\e[0m"
  else
    echo -e "\e[1;31mFAILURE\e[0m"
    echo -e "\e[1;33mScript is failed and plese check the details in $LOG file\e[0m"
    exit 1
  fi
}

Service(){
  if [ "$1" ==  "active" ]; then
    echo -e "\e[1;32mOK!!!!\e[0m"
    echo Service is running!!! &>>"$LOG"
  else
    echo -e "\e[1;31mNOT OK!!!!\e[0m"
    echo  Service is not running!!!! &>>"$LOG"
  fi
}

LOG=/tmp/roboshop.log
rm -f $LOG