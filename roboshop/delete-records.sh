#!/bin/bash
DELETE_RECORD (){
  aws route53 list-resource-record-sets --hosted-zone-id Z05238653F1UHIRHF2JKO --query "ResourceRecordSets[?Type == 'A'].Name" &>/tmp/recordlist.txt
  sed -i -e 's/.",//' -e 's/"//' -e 's/."//' /tmp/recordlist.txt
  for recordset in 'cat /tmp/recordlist.txt';do
    echo $recordset
  done

}

DELETE_RECORD