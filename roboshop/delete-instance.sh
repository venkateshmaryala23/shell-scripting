#!/bin/bash
DELETE() {
  COUNT=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 | jq ".Reservations[].Instances[].PrivateIpAddress"| grep -v null | wc -l)
  IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs)
  ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=cart |jq ".Reservations[].Instances[].InstanceId" | xargs)
  sed -e "s/DNSNAME/$1.roboshop.internal/" -e "s/IPADRESS/${IP}/" delete_record.json >/tmp/drecord.json
  echo $IP
  echo $ID
  if [ -z "$IP" ]; then
    echo "There is no $1 dns record to delete"
  else
    aws route53 change-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --change-batch file:///tmp/drecord.json | jq &>/dev/null

  fi

  sleep 5
  if [ $COUNT -ne 0 ]; then

    aws ec2 terminate-instances --instance-ids $ID
    echo "Deleted Instance - $1"
  else
    echo -e "\e[1;33m$1 Instance not availble\e[0m"
    return
  fi
 }

if [ "$1" == "all" ]; then
  ALL=(frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment)
  for component in ${ALL[*]}; do
    echo "Deleting Instance - $component "
    DELETE $component
  done
else
   DELETE $1
fi
