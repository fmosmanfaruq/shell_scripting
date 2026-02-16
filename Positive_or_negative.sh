#!/bin/bash 

read -p "Enter the number : " num
 
if [ $num -gt 0 ]; then
echo "Number is positve"
elif [ $num -lt 0 ]; then 
echo "Number is negative"
else
echo "Number is Zero"
fi