#!/bin/bash

source ./config.conf

check_environment() {
    if ! command -v nmap &> /dev/null; then
        echo "nmap is not installed. Installing..."
        sudo apt update && sudo apt install -y nmap
        if ! command -v nmap &> /dev/null; then
            echo "Failed to install nmap. Please install it manually."
            exit 1
        fi
    fi

    if [ ! -d "$LOG_DIR" ]; then
        sudo mkdir -p "$LOG_DIR"
        sudo touch "$LOG_FILE"
        sudo chown "$USER":"$USER" "$LOG_FILE"
    fi
}

run_scan_and_log() {
    
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    OPEN_PORTS=$(nmap -p- --open "$TARGET" | grep ^[0-9] | awk '{print $1}' | cut -d'/' -f1 | paste -sd, -)

    {
      echo "[$TIMESTAMP] Port scan on $TARGET"
      echo "Open ports found: $OPEN_PORTS"
      echo "-----------------------------"
    } >> "$LOG_FILE"
}


check_environment
run_scan_and_log
