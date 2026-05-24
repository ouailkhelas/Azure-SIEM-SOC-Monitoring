# Azure SOC & Intrusion Detection Lab

A comprehensive hands-on learning project for understanding Azure security monitoring, threat detection, and incident response using Microsoft Sentinel.

## Architecture Overview

```
┌─────────────────┐      ┌──────────────────┐      ┌─────────────────┐
│   Linux VM      │      │   Windows VM     │      │   Other Sources │
│  (Ubuntu)       │      │   (Server 2019)  │      │                 │
└────────┬────────┘      └────────┬─────────┘      └────────┬────────┘
         │                        │                         │
         └────────────┬───────────┴─────────────┬──────────┘
                      │ Log Analytics Agent
                      ▼
         ┌────────────────────────┐
         │ Log Analytics Workspace│ (Log Storage & Analysis)
         │     (LAW)              │
         └────────────┬───────────┘
                      │
                      ▼
         ┌────────────────────────┐
         │  Microsoft Sentinel    │ (SIEM/SOC Engine)
         │  (Threat Detection)    │
         └────────────┬───────────┘
                      │
         ┌────────────┴──────────────┐
         │                           │
         ▼                           ▼
    ┌─────────────┐         ┌──────────────┐
    │   Alerts    │         │  Incidents   │
    │             │         │              │
    └─────────────┘         └──────────────┘
         │                           │
         └───────────┬───────────────┘
                     ▼
         ┌────────────────────────┐
         │  SOC Dashboard         │
         │  (Workbooks)           │
         └────────────────────────┘
```

## Data Flow

1. **VMs Generate Logs** → Security events, authentication attempts, system activities
2. **Log Analytics Collects** → Agents on VMs send logs to LAW workspace
3. **Sentinel Analyzes** → Applies analytics rules to detect threats
4. **Alerts Generated** → Suspicious activities trigger alerts
5. **Incidents Created** → Related alerts grouped into incidents
6. **Dashboard Visualizes** → Workbooks show security posture

## Key Components

| Component | Role | Function |
|-----------|------|----------|
| **Log Analytics Workspace** | Log Storage | Centralized repository for all logs |
| **Microsoft Sentinel** | SIEM Engine | Threat detection & correlation |
| **Linux VM (Ubuntu)** | Data Collector | Generates Syslog events |
| **Windows VM (Server 2019)** | Data Collector | Generates Security events |
| **Analytics Rules** | Threat Detection | Custom queries detect attacks |
| **Incidents** | Grouped Alerts | Related security events |
| **Workbooks** | Visualization | Dashboard & reporting |

## Project Structure

```
soc-lab/
├── terraform/              # Infrastructure as Code
│   ├── provider.tf        # Azure provider config
│   ├── main.tf            # Resource definitions
│   ├── variables.tf       # Input variables
│   ├── outputs.tf         # Output values
│   └── terraform.tfvars   # Configuration values
├── cloudshell/            # Deployment & Analysis
│   ├── deploy.sh          # Automated deployment script
│   └── queries.txt        # 15 KQL queries for analysis
├── portal/                # Manual Setup Guide
│   └── sentinelconfig.md  # Step-by-step configuration
└── README.md             # This file
```

## Quick Start Guide

### Phase 1: Deploy Infrastructure (5 min)
```bash
cd cloudshell/
bash deploy.sh
```

This creates:
- Resource Group
- Virtual Network + Subnet
- Linux VM (Ubuntu 20.04) + public IP
- Windows VM (Server 2019) + public IP
- Log Analytics Workspace
- Network Security Group (SSH/RDP enabled)
- Log Analytics agents on both VMs

### Phase 2: Enable Sentinel & Configure (10 min)
Follow `portal/sentinelconfig.md`:
- Enable Microsoft Sentinel
- Connect data sources (Security Events, Syslog)
- Create analytics rules for threat detection
- Set up alerts & automation

### Phase 3: Generate & Detect Threats (5 min)
Test attack detection by:
- Attempting failed logins (brute force)
- Running suspicious processes
- Making lateral movement attempts
- Checking generated incidents in Sentinel

### Phase 4: Investigate & Analyze (10 min)
- Review generated incidents
- Run KQL queries (see `cloudshell/queries.txt`)
- Create custom workbooks
- Understand attack patterns

## What You'll Learn

✅ **Azure Infrastructure**
- Virtual Networks & Network Security
- VMs with managed identities
- Log Analytics Workspace configuration

