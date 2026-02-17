#!/bin/bash

arr=(2 2 1 3 5 2 5 6 3)
read -p "Enter the number to search: " k
count=0

for i in "${arr[@]}"
do
    if [ $i -eq $k ]; then
    count=$((count+1))
    fi
done
echo "Occurrence: $count"