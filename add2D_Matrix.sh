#!/bin/bash
a=(1 2 3 4)
b=(5 6 7 8)
c=()

rows=2
cols=2

for ((i=0; i<rows; i++))
do
    for ((j=0; j<cols; j++))
    do
        index=$(( i*cols + j ))
        c[$index]=$(( a[$index] + b[$index] ))
        echo -n "${c[$index]} "
    done
    echo
done