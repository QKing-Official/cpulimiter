#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

# Install required packages
echo "Installing required packages..."
apt update
apt install -y cgroup-tools sysstat stress

# Prompt user for number of CPU cores
read -p "Enter the total number of CPU cores on your VPS: " total_cores

# Calculate CPU limit (10% less than total)
cpu_limit=$(( total_cores * 90 ))

# Set up cgroup for CPU limiting
echo "Configuring CPU limit to $(($cpu_limit))%..."
cgcreate -g cpu:/cpulimited
echo $((cpu_limit * 1000)) > /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_quota_us
echo 100000 > /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_period_us

# Create a systemd service to apply the CPU limit on boot
echo "Creating systemd service to enforce CPU limit on boot..."

cat <<EOF > /etc/systemd/system/cpu-limiter.service
[Unit]
Description=CPU Limiter to cap CPU usage to $(($cpu_limit))%

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo $((cpu_limit * 1000)) > /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_quota_us; echo 100000 > /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_period_us; for pid in \$(pgrep -x .); do cgclassify -g cpu:cpulimited \$pid; done'
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start the service
systemctl daemon-reload
systemctl enable cpu-limiter.service
systemctl start cpu-limiter.service

# Test the CPU limit
echo "Testing the CPU limit with stress and monitoring CPU usage..."
(stress --cpu "$total_cores" --timeout 60 &)
mpstat 1 60

echo "CPU limiter installation and test complete. CPU usage should be limited to $(($cpu_limit))%."
