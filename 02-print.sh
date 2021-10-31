#!/bin/bash

## To print some text on the screen we can sue echo command or printf command
## we choose to go with echo command because of its less syntaxing

#syntax
#echo message to print

echo Hello world
echo welcome

#ECS Sequnces, \n (new line), \e (new tab)

#syntax: echo -e "Message\nNew Line"
# to enable any esc seq we need to enable -e option
# Also the input should be in quotes , Preferabley double quotes

echo -e "Hello World\nWelcome"

