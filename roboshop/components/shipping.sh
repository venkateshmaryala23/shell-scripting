#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)

COMPONENT_NAME=Shipping
COMPONENT=shipping
MAVEN


Print "checking DB Connection from App"
sleep 10
STAT=$(curl -s http://localhost:8080/health)
if [ "$STAT" == "OK" ]; then
  Stat 0
else
  Stat 1
fi