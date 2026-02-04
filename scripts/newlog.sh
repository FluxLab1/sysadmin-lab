#!/bin/bash

# Daily Lab Log Generator
# Purpose: Automatically create today's log file from template

# Configuration
LOG_DIR="$HOME/sysadmin-lab/daily-logs"
TEMPLATE="$HOME/sysadmin-lab/daily-logs/TEMPLATE.md"
DATE=$(date +%Y-%m-%d)
DAY_NAME=$(date +%A)
LOG_FILE="$LOG_DIR/$DATE-log.md"

# Create directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Check if today's log already exists
if [ -f "$LOG_FILE" ]; then
    echo "📝 Today's log already exists: $LOG_FILE"
    echo "Opening in default editor..."
    ${EDITOR:-nano} "$LOG_FILE"
    exit 0
fi

# Create today's log from template
if [ -f "$TEMPLATE" ]; then
    cp "$TEMPLATE" "$LOG_FILE"
    # Replace [DATE] placeholder
    sed -i "s/\[DATE\]/$DATE ($DAY_NAME)/g" "$LOG_FILE"
    echo "✅ Created new log: $LOG_FILE"
    echo "Opening in editor..."
    ${EDITOR:-nano} "$LOG_FILE"
else
    echo "❌ Template not found at: $TEMPLATE"
    echo "Creating basic log file..."
    cat > "$LOG_FILE" << EOF
# Daily Lab Log - $DATE ($DAY_NAME)

## Today's Focus

## What I Learned

## Commands Used
\`\`\`bash

\`\`\`

## Lab Work

## Problems Encountered

## Security+ Study

## TIL (Today I Learned)

## Tomorrow's Plan

---
**Time Spent:** 
**Mood:** 
EOF
    echo "✅ Basic log created: $LOG_FILE"
    ${EDITOR:-nano} "$LOG_FILE"
fi
