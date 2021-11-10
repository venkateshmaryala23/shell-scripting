#!/bin/bash
source components/common.sh

cat $0

exit

Print "Installing nodejs"
yum install nodejs make gcc-c++ -y &>>"$LOG"
Stat $?

Print "Adding RoboShop user"
id roboshop &>>"$LOG"
if [ $? -eq 0 ]; then
  echo User RoboShop already exists &>>"$LOG"
else
  useradd roboshop &>>"$LOG"
  echo User roboshop created &>>"$LOG"
fi
Stat $?

Print "Downoading Catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>"$LOG"
Stat $?

Print "Remove Old Content"
rm -rf /home/roboshop/catalogue &>>"$LOG"
Stat $?

Print "Extracting  Catalogue"
unzip -o -d /home/roboshop /tmp/catalogue.zip &>>"$LOG"
Stat $?

Print "copy content"
mv /home/roboshop/catalogue-main /home/roboshop/catalogue
Stat $?

Print "Install NodeJs dependencies"
cd /home/roboshop/catalogue
npm install --unsafe-perm &>>"$LOG"
Stat $?

Print "Fix App Permissions"
chown -R roboshop:roboshop /home/roboshop
Stat $?

Print "Update DNS records in SystemD Config"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service &>>"$LOG"
Stat $?

Print "Copy SystemD file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
Stat $?

Print "System Catalogue Service"
systemctl daemon-reload &>>"$LOG" && systemctl start catalogue &>>"$LOG" && systemctl enable catalogue &>>"$LOG"
Stat $?

sleep 5

Print "Checking DB Connection from APP"
STATE=$(curl -s localhost:8080/health | jq .mongo)
if [ "$STATE" == "true" ]; then
  Stat 0
else
  Stat 1
fi


