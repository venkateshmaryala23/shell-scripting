#!/bin/bash

Print() {
  echo -e "\e[42m$1\e[0m"
}

#echo -e "\e[1mInstalling Nginx...........\e[0m"
Print "Installing Nginx"
yum install nginx -y

#echo -e "\e[1mEnabling Nginx\e[0m"
Print "Enabling Nginx"
systemctl enable nginx

#echo -e "\e[1mStarting Nginx\e[0m"
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