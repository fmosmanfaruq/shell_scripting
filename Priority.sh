#!/bin/bash

echo "Priority Scheduling (Non-Preemptive) with Arrival Time"

read -p "Enter number of processes: " n

for ((i=0; i<n; i++))
do
    pid[$i]=$i
    read -p "Enter Arrival Time for P[$i]: " at[$i]
    read -p "Enter Burst Time for P[$i]: " bt[$i]
    read -p "Enter Priority for P[$i] (lower number = higher priority): " pr[$i]
    is_completed[$i]=0
done

time=0
completed=0

gantt="|"
timeline="0"

while [ $completed -lt $n ]
do
    idx=-1
    min_priority=9999

    # Find process
    for ((i=0; i<n; i++))
    do
        if [[ ${at[$i]} -le $time && ${is_completed[$i]} -eq 0 ]]
        then
            if [[ ${pr[$i]} -lt $min_priority ]]
            then
                min_priority=${pr[$i]}
                idx=$i
            elif [[ ${pr[$i]} -eq $min_priority ]]
            then
                if [[ $idx -eq -1 || ${at[$i]} -lt ${at[$idx]} ]]
                then
                    idx=$i
                fi
            fi
        fi
    done

    # If no process available → IDLE
    if [[ $idx -eq -1 ]]
    then
        gantt+=" IDLE |"
        ((time++))
        timeline+=" $time"
    else
        gantt+=" P$idx |"
        ((time+=${bt[$idx]}))

        ct[$idx]=$time
        tat[$idx]=$((ct[$idx] - at[$idx]))
        wt[$idx]=$((tat[$idx] - bt[$idx]))

        is_completed[$idx]=1
        ((completed++))

        timeline+=" $time"
    fi
done

# ---- OUTPUT ----
echo ""
echo "Gantt Chart:"
echo "$gantt"
echo "$timeline"

echo ""
printf "%-8s %-7s %-5s %-8s %-10s %-11s %-7s\n" "Process" "Arrival" "Burst" "Priority" "Completion" "Turnaround" "Waiting"

for ((i=0; i<n; i++))
do
    printf "%-8s %-7s %-5s %-8s %-10s %-11s %-7s\n" "P[$i]" "${at[$i]}" "${bt[$i]}" "${pr[$i]}" "${ct[$i]}" "${tat[$i]}" "${wt[$i]}"
done

# ---- AVERAGES ----
sum_tat=0
sum_wt=0
for ((i=0; i<n; i++))
do
    sum_tat=$((sum_tat + tat[$i]))
    sum_wt=$((sum_wt + wt[$i]))
done

avg_wt=$(awk "BEGIN {printf \"%.2f\", $sum_wt/$n}")
avg_tat=$(awk "BEGIN {printf \"%.2f\", $sum_tat/$n}")

echo ""
echo "Average Turnaround Time: $avg_tat"
echo "Average Waiting Time: $avg_wt"