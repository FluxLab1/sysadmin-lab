# GitHub Setup Guide for Your Cyber Lab

## Why GitHub?

1. **Backup**: Never lose your work
2. **Version Control**: Track your progress over time
3. **Portfolio**: Show employers your journey
4. **Collaboration**: Share with the community
5. **Learning Record**: See how far you've come

## Quick Setup

### 1. Initialize Repository
```bash
cd ~/sysadmin-lab
git init
```

### 2. Create .gitignore
```bash
cat > .gitignore << 'EOF'
# Sensitive files
secret.conf
*.key
*.pem
*password*
*token*

# System files
.DS_Store
*.log
*.swp

# ISOs and large binaries
*.iso
*.vmdk
*.ova

# Personal info
*private*
*credentials*
EOF
```

### 3. Initial Commit
```bash
git add .
git commit -m "Initial commit: Cyber lab documentation system"
```

### 4. Create GitHub Repository
- Go to github.com
- Click "New Repository"
- Name: `cybersec-learning-lab` or `security-journey`
- Make it **Private** initially (you can make it public later)

### 5. Push to GitHub
```bash
git remote add origin https://github.com/YOUR-USERNAME/REPO-NAME.git
git branch -M main
git push -u origin main
```

## Daily Workflow

### Start of Day
```bash
# Create new log
~/sysadmin-lab/scripts/newlog.sh
```

### End of Day
```bash
cd ~/sysadmin-lab
git add daily-logs/$(date +%Y-%m-%d)-log.md
git commit -m "Daily log: $(date +%Y-%m-%d)"
git push
```

### After Completing Lab/Script
```bash
git add scripts/your-new-script.sh
git commit -m "Add: [description of what you built]"
git push
```

## Repository Structure

```
cybersec-learning-lab/
├── README.md                    # Overview of your journey
├── daily-logs/                  # Daily learning logs
├── scripts/                     # Reusable scripts
├── notes/                       # Study notes
│   ├── security-plus/
│   ├── linux/
│   └── tools/
├── labs/                        # Lab scenarios & writeups
└── resources/                   # Cheatsheets, bookmarks
```

## Example README.md

```markdown
# My Cybersecurity Learning Journey

🎯 **Goal**: Transition into a SOC Analyst role

📚 **Current Focus**: 
- Security+ Certification
- Linux System Administration
- Network Security

🛠️ **Tech Stack**:
- Ubuntu 24.04
- Kali Linux
- Docker
- Python

📊 **Progress**:
- Days Learning: X
- Labs Completed: Y
- Certifications: Security+ (In Progress)

## Repository Contents

- `/daily-logs`: Daily learning documentation
- `/scripts`: Automation scripts I've built
- `/notes`: Study notes organized by topic
- `/labs`: Hands-on lab writeups

---
*Last Updated: 2026-02-02*
```

## Pro Tips

1. **Commit Often**: Small, frequent commits are better than large ones
2. **Write Good Messages**: "Add nmap script for subnet scanning" not "update"
3. **Use Branches**: For experimental work
4. **Review Your History**: `git log --oneline` to see your progress
5. **Make It Public**: Once you're comfortable, make it public for job hunting

## Privacy & Security

**NEVER commit:**
- Real passwords or API keys
- Personal/work IP addresses
- Real organization names from work
- Actual vulnerability findings from real systems

**Safe to commit:**
- Learning scripts
- Lab writeups (from practice platforms)
- Study notes
- Sanitized/anonymized configs
- Documentation

## Automation (Optional)

Add to your `.bashrc`:
```bash
# Auto-commit daily log at end of day
alias lab-commit='cd ~/sysadmin-lab && git add . && git commit -m "Daily update: $(date +%Y-%m-%d)" && git push'
```

Then just type `lab-commit` when you're done for the day!
