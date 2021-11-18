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

DOWNLOAD(){
  Print "Download $COMPONENT_NAME data"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>"$LOG"
  Stat $?
  Print "Extracting userdata for $COMPONENT_NAME"
  unzip -o -d $1 /tmp/${COMPONENT}.zip &>>"$LOG"
  Stat $?
  if [ "$1" == "/home/roboshop" ]; then
    Print "Remove old content"
    rm -rf /home/roboshop/${COMPONENT}
    Stat $?
    Print "Copy content for $COMPONENT_NAME"
    mv /home/roboshop/${COMPONENT}-main /home/roboshop/${COMPONENT} &>>"$LOG"
    Stat $?
  fi

}

ROBOSHOP_USER(){
  Print "Adding Roboshop user"
  id roboshop &>>"$LOG"
  if [ $? -eq 0 ]; then
      echo roboshop user already exists &>>"$LOG"
  else
       useradd roboshop &>>"$LOG"
       echo roboshop  user created &>>"$LOG"
  fi
  Stat $?
}
SYSTEMD(){
  Print "Fix App permissions"
    chown -R roboshop:roboshop /home/roboshop/ &>>"$LOG"
    Stat $?

    Print "Update DNS records in SystemD Config"
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>"$LOG"
    Stat $?

    Print "Copy SystemD file"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
    Stat $?

    Print "System $COMPONENT_NAME Service"
    systemctl daemon-reload &>>"$LOG" && systemctl start ${COMPONENT} &>>"$LOG" && systemctl enable ${COMPONENT} &>>"$LOG"
    Stat $?
}

PYTHON(){
  Print "Install Python 3"
  yum install python36 gcc python3-devel -y &>>"$LOG"
  Stat $?

  ROBOSHOP_USER
  DOWNLOAD "/home/roboshop" &>>"$LOG"

  Print "Install the dependencies"
  cd /home/roboshop/payment
  pip3 install -r requirements.txt &>>"$LOG"
  Stat $?

  #Update the roboshop user and group id in payment.ini file.

  SYSTEMD
}

MAVEN(){
   Print "Installing Maven"
   yum install maven -y &>>"$LOG"
   Stat $?

   ROBOSHOP_USER
   DOWNLOAD "/home/roboshop"

   Print "Make Maven Package"
   cd /home/roboshop/${COMPONENT}
   mvn clean package &>>"$LOG" && mv target/shipping-1.0.jar shipping.jar &>>"$LOG"
   Stat $?

   SYSTEMD
  }

NODEJS(){
  Print "Installing nodjs"
  yum install nodejs make gcc-c++ -y &>>"$LOG"
  Stat $?

  ROBOSHOP_USER
  DOWNLOAD "/home/roboshop"

  Print "Install nodejs dependecies for $COMPONENT_NAME"
  cd /home/roboshop/${COMPONENT}
  npm install --unsafe-perm &>>"$LOG"
  Stat $?

  SYSTEMD
}

CHECK_MONGO_FROM_APP(){
  Print "Checking DB Connection from APP"
  sleep 5
  STATE=$(curl -s localhost:8080/health | jq .mongo)
  if [ "$STATE" == "true" ]; then
    Stat 0
  else
    Stat 1
  fi
}

CHECK_REDIS_FROM_APP(){
  Print "Checking DB Connection from APP"
  sleep 5
  STATE=$(curl -s localhost:8080/health | jq .redis)
  if [ "$STATE" == "true" ]; then
    Stat 0
  else
    Stat 1
  fi
}