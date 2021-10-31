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
echo -e "\e[33mText in yello color"
echo -e "\e[34mText in blue color"
echo -e "\e[35mText in Magenta color"
echo -e "\e[36mText in Cyan color"

# https://misc.flogisoft.com/bash/tip_colors_and_formatting

### Color always follows, When we enable color and its our responsibility to disable it as well, 0 col code is used to disable

echo -e "\e[31mText in red color"
echo -e "normal color"


