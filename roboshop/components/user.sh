#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep ^Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)

COMPONENT_NAME=User
COMPONENT=user

NODEJS

sleep 5

Print "Checking DB Connection from APP"
STATE=$(curl -s localhost:8080/health | jq .mongo)
if [ "$STATE" == "true" ]; then
  Stat 0
else
  Stat 1
fi
