#!/bin/bash
CREATE () {
  COUNT=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].PrivateIpAddress"| grep -v null | wc -l)

  ec2_state_code=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].State.Code")

  #echo $ec2_state_code

  if [ $COUNT -eq 0 ]; then
     echo "There is no instance existed.... so creating instance for your $1 ec2 instance"
     aws ec2 run-instances --image-id ami-0dc863062bc04e1de --instance-type t3.micro --security-group-ids sg-07624ce53dbdfb0f8 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq
  else
     #echo "Instance already exists"
     for x in $ec2_state_code;do
        #echo $x
        if [ $x == 0 ]; then
          echo "$1 Instance is exists but it is in pending status"
        elif [ $x == 16 ]; then
          echo  "$1 Instance is already exists, It is in running state"
        elif [ $x ==  32 ]; then
          echo "$1 Instance is already exist but its statu is shutting-down"
        elif [ $x == 64 ]; then
          echo "$1 Instance is already exist but its status is stopping"
        elif [ $x == 80 ]; then
          echo "$1 Instance is already exist but the instance is stopped"
        fi
    done
  fi

  sleep 5
  IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs)
  sed -e "s/DNSNAME/$1.roboshop.internal/" -e "s/IPADRESS/${IP}/" record.json >/tmp/record.json
  echo "updating dns record for $1 instance"
  aws route53 change-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --change-batch file:///tmp/record.json

  #sed -e "s/UPSERT/CREATE/" -e "s/DNSNAME/test.roboshop.internal/" -e "s/IPADRESS/5.5.5.5/" record.json >/tmp/create_record.json

  #aws route53 change-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --change-batch file:///tmp/create_record.json

  #https://github.com/venkateshmaryala23/shell-scripting.git
}

if [ "$1" == "all" ]; then
  ALL=(frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment)
  for component in ${ALL[*]}; do
    #echo "Creating instance - $component"
    CREATE $component
  done
fi