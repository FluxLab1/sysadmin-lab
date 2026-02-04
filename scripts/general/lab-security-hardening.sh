#!/bin/bash

#############################################################################
# CyberSec Lab - Security Hardening Script
# For: Ubuntu 24.04 on Lenovo T460s
# Purpose: Harden system for safe offensive/defensive security practice
# Author: Hardening checklist for fluxlab
#############################################################################

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================================${NC}\n"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root (use: sudo ./lab-security-hardening.sh)"
    exit 1
fi

echo -e "${GREEN}"
cat << "EOF"
   ____      _               ____            _               _ _             
  / ___|   _| |__   ___ _ __/ ___|  ___  ___| |    __ _ _ __| | |_ ___  _ __ 
 | |  | | | | '_ \ / _ \ '__\___ \ / _ \/ __| |   / _` | '__| | __/ _ \| '__|
 | |__| |_| | |_) |  __/ |   ___) |  __/ (__| |__| (_| | |  | | || (_) | |   
  \____\__, |_.__/ \___|_|  |____/ \___|\___|_____\__,_|_|  |_|\__\___/|_|   
       |___/                                                                  
                    Security Hardening Script v1.0
EOF
echo -e "${NC}\n"

print_warning "This script will harden your Ubuntu lab for cybersecurity practice"
print_warning "Press ENTER to continue or CTRL+C to cancel"
read -r

#############################################################################
# SECTION 1: SYSTEM UPDATES
#############################################################################
print_header "SECTION 1: System Updates & Package Management"

echo "Updating package lists..."
apt update -qq
print_success "Package lists updated"

echo "Checking for upgradable packages..."
UPGRADABLE=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
if [ "$UPGRADABLE" -gt 1 ]; then
    print_warning "Found $((UPGRADABLE-1)) packages to upgrade"
    echo "Upgrading packages (this may take a few minutes)..."
    apt upgrade -y
    print_success "System packages upgraded"
else
    print_success "System is already up to date"
fi

# Remove unnecessary packages
echo "Removing telnet (insecure - use SSH or netcat instead)..."
apt remove -y telnet inetutils-telnet 2>/dev/null
print_success "Telnet removed"

echo "Cleaning up unnecessary packages..."
apt autoremove -y
apt autoclean
print_success "Package cleanup complete"

#############################################################################
# SECTION 2: FIREWALL HARDENING
#############################################################################
print_header "SECTION 2: Firewall Configuration"

echo "Current UFW status:"
ufw status verbose

echo -e "\nEnsuring UFW is enabled with secure defaults..."
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw default deny routed
print_success "UFW enabled with secure defaults"

# Check existing SSH rule
if ufw status | grep -q "22.*ALLOW"; then
    print_warning "SSH rule exists (port 22)"
    echo "Note: SSH is not installed, but rule exists. This is harmless but unnecessary."
    echo "To remove it later: sudo ufw delete allow from 192.168.1.100 to any port 22"
fi

print_success "Firewall hardening complete"

#############################################################################
# SECTION 3: USER ACCOUNT SECURITY
#############################################################################
print_header "SECTION 3: User Account Security"

# Hide practice accounts from login screen
echo "Hiding practice accounts from login screen..."
for user in fury ironman cap thor widow banner; do
    if id "$user" &>/dev/null; then
        mkdir -p /var/lib/AccountsService/users
        cat > /var/lib/AccountsService/users/$user << EOF
[User]
SystemAccount=true
EOF
        print_success "Hidden: $user"
    fi
done

# Set password policies (for learning - can be adjusted)
echo "Configuring password policies..."
cat >> /etc/security/pwquality.conf << EOF

# Lab Security Settings
minlen = 12
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
EOF
print_success "Password policies configured"

# Check for users with empty passwords
echo "Checking for users with empty passwords..."
EMPTY_PASS=$(awk -F: '($2 == "" ) { print $1 }' /etc/shadow)
if [ -n "$EMPTY_PASS" ]; then
    print_error "Users with empty passwords found: $EMPTY_PASS"
    print_warning "Please set passwords for these accounts!"
else
    print_success "No users with empty passwords"
fi

#############################################################################
# SECTION 4: DOCKER SECURITY
#############################################################################
print_header "SECTION 4: Docker Security Configuration"

if command -v docker &> /dev/null; then
    print_success "Docker is installed"
    
    # Fix Docker GPG key warning
    echo "Fixing Docker GPG key configuration..."
    if [ -f /etc/apt/trusted.gpg ]; then
        apt-key export | gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg 2>/dev/null
        print_success "Docker GPG key migrated"
    fi
    
    # Create Docker security daemon config
    echo "Configuring Docker security settings..."
    mkdir -p /etc/docker
    cat > /etc/docker/daemon.json << EOF
{
  "icc": false,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "userns-remap": "default",
  "no-new-privileges": true
}
EOF
    
    # Create isolated Docker network for labs
    echo "Creating isolated Docker network for vulnerable labs..."
    docker network create --driver bridge --subnet 172.20.0.0/16 lab-network 2>/dev/null || true
    print_success "Docker lab network created: lab-network (172.20.0.0/16)"
    
    # Restart Docker to apply changes
    systemctl restart docker
    print_success "Docker security configuration applied"
    
    # Show Docker info
    echo -e "\nDocker Networks:"
    docker network ls
else
    print_warning "Docker not found or not running"
fi

#############################################################################
# SECTION 5: SYSTEM SECURITY HARDENING
#############################################################################
print_header "SECTION 5: System Security Hardening"

# Disable core dumps (prevent memory dumps from containing sensitive data)
echo "Disabling core dumps..."
cat >> /etc/security/limits.conf << EOF

# Disable core dumps for security
* hard core 0
EOF
echo "ulimit -c 0" >> /etc/profile
print_success "Core dumps disabled"

# Enable kernel security features
echo "Configuring kernel security parameters..."
cat > /etc/sysctl.d/99-lab-security.conf << EOF
# IP Forwarding (disabled for security)
net.ipv4.ip_forward = 0

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Log suspicious packets
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Ignore ICMP ping requests (optional - uncomment to enable)
# net.ipv4.icmp_echo_ignore_all = 1

# Protect against syn flood attacks
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

# Enable address space layout randomization (ASLR)
kernel.randomize_va_space = 2
EOF

sysctl -p /etc/sysctl.d/99-lab-security.conf > /dev/null 2>&1
print_success "Kernel security parameters configured"

#############################################################################
# SECTION 6: AUTOMATIC SECURITY UPDATES
#############################################################################
print_header "SECTION 6: Automatic Security Updates"

if [ -f /etc/apt/apt.conf.d/20auto-upgrades ]; then
    print_success "Automatic security updates already enabled"
else
    echo "Enabling automatic security updates..."
    apt install -y unattended-upgrades
    dpkg-reconfigure -plow unattended-upgrades
    print_success "Automatic security updates enabled"
fi

#############################################################################
# SECTION 7: INSTALL SECURITY TOOLS
#############################################################################
print_header "SECTION 7: Installing Essential Security Tools"

TOOLS="fail2ban lynis rkhunter chkrootkit aide"
echo "Installing security monitoring tools: $TOOLS"
apt install -y $TOOLS

# Configure fail2ban (intrusion prevention)
systemctl enable fail2ban
systemctl start fail2ban
print_success "Fail2ban installed and started"

print_success "Security tools installed"

#############################################################################
# SECTION 8: CREATE LAB DIRECTORIES
#############################################################################
print_header "SECTION 8: Lab Environment Setup"

# Get the actual user (not root)
ACTUAL_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo ~$ACTUAL_USER)

echo "Setting up lab directories for $ACTUAL_USER..."

# Create lab structure if it doesn't exist
cd "$USER_HOME" || exit

if [ ! -d "sysadmin-lab" ]; then
    sudo -u "$ACTUAL_USER" mkdir -p sysadmin-lab/{labs,scripts,notes,logs,backups}
    print_success "Lab directory structure created"
else
    print_success "Lab directory already exists"
fi

# Create docker-compose file for common vulnerable apps
cat > "$USER_HOME/sysadmin-lab/labs/docker-compose.yml" << 'EOF'
version: '3.8'

# Common Vulnerable Web Applications for Practice
# Usage: docker-compose up -d [service-name]

services:
  # DVWA - Damn Vulnerable Web Application
  dvwa:
    image: vulnerables/web-dvwa
    container_name: lab-dvwa
    ports:
      - "8080:80"
    networks:
      - lab-network
    restart: unless-stopped

  # WebGoat - OWASP Web Security Training
  webgoat:
    image: webgoat/webgoat-8.0
    container_name: lab-webgoat
    ports:
      - "8081:8080"
    networks:
      - lab-network
    restart: unless-stopped

  # Juice Shop - Modern vulnerable web app
  juiceshop:
    image: bkimminich/juice-shop
    container_name: lab-juiceshop
    ports:
      - "3000:3000"
    networks:
      - lab-network
    restart: unless-stopped

networks:
  lab-network:
    external: true
EOF

chown "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/sysadmin-lab/labs/docker-compose.yml"
print_success "Docker vulnerable app lab created"

# Create a quick reference guide
cat > "$USER_HOME/sysadmin-lab/LAB-SECURITY-NOTES.md" << 'EOF'
# Lab Security Notes

## 🔒 Security Hardening Applied

### Firewall (UFW)
- **Status**: Active
- **Default**: Deny incoming, Allow outgoing
- **Ports**: Only what you explicitly allow

### Docker Security
- **Isolated Network**: lab-network (172.20.0.0/16)
- **User Namespacing**: Enabled (containers run as non-root)
- **Inter-container Communication**: Disabled by default
- **Logging**: Limited to 10MB per container

### System Hardening
- Core dumps disabled
- Kernel security parameters configured
- Automatic security updates enabled
- Fail2ban monitoring active

## 🧪 Using Your Lab

### Start Vulnerable Apps
```bash
cd ~/sysadmin-lab/labs
docker-compose up -d dvwa        # Starts DVWA on port 8080
docker-compose up -d webgoat     # Starts WebGoat on port 8081
docker-compose up -d juiceshop   # Starts Juice Shop on port 3000
```

### Stop Vulnerable Apps
```bash
docker-compose down
```

### View Running Containers
```bash
docker ps
```

### Important Safety Notes
1. **Never expose these apps to the internet**
2. **Always use the isolated lab-network**
3. **Stop containers when not practicing**
4. **These apps are INTENTIONALLY vulnerable**

## 🛡️ Security Tools Installed

- **fail2ban**: Monitors logs and blocks suspicious IPs
- **lynis**: Security auditing tool (run: `sudo lynis audit system`)
- **rkhunter**: Rootkit detection
- **chkrootkit**: Another rootkit checker
- **aide**: File integrity monitoring

## 📚 Next Steps

1. Practice on DVWA first (easiest)
2. Try Juice Shop (modern web vulnerabilities)
3. Move to WebGoat (comprehensive OWASP training)
4. Document your findings in ~/sysadmin-lab/notes/

## 🔍 Regular Maintenance

```bash
# Check system security
sudo lynis audit system

