#!/bin/bash

# 0 is script name
echo 0 = $0
#1 is for first argument
echo 1 = $1
#2 is for second argument
echo 2 = $2
#3 is for third argument
echo 3 = $3
#4 is for four arguments
echo 4 = $4

## * and @ are giving all the arguments
echo "* = $*"
echo "@ = $@"

# #denotes number of arguments passed as inputs
echo "# = $#"