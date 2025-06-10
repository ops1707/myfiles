#!/bin/bash

OUT="system_audit_$(hostname)_$(date +%Y%m%d_%H%M%S).log"
exec > "$OUT" 2>&1

echo "================ SYSTEM AUDIT REPORT ================"
echo "Generated on: $(date)"
echo "Hostname: $(hostname)"
echo "====================================================="

echo -e "\n[+] OS and Kernel Info:"
hostnamectl

echo -e "\n[+] Uptime and Load:"
uptime
w

echo -e "\n[+] Memory Usage:"
free -h

echo -e "\n[+] CPU Info and Load:"
lscpu
mpstat -P ALL 1 1

echo -e "\n[+] Top Resource Consumers:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 15

echo -e "\n[+] Disk Usage:"
df -h

echo -e "\n[+] Top Disk Usage in /var/log:"
du -sh /var/log/* 2>/dev/null | sort -hr | head -n 10

echo -e "\n[+] Disk IO stats (iostat):"
iostat -xz 1 1

echo -e "\n[+] Mounted Filesystems:"
mount | column -t

echo -e "\n[+] Active Network Connections:"
ss -tunap

echo -e "\n[+] Listening Ports:"
ss -tuln

echo -e "\n[+] Failed Services:"
systemctl --failed

echo -e "\n[+] Enabled & Running Services:"
systemctl list-units --type=service --state=running

echo -e "\n[+] System Logs: Last 20 errors (journalctl):"
journalctl -p err..alert -n 20

echo -e "\n[+] Kernel Messages (last 20 errors):"
journalctl -k -p err -n 20

echo -e "\n[+] OOM Killer Events:"
journalctl -k | grep -i -E 'killed process|out of memory'

echo -e "\n[+] Users Logged In:"
who

echo -e "\n[+] Last Logins:"
last -a | head -n 10

echo -e "\n[+] Security: SELinux / AppArmor Status"
command -v sestatus &> /dev/null && sestatus
command -v aa-status &> /dev/null && aa-status

echo -e "\n[+] Package Updates:"
if command -v apt &>/dev/null; then
    apt list --upgradable
elif command -v yum &>/dev/null; then
    yum check-update
fi

echo -e "\n================ AUDIT COMPLETE ====================="
echo "Output saved to: $OUT"
