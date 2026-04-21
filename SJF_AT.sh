#!/bin/bash

echo "Enter the number of processes:"
read n

arrival=()
burst=()
process=()
ct=()
tat=()
wt=()
completed=()

# Input
for ((i=0; i<n; i++))
do
    echo "Enter arrival time for P$((i+1)):"
    read arrival[$i]
    echo "Enter burst time for P$((i+1)):"
    read burst[$i]
    process[$i]=$((i+1))
    completed[$i]=0
done

time=0
count=0

gantt="|"
timeline="0"

# ---- SJF LOGIC ----
while [ $count -lt $n ]
do
    min_bt=9999
    min_index=-1

    for ((i=0; i<n; i++))
    do
        if [[ ${arrival[$i]} -le $time && ${completed[$i]} -eq 0 ]]
        then
            if [[ ${burst[$i]} -lt $min_bt ]]
            then
                min_bt=${burst[$i]}
                min_index=$i
            fi
        fi
    done

    # If no process available → IDLE
    if [[ $min_index -eq -1 ]]
    then
        gantt+=" IDLE |"
        ((time++))
        timeline+=" $time"
    else
        gantt+=" P${process[$min_index]} |"

        ct[$min_index]=$((time + burst[$min_index]))
        tat[$min_index]=$(( ct[$min_index] - arrival[$min_index] ))
        wt[$min_index]=$(( tat[$min_index] - burst[$min_index] ))

        time=${ct[$min_index]}
        completed[$min_index]=1
        ((count++))

        timeline+=" $time"
    fi
done

# ---- OUTPUT ----
echo ""
echo "Process  AT  BT  CT  TAT  WT"
for ((i=0; i<n; i++))
do
    echo "P${process[$i]}      ${arrival[$i]}   ${burst[$i]}   ${ct[$i]}   ${tat[$i]}   ${wt[$i]}"
done

# ---- AVERAGE (FIXED: using awk instead of bc) ----
total_wt=0
total_tat=0

for ((i=0; i<n; i++))
do
    total_wt=$(( total_wt + wt[$i] ))
    total_tat=$(( total_tat + tat[$i] ))
done

avg_wt=$(awk "BEGIN {printf \"%.2f\", $total_wt/$n}")
avg_tat=$(awk "BEGIN {printf \"%.2f\", $total_tat/$n}")

echo ""
echo "Average Waiting Time: $avg_wt"
echo "Average Turnaround Time: $avg_tat"

# ---- GANTT CHART ----
echo ""
echo "Gantt Chart:"
echo "$gantt"
echo "$timeline"