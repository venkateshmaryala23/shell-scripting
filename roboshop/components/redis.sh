#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep ^Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)


# yum install epel-release yum-utils -y
# yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
# yum-config-manager --enable remi
# yum install redis -y
Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf

Start Redis Database

# systemctl enable redis
# systemctl start redis