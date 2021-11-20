#!/bin/bash
#loops are two major commands, while & for

#while loop works on Expression that we used in if statment

a=10
while [ $a -gt 0];do
  echo while loop
  a=$(($a-1))
  done
