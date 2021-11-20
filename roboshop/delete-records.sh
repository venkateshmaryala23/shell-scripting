#!/bin/bash
DELETE_RECORD (){
  record_list=$(aws route53 list-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --query "ResourceRecordSets[?Type == 'A'].Name" | xargs)
  echo $record_list

}

DELETE_RECORD