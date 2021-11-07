#!/bin/bash

COUNT=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].PrivateIpAddress"| grep -v null | wc -l)

ec2_state_code=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].State.Code")

#echo $ec2_state_code

if [ $COUNT -eq 0 ]; then
     aws ec2 run-instances --image-id ami-0dc863062bc04e1de --instance-type t3.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq
else
  echo "Instance already exists"
  for x in $ec2_state_code;do
    echo $x
    if [ $x == 0 ]; then
      echo "Instance is exists but it is in pending status"
    elif [ $x == 16 ]; then
      echo  "Instance is already exists, It is in running state"
    elif [ $x ==  32 ]; then
      echo "Instance is already exist but its statu is shutting-down"
    elif [ $x == 64 ]; then
      echo "Instance is already exist but its status is stopping"
    elif [ $x == 80 ]; then
      echo "Instance is already exist but the instance is stopped"
      fi
  done
fi

