#!/bin/bash
CREATE() {
  COUNT=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 | jq ".Reservations[].Instances[].PrivateIpAddress"| grep -v null | wc -l)

  if [ $COUNT -eq 0 ]; then

    aws ec2 run-instances --image-id ami-0855cab4944392d0a --instance-type t3.micro --security-group-ids sg-07624ce53dbdfb0f8 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq &>/dev/null
    echo "Created Instance - $1"
  else
    echo -e "\e[1;33m$1 Instance already exist\e[0m"
    return
  fi

  sleep 5

  IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs)
  sed -e "s/DNSNAME/$1.roboshop.internal/" -e "s/IPADRESS/${IP}/" record.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --change-batch file:///tmp/record.json | jq &>/dev/null
}

if [ "$1" == "all" ]; then
  ALL=(frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment)
  for component in ${ALL[*]}; do
    echo "Creating Instance - $component "
    CREATE $component
  done
else
   CREATE $1
fi



