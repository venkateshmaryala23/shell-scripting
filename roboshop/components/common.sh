#!/bin/bash

Print() {
  LSPACE=$(echo $1 | awk '{print length}')
  SPACE=$(($MSPACE-$LSPACE))
  SPACES=""
  while [ $SPACE -gt 0 ]; do
     SPACES="$SPACES$(echo ' ')"
     SPACE=$(($SPACE-1))
#     echo $SPACE
  done
  echo -n -e "\e[1m$1${SPACES}\e[0m ....."
  echo -e "\n\e[36m==============================$1==============================\e[0m" >>"$LOG"
}

Stat() {
  if [ "$1" -eq 0 ]; then
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

NODEJS(){
  Print "Installing nodjs"
  yum install nodejs make gcc-c++ -y &>>"$LOG"
  Stat $?

  Print "Adding Roboshop user"
  id roboshop &>>"$LOG"
  if [ $? -eq 0 ]; then
    echo roboshop user already exists &>>"$LOG"
  else
     useradd roboshop &>>"$LOG"
     echo roboshop  user created &>>"$LOG"
  fi
  Stat $?

  Print "Download $COMPONENT_NAME data"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>"$LOG"
  Stat $?

  Print "Remove old content"
  rm -rf /home/roboshop/${COMPONENT}
  Stat $?

  Print "Extracting userdata for $COMPONENT_NAME"
  #cd /home/roboshop
  unzip -o -d /home/roboshop /tmp/${COMPONENT}.zip &>>"$LOG"
  Stat $?

  Print "Copy content for $COMPONENT_NAME "
  mv /home/roboshop/${COMPONENT}-main /home/roboshop/${COMPONENT} &>>"$LOG"
  Stat $?

  Print "Install nodejs dependecies for $COMPONENT_NAME"
  cd /home/roboshop/${COMPONENT}
  npm install --unsafe-perm &>>"$LOG"
  Stat $?

  Print "Fix App permissions"
  chown -R roboshop:roboshop /home/roboshop/ &>>"$LOG"
  Stat $?

  Print "Update  $COMPONENT_NAME DNS records in SystemD Config"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>"$LOG"
  Stat $?

  Print "Copy SystemD file"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
  Stat $?

  Print "System $COMPONENT_NAME Service"
  systemctl daemon-reload &>>"$LOG" && systemctl start ${COMPONENT} &>>"$LOG" && systemctl enable ${COMPONENT} &>>"$LOG"
  Stat $?
}