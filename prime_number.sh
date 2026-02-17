#!/bin/bash

read -p "Enter the number: " num
flag=0

for((i=2; i<num/2; i++))
do 
    if [ $((num%i)) -eq 0 ]; then
    flag=1
    break
    fi
done

if [ $num -le 1 ]; then
echo Not prime
elif [ $flag -eq 0 ]; then
echo Prime
else
echo Not prime
fi