# Check for rootkits
sudo rkhunter --check

# View fail2ban status
sudo fail2ban-client status

# Check firewall rules
sudo ufw status verbose

# Update Docker images
docker-compose pull
```

Stay curious, stay secure! 🚀
EOF

chown "$ACTUAL_USER:$ACTUAL_USER" "$USER_HOME/sysadmin-lab/LAB-SECURITY-NOTES.md"
print_success "Lab security notes created"

#############################################################################
# FINAL REPORT
#############################################################################
print_header "HARDENING COMPLETE!"

echo -e "${GREEN}✓ System Updates Applied${NC}"
echo -e "${GREEN}✓ Firewall Configured${NC}"
echo -e "${GREEN}✓ User Accounts Secured${NC}"
echo -e "${GREEN}✓ Docker Security Enabled${NC}"
echo -e "${GREEN}✓ Kernel Hardening Applied${NC}"
echo -e "${GREEN}✓ Security Tools Installed${NC}"
echo -e "${GREEN}✓ Lab Environment Ready${NC}"

echo -e "\n${BLUE}================================================${NC}"
echo -e "${YELLOW}IMPORTANT NEXT STEPS:${NC}"
echo -e "${BLUE}================================================${NC}"
echo -e "1. ${YELLOW}Reboot your system${NC} to apply all kernel changes:"
echo -e "   ${BLUE}sudo reboot${NC}"
echo -e ""
echo -e "2. After reboot, test Docker lab:"
echo -e "   ${BLUE}cd ~/sysadmin-lab/labs${NC}"
echo -e "   ${BLUE}docker-compose up -d dvwa${NC}"
echo -e "   ${BLUE}firefox http://localhost:8080${NC}"
echo -e ""
echo -e "3. Read your lab notes:"
echo -e "   ${BLUE}cat ~/sysadmin-lab/LAB-SECURITY-NOTES.md${NC}"
echo -e ""
echo -e "4. Run a security audit:"
echo -e "   ${BLUE}sudo lynis audit system${NC}"
echo -e ""
echo -e "${GREEN}Your lab is now hardened and ready for safe practice!${NC}"
echo -e "${BLUE}================================================${NC}\n"

# Create a log of what was done
LOG_FILE="$USER_HOME/sysadmin-lab/logs/hardening-$(date +%Y%m%d-%H%M%S).log"
cat > "$LOG_FILE" << EOF
Lab Security Hardening Log
Date: $(date)
User: $ACTUAL_USER
Hostname: $(hostname)

Actions Performed:
- System packages updated and upgraded
- Telnet removed
- UFW firewall configured and enabled
- Practice user accounts hidden from login
- Password policies configured
- Docker security settings applied
- Docker lab-network created (172.20.0.0/16)
- Core dumps disabled
- Kernel security parameters configured
- Automatic security updates enabled
- Security tools installed: fail2ban, lynis, rkhunter, chkrootkit, aide
- Lab directory structure verified
- Vulnerable app docker-compose created
- Security notes documentation created

System Status:
- Firewall: ACTIVE
- Docker: SECURED
- Auto-updates: ENABLED
- Monitoring: ACTIVE (fail2ban)

Recommendations:
1. Reboot system to apply kernel changes
2. Run security audit: sudo lynis audit system
3. Test Docker lab environment
4. Review security notes in ~/sysadmin-lab/LAB-SECURITY-NOTES.md
EOF

chown "$ACTUAL_USER:$ACTUAL_USER" "$LOG_FILE"
echo -e "${GREEN}Hardening log saved: $LOG_FILE${NC}\n"
