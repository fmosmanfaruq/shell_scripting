#!/bin/bash
read -p "Enter your mark : " mark

if [ $mark -ge 80 ]; then
echo "You got A+"
elif [ $mark -ge 70 ]; then 
echo "You got A"
elif [ $mark -ge 60 ]; then
echo "You got B"
elif [ $mark -ge 50 ]; then 
echo "You got C"
else 
echo "You got F"
fi