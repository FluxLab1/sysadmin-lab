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
