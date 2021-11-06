#!/bin/bash


echo -n -e "\e[1mdownloading\e[0m......"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
if [ $? -eq 0 ]; then
    echo "success"
else
    echo "failed"
fi

LOG=/tmp/roboshop.log
echo -n -e "\e[1mInstalling Mongodb\e[0m......."
yum install -y mongodb-org &>>$LOG
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "failed"
fi

echo -n -e "\e[1mEnabling mongo service\e[0m.........."
systemctl enable mongod
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "failed"
fi
echo -n -e "\e[1mStarting mongo service\e[0m......"
systemctl start mongod
if [ $? -eq 0 ]; then
  echo "success"
else
  echo "failed"
fi

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
