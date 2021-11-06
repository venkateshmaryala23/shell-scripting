#!/bin/bash

source components/common.sh

Print "Downloading"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
Stat $?

Print "Installing Mongodb"
yum install -y mongodb-org &>>"$LOG"
Stat $?

Print "Enabling Mongod service"
systemctl enable mongod &>>"$LOG"
Stat $?

Print "Starting mongd service"
systemctl start mongod &>>"$LOG"
systemctl --type=service | grep mongd &>>"$LOG"
Stat $?

Print "checking service status"
mstatus=$(systemctl is-active mongod.service)
Service $mstatus

exit 5

#Update Liste IP address from 127.0.0.1 to 0.0.0.0 in config file
#Config file: /etc/mongod.conf

#then restart the service

# systemctl restart mongod
Every Database needs the schema to be loaded for the application to work.
Download the schema and load it.

# curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

# cd /tmp
# unzip mongodb.zip
# cd mongodb-main
# mongo < catalogue.js
# mongo < users.js
