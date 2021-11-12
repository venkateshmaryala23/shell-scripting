#!/bin/bash
source components/common.sh

MSPACE=$(cat $0 | grep Print | awk -F '"' '{print $2}' | awk '{print length}' | sort | tail -1)

COMPONENT_NAME=Cart
COMPONENT=cart
NODEJS
CHECK_MONGO_FROM_APP

