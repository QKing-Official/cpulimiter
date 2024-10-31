#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

# Prompt user for the number of CPU cores
while true; do
    read -p "Please enter the total number of CPU cores on your VPS (e.g., 2, 4, 8): " total_cores

    # Validate input: check if it's a positive integer
    if [[ "$total_cores" =~ ^[1-9][0-9]*$ ]]; then
        echo "$total_cores" > /tmp/cpu_cores.txt
        break
    else
        echo "Invalid input. Please enter a valid positive integer for CPU cores."
    fi
done

echo "Total CPU cores saved to /tmp/cpu_cores.txt."
