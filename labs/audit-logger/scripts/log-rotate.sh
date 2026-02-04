#!/bin/bash

# Log Rotation Script
# Author: FluxLab
# Keeps last 7 days of reports, archives older ones, deletes archives > 30 days

REPORT_DIR="$HOME/sysadmin-lab/labs/audit-logger/reports"
ARCHIVE_DIR="$REPORT_DIR/archive"

# Create archive folder if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

echo "[$(date)] Starting log rotation..."

# Move reports older than 7 days into archive
MOVED=0
find "$REPORT_DIR" -maxdepth 1 -name "audit-report-*.txt" -mtime +7 | while read file; do
    mv "$file" "$ARCHIVE_DIR/"
    echo "  Archived: $(basename $file)"
    MOVED=$((MOVED + 1))
done

# Delete archives older than 30 days
DELETED=0
find "$ARCHIVE_DIR" -name "audit-report-*.txt" -mtime +30 -delete -print | while read file; do
    echo "  Deleted: $(basename $file)"
    DELETED=$((DELETED + 1))
done

echo "[$(date)] Rotation complete."
echo "  Reports in active: $(find $REPORT_DIR -maxdepth 1 -name 'audit-report-*.txt' | wc -l)"
echo "  Reports in archive: $(find $ARCHIVE_DIR -name 'audit-report-*.txt' | wc -l)"