✅ **Security Monitoring**
- Log collection and aggregation
- Event normalization
- Real-time threat detection

✅ **Sentinel Operations**
- Analytics rule creation
- Incident investigation
- Threat hunting with KQL

✅ **KQL (Kusto Query Language)**
- Query security events
- Detect attack patterns
- Create custom detections

✅ **Incident Response**
- Alert triage
- Evidence collection
- Attack timeline reconstruction

## Common Use Cases

### 1. Brute Force Attack Detection
Detect multiple failed login attempts:
```
SecurityEvent
| where EventID == 4625
| summarize FailedLoginCount = count() by Computer, Account
| where FailedLoginCount > 10
```

### 2. Lateral Movement Detection
Identify accounts moving between systems:
```
SecurityEvent
| where EventID == 4624 and LogonType == 3
| summarize Systems = dcount(Computer) by Account
| where Systems > 5
```

### 3. Privilege Escalation Detection
Monitor admin account usage:
```
SecurityEvent
| where EventID == 4648 or EventID == 4673
```

### 4. Suspicious Process Execution
Find uncommon process creation:
```
SecurityEvent
| where EventID == 4688
| where ProcessName contains "powershell" or ProcessName contains "cmd"
```

### 5. Failed SSH Attempts (Linux)
Monitor Linux authentication:
```
Syslog
| where ProcessName == "sshd"
| where SyslogMessage contains "Failed"
```

## Testing & Lab Scenarios

### Scenario 1: Brute Force Attack
```bash
# On Windows VM - Simulate failed RDP attempts
for ($i=0; $i -lt 20; $i++) {
  runas /user:DOMAIN\baduser "cmd.exe"
}

# Check Sentinel for alerts within 1 hour
```

### Scenario 2: Linux SSH Brute Force
```bash
# On Linux VM - Simulate SSH failures
for i in {1..15}; do
  ssh -o ConnectTimeout=2 invalid_user@localhost 2>/dev/null
done

# Check logs: grep sshd /var/log/auth.log | grep Failed
```

### Scenario 3: Privilege Escalation
```bash
# Windows - Run commands as admin
runas /user:Administrator "whoami"

# Linux - Run sudo commands
sudo su -
```

## Important Notes

🔒 **Security Best Practices:**
- Change default admin passwords in production
- Use Azure Key Vault for credentials
- Implement MFA for all accounts
- Regularly review security alerts
- Keep VMs patched and updated
- Use Private Endpoints instead of public IPs in production

⚠️ **Lab Limitations:**
- This is a learning project, not for production
- Uses basic SKU for cost efficiency
- Stores credentials in plain text (for lab only)
- Single region deployment

✅ **Customization:**
- Adjust analytics rule thresholds for your environment
- Add more VMs for testing
- Create custom workbooks
- Integrate with ticketing systems
- Add email/Teams notifications

## Cleanup

To avoid Azure charges, delete resources:
```bash
cd terraform/
terraform destroy
```

## Architecture Components Explained

### Log Analytics Workspace (LAW)
- **What:** Centralized log storage repository
- **Why:** Collects logs from all sources in one place
- **How:** Agents on VMs send data via HTTPS

### Microsoft Sentinel
- **What:** Cloud-native SIEM (Security Information & Event Management)
- **Why:** Provides threat detection and incident response
- **How:** Analyzes logs using analytics rules and machine learning

### Virtual Machine Agents
- **What:** Microsoft Monitoring Agent (MMA) on each VM
- **Why:** Collects and forwards security events to LAW
- **How:** Installed automatically by Terraform

### Analytics Rules
- **What:** Custom KQL queries that detect threats
- **Why:** Identifies suspicious activities automatically
- **How:** Runs on a schedule (hourly, 30 min, etc.)

### Incidents
- **What:** Grouped alerts related to same attack
- **Why:** Reduces alert fatigue, correlates events
- **How:** Severity, MITRE ATT&CK mapping

### Workbooks
- **What:** Interactive dashboards and reports
- **Why:** Visualize security events and metrics
- **How:** KQL queries rendered as charts/tables

## Resources & References

- [Microsoft Sentinel Documentation](https://docs.microsoft.com/en-us/azure/sentinel/)
- [KQL Documentation](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/)

## License

MIT - Free to use for learning purposes

---

**Ready to become a SOC analyst?** Start with Phase 1 deployment and follow the configuration guide! 🚀
