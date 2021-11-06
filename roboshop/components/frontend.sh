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
systemctl --type=service | grep nginx
Stat $?

Print "checking service status"
status=systemctl is-active nginx.service
if [ $status == "active"]; then
  echo "Service is running"
else
  echo "service is not running "
fi

exit



curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-master static README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx