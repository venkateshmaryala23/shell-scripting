#!/bin/bash
CREATE() {
     COUNT=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].PrivateIpAddress"| grep -v null | wc -l)
     if [ $COUNT -eq 0 ]; then
           echo "Creating Instance - $1"
           aws ec2 run-instances --image-id ami-0855cab4944392d0a --instance-type t3.micro --security-group-ids sg-07624ce53dbdfb0f8 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq
     else
           echo "$1 Instance already exist"
     fi
     echo "==========================="
     sleep 5
     IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs)
     sed -e "s/DNSNAME/$1.roboshop.internal/" -e "s/IPADRESS/${IP}/" record.json >/tmp/record.json
     echo "updating dns record for $1 instance"
     aws route53 change-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --change-batch file:///tmp/record.json
     echo "==========================="
}

if [ "$1" == "all" ]; then
  ALL=(frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment)
  for component in ${ALL[*]};do
    #echo "Creating Instance - $component"
    CREATE $component
  done
fi
exit


