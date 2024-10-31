#!/bin/bash

# Call the input script to get the number of CPU cores
bash /tmp/input.sh

# Call the install script to perform installation and configuration
bash /tmp/install.sh

# Clean up temporary files
rm -f /tmp/cpu_cores.txt
