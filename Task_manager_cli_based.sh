#!/usr/bin/bash

LOG_FILE="system_log.txt"
ALERT_LOG="alert_log.txt"
HISTORY_FILE="history.txt"

CPU_THRESHOLD=80
RAM_THRESHOLD=50
DISK_THRESHOLD=90

REFRESH=5

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}=============================================="
    echo -e "        REALTIME SYSTEM MONITOR DASHBOARD   "
    echo -e "==============================================${NC}"
}

create_bar() {
    local value=$1
    local bar=""
    for ((i=0; i<value/2; i++))
    do
        bar+="#"
    done
    echo "$bar"
}

get_color() {
    local value=$1
    local threshold=$2

    if [ "$value" -gt "$threshold" ]; then
        echo $RED
    elif [ "$value" -gt 50 ]; then
        echo $YELLOW
    else
        echo $GREEN
    fi
}

get_cpu_usage() {
    top -bn1 | awk '/Cpu/ {print int($2)}'
}

get_ram_usage() {
    free | awk '/Mem/ {printf("%.0f", $3/$2 * 100)}'
}

get_disk_usage() {
    df -h / | awk 'NR==2 {print $5}' | sed 's/%//'
}

get_cpu_info() {
    grep -m 1 'model name' /proc/cpuinfo | cut -d ':' -f2
}

get_uptime() {
    uptime -p
}

get_kernel() {
    uname -r
}

get_os() {
    grep PRETTY_NAME /etc/os-release | cut -d '"' -f2
}

get_user() {
    whoami
}

get_network() {
    RX=$(cat /proc/net/dev | awk 'NR>2 {print $2}' | head -n1)
    TX=$(cat /proc/net/dev | awk 'NR>2 {print $10}' | head -n1)
    echo "⬇️ $RX bytes | ⬆️ $TX bytes"
}

show_top_processes() {
    echo -e "${MAGENTA}Top Processes:${NC}"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 10
}

alert_sound() {
    echo -e "\a"
}

log_alert() {
    echo "$(date) - ALERT: $1" >> "$ALERT_LOG"
}

check_alerts() {
    local CPU=$1
    local RAM=$2
    local DISK=$3

    if [ "$CPU" -gt "$CPU_THRESHOLD" ]; then
        echo -e "${RED}⚠️ CPU HIGH!${NC}"
        alert_sound
        log_alert "CPU HIGH ($CPU%)"
    fi

    if [ "$RAM" -gt "$RAM_THRESHOLD" ]; then
        echo -e "${RED}⚠️ RAM HIGH!${NC}"
        alert_sound
        log_alert "RAM HIGH ($RAM%)"
    fi

    if [ "$DISK" -gt "$DISK_THRESHOLD" ]; then
        echo -e "${RED}⚠️ DISK HIGH!${NC}"
        alert_sound
        log_alert "DISK HIGH ($DISK%)"
    fi
}

save_log() {
    local CPU=$1
    local RAM=$2
    local DISK=$3

    echo "$(date) | CPU:$CPU% RAM:$RAM% DISK:$DISK%" >> "$LOG_FILE"
    echo "$CPU $RAM $DISK" >> "$HISTORY_FILE"
}

show_history() {
    echo -e "${BLUE}Usage History:${NC}"
    tail -n 10 "$LOG_FILE"
    read -p "Press Enter to continue..."
}

dashboard() {
    while true
    do
        clear
        print_header

        TZ='Asia/Dhaka' date

        echo -e "${BLUE}User:${NC} $(get_user)"
        echo -e "${BLUE}OS:${NC} $(get_os)"
        echo -e "${BLUE}Kernel:${NC} $(get_kernel)"
        echo -e "${BLUE}Uptime:${NC} $(get_uptime)"
        echo -e "${BLUE}CPU:${NC} $(get_cpu_info)"

        echo ""

        CPU=$(get_cpu_usage)
        RAM=$(get_ram_usage)
        DISK=$(get_disk_usage)

        CPU=${CPU:-0}
        RAM=${RAM:-0}
        DISK=${DISK:-0}

        CPU_COLOR=$(get_color $CPU $CPU_THRESHOLD)
        RAM_COLOR=$(get_color $RAM $RAM_THRESHOLD)
        DISK_COLOR=$(get_color $DISK $DISK_THRESHOLD)

        echo -e "CPU  : ${CPU}%  ${CPU_COLOR}$(create_bar $CPU)${NC}"
        echo -e "RAM  : ${RAM}%  ${RAM_COLOR}$(create_bar $RAM)${NC}"
        echo -e "DISK : ${DISK}% ${DISK_COLOR}$(create_bar $DISK)${NC}"

        echo ""
        echo -e "${BLUE}Network:${NC} $(get_network)"
        echo ""

        show_top_processes

        echo ""
        echo "------------------------------------------"

        check_alerts $CPU $RAM $DISK
        save_log $CPU $RAM $DISK

        echo ""
        echo -e "${WHITE}Press Ctrl+C to return menu${NC}"

        sleep $REFRESH
    done
}
 menu() {
    while true
    do
        clear
        echo -e "${CYAN}========== MAIN MENU ==========${NC}"
        echo "1. Start Monitoring"
        echo "2. View Logs"
        echo "3. View Alerts"
        echo "4. View History"
        echo "5. Change Refresh Rate"
        echo "6. Exit"
        echo ""
        read -p "Enter choice: " choice

        case $choice in
            1) dashboard ;;
            2) less "$LOG_FILE" ;;
            3) less "$ALERT_LOG" ;;
            4) show_history ;;
            5)
                read -p "Enter new refresh rate (sec): " REFRESH
                ;;
            6)
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid choice!"
                sleep 1
                ;;
        esac
    done
}

# Start program
menu