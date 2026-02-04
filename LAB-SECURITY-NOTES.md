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
