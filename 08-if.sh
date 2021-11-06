#!/bin/bash

uptime
echo $?
if [ $?==0 ]; then
  echo "command executed successful"

fi