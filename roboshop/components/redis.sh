#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep ^Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)

Print "Install Redis Repos "
# yum install epel-release yum-utils -y
yum install yum-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>"$LOG"
Stat $?

Print "Enable Redis"
yum-config-manager --enable remi &>>"$LOG"
Stat $?

Print "Install Redis"
yum install redis -y &>>"$LOG"
Stat $?

#Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf
Print "Updating Redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>"$LOG"
Stat $?

Print "Starting and enabling Redis"
systemctl enable redis &>>"$LOG" && systemctl start redis &>>"$LOG"
Stat $?