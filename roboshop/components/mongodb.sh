#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)

COMPONENT_NAME=MongoDB
COMPONENT=mongodb

Print "Downloading"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>"$LOG"
Stat $?

Print "Installing Mongodb"
yum install -y mongodb-org &>>"$LOG"
Stat $?

Print "Update MongoDB Config"
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>"$LOG"
Stat $?

Print "Starting mongodb service"
systemctl restart mongod &>>"$LOG"
systemctl --type=service | grep mongod &>>"$LOG"
Stat $?

Print "checking service status"
mstatus=$(systemctl is-active mongod.service)
Service "$mstatus"

Print "Enabling Mongod service"
systemctl enable mongod &>>"$LOG"
Stat $?

Print "Download Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>"$LOG"
Stat $?

Print "Extract Schema"
unzip -o -d /tmp /tmp/mongodb.zip &>>"$LOG"
Stat $?

Print "Loading Schema"
cd /tmp/mongodb-main
mongo < catalogue.js &>>"$LOG"
mongo < users.js &>>"$LOG"
Stat $?
