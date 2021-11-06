#!/bin/bash

ram
echo $?
if [ $? -eq 0 ]; then
 echo -e "\e[92mcommand executed successfully\e[0m"
fi