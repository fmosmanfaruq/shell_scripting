#!/bin/bash
arr=(5 3 1 4 2)
n=${#arr[@]}

for ((i=0; i<n; i++))
do
    for ((j=0; j<n-i-1; j++))
    do
        if [ ${arr[j]} -gt ${arr[j+1]} ]; then
            temp=${arr[j]}
            arr[j]=${arr[j+1]}
            arr[j+1]=$temp
        fi
    done
done

echo "Sorted Array: ${arr[@]}"