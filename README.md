This script is created by me (qking)
Pls give credits if you modify

This script limits cpu so for example your vps doesnt get killed while accedentaly using more cpu

# Check the status of the service
sudo systemctl status cpu-limiter.service

# View the logs for the service
sudo journalctl -u cpu-limiter.service -f

# Verify CPU limit settings
cat /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_quota_us
cat /sys/fs/cgroup/cpu/cpulimited/cpu.cfs_period_us

# Run a CPU-intensive command to test the limiter
yes > /dev/null &
top  # or htop if installed
