#!/bin/bash
source components/common.sh

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

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue