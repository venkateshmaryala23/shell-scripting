#!/bin/bash
DELETE() {
  COUNT=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 | jq ".Reservations[].Instances[].PrivateIpAddress"| grep -v null | wc -l)
  IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].PrivateIpAddress" | grep -v null | xargs)
  ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=$1 |jq ".Reservations[].Instances[].InstanceId" | xargs)
  sed -e "s/DNSNAME/$1.roboshop.internal./" -e "s/IPADRESS/${IP}/" delete_record.json >/tmp/drecord.json
  recordset=$(aws route53 list-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --query "ResourceRecordSets[?Name == '$1.roboshop.internal.']" | jq ".[].Name" | xargs)
  current_dnsname=$(cat /tmp/drecord.json | jq ".Changes[].ResourceRecordSet.Name" |xargs)
  #echo $recordset
  #echo $current_dnsname
  # echo $IP
  #echo $ID
  DNS_IP=$(aws route53 list-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --query "ResourceRecordSets[?Name == '$1.roboshop.internal.']" | jq ".[].ResourceRecords[].Value"|grep -v null |xargs)
# echo $DNS_IP

  if [ -z "$IP" ] && [ -z "$DNS_IP" ]; then
     echo -e "\e[1;33mThere is no dns record existed for $1 to delete\e[0m"
  elif [ -z "$DNS_IP" ]; then
      sed -e "s/DNSNAME/$1.roboshop.internal./" -e "s/IPADRESS/${DNS_IP}/" delete_record.json >/tmp/drecord.json
      aws route53 change-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --change-batch file:///tmp/drecord.json | jq &>/dev/null
      echo  "\e[1;33m no instance there but dns record existed so deleting dns for $1\e[0m"
  elif [ "$recordset" == "$current_dnsname" ];then
    aws route53 change-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --change-batch file:///tmp/drecord.json | jq &>/dev/null
    if [ $? == 0 ]; then
      echo -e "\e[1;33mremoved dns record for $1\e[0m"
    fi
  else
    echo -e "\e[1;33mDNS record already removed!!!No need to do again\e[0m"
  fi

  sleep 5
  if [ $COUNT -ne 0 ]; then

    aws ec2 terminate-instances --instance-ids $ID
    echo -e "\e[1;33mDeleted Instance - $ID ---$IP---$current_dnsname"
  else
    echo -e "\e[1;33m$1 Instance not availble\e[0m"
    return
  fi
 }

if [ "$1" == "all" ]; then
  ALL=(frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment)
  for component in ${ALL[*]}; do
    echo -e "\e[1;33mDeleting Instance - $component\e[0m"
    DELETE $component
  done
else
   DELETE $1
fi
