#!/bin/bash

echo "Enter number of processes:"
read n

declare -a pid at bt ct tat wt

# Input
for ((i=0;i<n;i++))
do
    echo "Enter Arrival Time for Process P$i:"
    read at[$i]
    echo "Enter Burst Time for Process P$i:"
    read bt[$i]
    pid[$i]=$i
done

# Sort according to Arrival Time (FCFS)
for ((i=0;i<n;i++))
do
    for ((j=i+1;j<n;j++))
    do
        if [ ${at[$i]} -gt ${at[$j]} ]
        then
            # Swap AT
            temp=${at[$i]}
            at[$i]=${at[$j]}
            at[$j]=$temp

            # Swap BT
            temp=${bt[$i]}
            bt[$i]=${bt[$j]}
            bt[$j]=$temp

            # Swap PID
            temp=${pid[$i]}
            pid[$i]=${pid[$j]}
            pid[$j]=$temp
        fi
    done
done

current_time=0
total_wt=0
total_tat=0
total_idle=0

# ---- CALCULATION ----
for ((i=0;i<n;i++))
do
    if [ $current_time -lt ${at[$i]} ]
    then
        idle_time=$(( ${at[$i]} - current_time ))
        total_idle=$(( total_idle + idle_time ))
        current_time=${at[$i]}
    fi

    ct[$i]=$((current_time + bt[$i]))
    tat[$i]=$((ct[$i] - at[$i]))
    wt[$i]=$((tat[$i] - bt[$i]))

    total_wt=$((total_wt + wt[$i]))
    total_tat=$((total_tat + tat[$i]))

    current_time=${ct[$i]}
done

# ---- DISPLAY TABLE ----
echo ""
echo "PID  AT  BT  CT  TAT  WT"
for ((i=0;i<n;i++))
do
    echo "P${pid[$i]}   ${at[$i]}   ${bt[$i]}   ${ct[$i]}   ${tat[$i]}   ${wt[$i]}"
done

# Averages
avg_wt=$(awk "BEGIN {printf \"%.2f\", $total_wt/$n}")
avg_tat=$(awk "BEGIN {printf \"%.2f\", $total_tat/$n}")

echo ""
echo "Average Waiting Time: $avg_wt"
echo "Average Turnaround Time: $avg_tat"
echo "Total Idle Time: $total_idle"

# ---- GANTT CHART ----
echo ""
echo "Gantt Chart:"
echo -n "|"

current_time=0

for ((i=0;i<n;i++))
do
    if [ $current_time -lt ${at[$i]} ]
    then
        echo -n " IDLE |"
        current_time=${at[$i]}
    fi

    echo -n " P${pid[$i]} |"
    current_time=${ct[$i]}
done

echo ""
echo -n "0"

current_time=0
for ((i=0;i<n;i++))
do
    if [ $current_time -lt ${at[$i]} ]
    then
        echo -n "   ${at[$i]}"
        current_time=${at[$i]}
    fi

    echo -n "   ${ct[$i]}"
    current_time=${ct[$i]}
done

echo ""