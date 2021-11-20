#!/bin/bash
#loops are two major commands, while & for

#while loop works on Expression that we used in if statment

a=10
while [ $a -gt 0 ];do
  echo while loop $a output
  sleep 0.5
  a=$(($a-1))
done

#syntx: for var in items ; do commands ;done
for fruit in apple bananana arrage peach ; do
  echo Fruit name is $fruit
done

echo -n "checking connection on port 22 for host $1 "
while true ; do
  nc -w 1 -z $1 22 &>/dev/null
  if [ $? -eq 0 ]; then
    echo "port 22 identified!!!!"
    break
  fi
  echo -n '.'
done