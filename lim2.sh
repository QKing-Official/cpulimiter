#!/bin/bash

# Check if cpulimit is installed; install if missing
if ! command -v cpulimit &>/dev/null; then
    echo "cpulimit is not installed. Installing it now..."
    
    # Determine the package manager and install cpulimit
    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y cpulimit
    elif command -v yum &>/dev/null; then
        sudo yum install -y epel-release && sudo yum install -y cpulimit
    else
        echo "Error: Unable to install cpulimit. Unsupported package manager."
        exit 1
    fi
else
    echo "cpulimit is already installed."
fi

# Prompt the user for a CPU limit percentage
read -p "Enter the maximum CPU usage percentage (e.g., 50 for 50%): " cpu_limit

# Find the main process (usually systemd or init) and limit its CPU usage
main_pid=$(ps -eo pid,comm | grep -E 'init|systemd' | head -n 1 | awk '{print $1}')

if [ -z "$main_pid" ]; then
    echo "Error: Could not find the main system process (init/systemd)."
    exit 1
fi

# Apply CPU limit to the main process (and thus to all child processes)
echo "Limiting CPU usage of the main process (PID $main_pid) to $cpu_limit%..."
sudo cpulimit -p "$main_pid" -l "$cpu_limit" &

echo "CPU limit of $cpu_limit% applied to the entire VPS."
