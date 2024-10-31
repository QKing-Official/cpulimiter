#!/bin/bash

# Function to read the number of CPU cores
read_cpu_cores() {
    while true; do
        echo -n "Please enter the total number of CPU cores on your VPS (e.g., 2, 4, 8): "
        read total_cores

        # Validate input: check if it's a positive integer
        if [[ "$total_cores" =~ ^[1-9][0-9]*$ ]]; then
            echo "$total_cores" > /tmp/cpu_cores.txt  # Save the input correctly
            echo "You have entered: $total_cores CPU cores."
            break
        else
            echo "Invalid input. Please enter a valid positive integer for CPU cores."
            echo ""  # Print an empty line for better readability
        fi
    done
}

# Call the function to read CPU cores
read_cpu_cores
