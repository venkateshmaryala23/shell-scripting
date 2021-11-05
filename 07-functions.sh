#!/bin/bash

## function should be always declared before using it, same like variable
##so that is the reason, Function we always find in starting of the scripts

function abc() {
  echo this is abc
  echo a in function = $a
  b=20
  echo 1st argument in function is = $1
  }
  

function xyz() {
    echo this is xyz
}

#main program
a=10
abc $2
echo b in main program =$b
xyz
echo 1st argument in main program = $1

