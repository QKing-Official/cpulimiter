#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

# Install required packages
echo "Installing required packages..."
apt update && apt install -y cgroup-tools sysstat

# Read the number of CPU cores from the temporary file
if [ -f /tmp/cpu_cores.txt ]; then
    read total_cores < /tmp/cpu_cores.txt
else
    echo "CPU cores information not found. Exiting."
    exit 1
fi

# Calculate CPU limit (90% of total CPU capacity)
cpu_limit_percentage=90
cpu_limit=$(( total_cores * cpu_limit_percentage ))

# Set up cgroup for CPU limiting
echo "Configuring CPU limit to $cpu_limit_percentage%..."
sudo cgcreate -g cpu:/cpulimited
echo $((cpu_limit * 1000)) | sudo tee /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_quota_us > /dev/null
echo 100000 | sudo tee /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_period_us > /dev/null

# Create a systemd service to keep the CPU limit enforced
echo "Creating systemd service to keep CPU limit active..."

sudo bash -c 'cat <<EOF > /etc/systemd/system/cpu-limiter.service
[Unit]
Description=CPU Limiter to cap CPU usage to '"$cpu_limit_percentage"'%

[Service]
Type=simple
ExecStart=/bin/bash -c "while true; do echo '"$((cpu_limit * 1000))"' > /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_quota_us; echo 100000 > /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_period_us; sleep 60; done"
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd, enable, and start the service
systemctl daemon-reload
systemctl enable cpu-limiter.service
systemctl start cpu-limiter.service

echo "CPU limiter installation complete. CPU usage is now limited to $cpu_limit_percentage% of total CPU capacity and will stay active."
