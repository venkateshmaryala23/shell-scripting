#!/bin/bash

## function should be always declared before using it, same like variable
##so that is the reason, Function we always find in starting of the scripts

function abc() {
  echo this is abc
  }
  
function SaanvithaDetails() {
 name="saanvitha"
 age=5
 class="lkg"
 echo "I am $name,\nmy age is $age \nmy class is $class"
}  

#main program
abc
SaanvithaDetails


