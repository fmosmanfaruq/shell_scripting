#!/bin/bash

read -p "Enter a number : " num
count=0

while [ $num -ne 0 ] 
do 
    num=$((num/10))
    count=$((count+1))
done

echo "Total number is : $count"