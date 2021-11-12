#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep ^Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)

Print "Installing nodjs"
yum install nodejs make gcc-c++ -y
Stat $?

Print "Adding Roboshop user"
id roboshop &>>"$LOG"
if [ $? -eq 0 ]; then
  echo roboshop user already exists
else
   useradd roboshop &>>"$LOG"
   echo roboshop  userd created
fi
Stat $?

#So let's switch to the roboshop user and run the following commands.
Print "Download User data"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>"$LOG"
Stat $?

Print "Extracting userdata"
#cd /home/roboshop
unzip -o -d /home/roboshop /tmp/user.zip &>>"$LOG"
Stat $?

Print "Copy content"
mv /home/roboshop/user-main /home/roboshop/user &>>"$LOG"
Stat $?

Print "Install nodejs dependecies"
cd /home/roboshop/user
npm install &>>"$LOG"
Stat $?

Print "Fix App permissions"
chown -R roboshop:roboshop /home/roboshop/
Stat $?

#Now, lets set up the service with systemctl.

# mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
# systemctl daemon-reload
# systemctl start user
# systemctl enable user