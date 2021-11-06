#!/bin/bash

Print() {
  echo -e "\e[92m$1\e[0m"
  echo -e "\n\e[36m==============================$1==============================\e[0m" >>$LOG
}

LOG=/tmp/roboshop.log
rm -f $LOG


Print "Installing Nginx"
yum install nginx -y &>>$LOG
if [ $? -eq 0 ]; then
 echo "\e[1;32mSUCCESS\e[0m"
else
  echo "\e[1;31mFAILURE\e[0m"
fi


Print "Enabling Nginx"
systemctl enable nginx


Print "Starting Nginx"
systemctl start nginx

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