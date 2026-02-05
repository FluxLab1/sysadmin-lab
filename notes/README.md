# Knowledge Base Structure

This directory contains organized notes by topic.

## 📁 Suggested Organization

### `/notes/security-plus/`
- domain-1-general-concepts.md
- domain-2-threats-vulnerabilities.md
- domain-3-architecture.md
- domain-4-operations.md
- domain-5-management.md
- practice-questions.md
- exam-tips.md

### `/notes/linux/`
- file-system.md
- permissions.md
- networking.md
- processes.md
- shell-scripting.md
- security-hardening.md

### `/notes/networking/`
- tcp-ip.md
- protocols.md
- wireshark-notes.md
- port-scanning.md

### `/notes/tools/`
- nmap-cheatsheet.md
- metasploit-basics.md
- burp-suite.md
- wireshark.md
- docker-security.md

### `/notes/concepts/`
- mitre-attack.md
- kill-chain.md
- incident-response.md
- threat-hunting.md

## 💡 Note-Taking Tips

1. **Use Headers**: Make notes scannable
2. **Code Blocks**: Always include practical examples
3. **Link Related Notes**: Cross-reference topics
4. **Update Regularly**: Review and refine notes
5. **Add Context**: Why something matters, not just what it is

## 🔗 Cross-Reference Format

When referencing other notes:
```markdown
See also: [Linux Permissions](../linux/permissions.md)
Related: [MITRE ATT&CK](../concepts/mitre-attack.md)
```

## 📌 Quick Access

Create symbolic links in your home directory:
```bash
ln -s ~/sysadmin-lab/notes ~/quick-notes
```

## Docker Security Lab – Intent

This Docker lab exists as a safe, isolated environment to practice
web application security testing and container awareness.

The lab uses intentionally vulnerable applications deployed via Docker
to allow hands-on learning without exposing the host system or external networks.

Primary goals:
- Understand how vulnerable services are commonly deployed
- Learn how Docker networking and isolation affect attack surface
- Practice safe start/stop/reset workflows for security labs
- Observe logging and container behavior during testing

All containers are used strictly for educational purposes and are not
exposed to the internet.

## Virtual Machine Lab – Intent

The virtual machine lab simulates a small enterprise-style network
to practice system administration, network security, and defensive concepts
in a controlled environment.

Current and planned systems include:
- pfSense (network segmentation and firewalling)
- Ubuntu Server (Linux administration and services)
- Windows 10 (endpoint behavior and security)
- Windows Server (Active Directory and domain services)
- Kali Linux (security testing platform)

Primary goals:
- Understand network boundaries and traffic control
- Practice user and permission management safely
- Learn how servers and endpoints interact in real environments
- Prepare for future labs involving Active Directory, logging, and monitoring

All systems are isolated, non-production, and used only for learning.
