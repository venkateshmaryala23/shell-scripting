#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)

COMPONENT_NAME=User
COMPONENT=user

NODEJS

Print "Checking DB Connection from APP"
sleep 5
STATE=$(curl -s localhost:8080/health | jq .mongo)
if [ "$STATE" == "true" ]; then
  Stat 0
else
  Stat 1
fi
