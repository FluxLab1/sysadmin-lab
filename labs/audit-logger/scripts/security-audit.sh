#!/bin/bash

# Security Audit Logger
# Author: FluxLab
# Date: 2026-02-02

LOG_DIR="$HOME/sysadmin-lab/labs/audit-logger/logs"
REPORT_DIR="$HOME/sysadmin-lab/labs/audit-logger/reports"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
REPORT_FILE="$REPORT_DIR/audit-report-$TIMESTAMP.txt"

echo "==================================" | tee "$REPORT_FILE"
echo "  Security Audit Report" | tee -a "$REPORT_FILE"
echo "  Generated: $(date)" | tee -a "$REPORT_FILE"
echo "==================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# CHECK 1: Failed SSH logins
echo "[1] Failed SSH Login Attempts:" | tee -a "$REPORT_FILE"
FAIL_COUNT=$(grep -c "Failed password" "$LOG_DIR/auth_events.log")
echo "    Total attempts: $FAIL_COUNT" | tee -a "$REPORT_FILE"
echo "    Unique IPs:" | tee -a "$REPORT_FILE"
grep "Failed password" "$LOG_DIR/auth_events.log" | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | while read line; do
    echo "      $line" | tee -a "$REPORT_FILE"
done
echo "" | tee -a "$REPORT_FILE"

# CHECK 2: World-writable files
echo "[2] World-Writable Files:" | tee -a "$REPORT_FILE"
WW_FILES=$(find /home -type f -perm -o+w 2>/dev/null)
if [ -z "$WW_FILES" ]; then
    echo "    None found - clean!" | tee -a "$REPORT_FILE"
else
    echo "$WW_FILES" | while read line; do
        echo "      $line" | tee -a "$REPORT_FILE"
    done
fi
echo "" | tee -a "$REPORT_FILE"

# CHECK 3: New users (last 24h)
echo "[3] Recent User Changes:" | tee -a "$REPORT_FILE"
find /etc -name "passwd" -newer /etc/hostname 2>/dev/null && echo "    passwd modified recently - investigate!" | tee -a "$REPORT_FILE" || echo "    No recent user changes" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# ALERT: Flag if >5 failed attempts
if [ "$FAIL_COUNT" -gt 5 ]; then
    echo "⚠️  ALERT: $FAIL_COUNT failed login attempts detected!" | tee -a "$REPORT_FILE"
fi

echo "==================================" | tee -a "$REPORT_FILE"
echo "  Report saved: $REPORT_FILE" | tee -a "$REPORT_FILE"
echo "==================================" | tee -a "$REPORT_FILE"
