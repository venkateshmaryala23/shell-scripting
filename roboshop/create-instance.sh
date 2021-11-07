#!/bin/bash

aws ec2 run-instances --image-id ami-0dc863062bc04e1de --instance-type t3.micro --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]" | jq