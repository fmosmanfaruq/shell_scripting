#!/bin/bash

read -p "Enter how many numbers: " num
sum=0

for ((i=1; i<=num; i++))
do
    read -p "Enter numbers $i: " n
    sum=$((sum+n))
done
avg=$((sum/num))
echo "Sum is: $sum"
echo "Avg is: $avg"