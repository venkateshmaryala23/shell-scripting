#!/bin/bash

source components/common.sh

Print "Installing Nginx"
yum install nginx -y &>>"$LOG"
Stat $?

Print "Enabling Nginx"
systemctl enable nginx &>>"$LOG"
Stat $?

Print "Starting Nginx"
systemctl start nginx &>>"$LOG"
systemctl --type=service | grep nginx &>>"$LOG"
Stat $?

Print "checking service status"
nstatus=$(systemctl is-active nginx.service)
Service $nstatus

Print "Downloading Html pages"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
Stat $?

Print "Remove Old Html Pages"
rm -rf  /usr/share/nginx/html/*
Stat $?

Print "Extract Frontend Archive"
unzip -d /usr/share/nginx/html /tmp/frontend.zip &>>"$LOG"
Stat $?

#mv frontend-main/* .
#mv static/* .
#rm -rf frontend-master static README.md
#mv localhost.conf /etc/nginx/default.d/roboshop.conf

#systemctl restart nginx