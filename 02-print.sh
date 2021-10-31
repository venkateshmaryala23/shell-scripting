#!/bin/bash

## To print some text on the screen we can sue echo command or printf command
## we choose to go with echo command because of its less syntaxing

#syntax
#echo message to print

echo Hello world
echo welcome

#ECS Sequnces, \n (new line), \e (new tab)

#Syntax: echo -e "Message\nNew Line"
# to enable any esc seq we need to enable -e option
# Also the input should be in quotes , Preferabley double quotes

echo -e "Hello World\nWelcome"

echo -e "word1\tword2"

echo -e "venkatesh\nMounika"

#Colored output
#syntax: echo -e "\e[COLmMessage"

## Colors CODE
#Red      31
#Green    32
#Yellow   33
#Blue     34
#Magenta  35
#Cyan     36

echo -e "\e[31mText in Red Color"
echo -e "\e[32mText in Green color"
echo -e "Text in yello color"
echo -e "Text in blue color"
echo -e "Text in Magenta color"
echo -e "Text in Cyan color"


