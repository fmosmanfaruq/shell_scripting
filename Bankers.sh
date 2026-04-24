#!/bin/bash

echo "---- Banker's Algorithm (Shell Script) ----"

# Input
read -p "Enter number of processes: " n
read -p "Enter number of resource types: " m

# Declare arrays
declare -A alloc max need
declare -a avail finish safeSeq

# -------- ALLOCATION MATRIX --------
echo "Enter Allocation Matrix ($n x $m):"
for ((i=0; i<n; i++))
do
    read -a row
    for ((j=0; j<m; j++))
    do
        alloc[$i,$j]=${row[$j]}
    done
done

# -------- MAX MATRIX --------
echo "Enter Maximum Requirement Matrix ($n x $m):"
for ((i=0; i<n; i++))
do
    read -a row
    for ((j=0; j<m; j++))
    do
        max[$i,$j]=${row[$j]}
    done
done

# -------- AVAILABLE --------
echo "Enter Available Resources (size $m):"
read -a avail

# -------- NEED MATRIX --------
echo -e "\nNeed Matrix:"
for ((i=0; i<n; i++))
do
    for ((j=0; j<m; j++))
    do
        need[$i,$j]=$(( ${max[$i,$j]} - ${alloc[$i,$j]} ))
        echo -n "${need[$i,$j]} "
    done
    echo ""
done

# Initialize finish array
for ((i=0; i<n; i++))
do
    finish[$i]=0
done

count=0

# -------- BANKER'S ALGORITHM --------
while [ $count -lt $n ]
do
    found=0

    for ((i=0; i<n; i++))
    do
        if [ ${finish[$i]} -eq 0 ]
        then
            canAllocate=1

            for ((j=0; j<m; j++))
            do
                if [ ${need[$i,$j]} -gt ${avail[$j]} ]
                then
                    canAllocate=0
                    break
                fi
            done

            if [ $canAllocate -eq 1 ]
            then
                # Release resources
                for ((k=0; k<m; k++))
                do
                    avail[$k]=$(( ${avail[$k]} + ${alloc[$i,$k]} ))
                done

                safeSeq[$count]=$i
                finish[$i]=1
                ((count++))
                found=1
            fi
        fi
    done

    # Unsafe condition
    if [ $found -eq 0 ]
    then
        echo -e "\nThe system is NOT in a safe state."
        exit 1
    fi
done

# -------- OUTPUT --------
echo -e "\nThe system is in a SAFE state."
echo -n "Safe Sequence: "
for ((i=0; i<n; i++))
do
    echo -n "P${safeSeq[$i]} "
done
echo ""