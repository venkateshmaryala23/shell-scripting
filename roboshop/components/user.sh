#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep ^Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)

COMPONENT_NAME=User
COMPONENT=user

#Now, lets set up the service with systemctl.

# mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
# systemctl daemon-reload
# systemctl start user
# systemctl enable user


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
