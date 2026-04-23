#!/bin/bash

echo "Enter number of processes:"
read n

declare -a bt rem_bt wt tat

# Input
for ((i=0; i<n; i++))
do
    echo -n "Enter Burst Time for Process P$i: "
    read bt[i]
    rem_bt[i]=${bt[i]}
done

echo -n "Enter Time Quantum: "
read tq

time=0
completed=0

gantt="|"
timeline="0"

# Round Robin Scheduling
while [ $completed -lt $n ]
do
    for ((i=0; i<n; i++))
    do
        if [ ${rem_bt[i]} -gt 0 ]
        then
            if [ ${rem_bt[i]} -gt $tq ]
            then
                time=$((time + tq))
                rem_bt[i]=$((rem_bt[i] - tq))
                gantt="$gantt P$i |"
                timeline="$timeline   $time"
            else
                time=$((time + rem_bt[i]))
                wt[i]=$((time - bt[i]))
                rem_bt[i]=0
                gantt="$gantt P$i |"
                timeline="$timeline   $time"
                ((completed++))
            fi
        fi
    done
done

# Calculate Turnaround Time
for ((i=0; i<n; i++))
do
    tat[i]=$((bt[i] + wt[i]))
done

# Output Table
echo ""
echo "P   BT   WT   TAT"
for ((i=0; i<n; i++))
do
    echo "P$i  ${bt[i]}   ${wt[i]}   ${tat[i]}"
done

# Averages
total_wt=0
total_tat=0

for ((i=0; i<n; i++))
do
    total_wt=$((total_wt + wt[i]))
    total_tat=$((total_tat + tat[i]))
done

avg_wt=$(awk "BEGIN {printf \"%.2f\", $total_wt/$n}")
avg_tat=$(awk "BEGIN {printf \"%.2f\", $total_tat/$n}")

echo ""
echo "Average Waiting Time: $avg_wt"
echo "Average Turnaround Time: $avg_tat"

# Gantt Chart Output
echo ""
echo "Gantt Chart:"
echo "$gantt"
echo "$timeline"