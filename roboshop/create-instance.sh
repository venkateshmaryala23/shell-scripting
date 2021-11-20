#!/bin/bash

for i in cart catalogue frontend mongodb mysql payment rabbitmq redis shipping user ; do
  COUNT=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$i |jq ".Reservations[].Instances[].PrivateIpAddress"| grep -v null | wc -l)

  if [ $COUNT -eq 0 ]; then
       aws ec2 run-instances --image-id ami-0855cab4944392d0a --instance-type t3.micro --security-group-ids sg-07624ce53dbdfb0f8 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq
  else
  echo " $i Instance already exists"
 fi
 sleep 5
 IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$i |jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs)
 sed -e "s/DNSNAME/$i.roboshop.internal/" -e "s/IPADRESS/${IP}/" record.json >/tmp/record.json
 echo "updating dns record for $i instance"
 aws route53 change-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --change-batch file:///tmp/record.json
done
