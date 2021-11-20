#!/bin/bash
#loops are two major commands, while & for

#while loop works on Expression that we used in if statment

a=10
while [ $a -gt 0 ];do
  echo while loop $a output
  sleep 5
  a=$(($a-1))
done

#syntx: for var in items ; do commands ;done
for fruit in apple bananana arrage peach ; do
  echo Fruit name is $fruit
done

