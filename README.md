# Azure SIEM-SOC & Intrusion Detection Lab

A comprehensive hands-on learning project for understanding Azure security monitoring, threat detection, and incident response using Microsoft Sentinel.

## 🚀Architecture Overview

```
┌─────────────────┐                              ┌─────────────────┐
│   Linux VM      │                              │   Windows VM    │
│  (Ubuntu)       │                              │  (server 2019)  │
└────────┬────────┘                              └────────┬────────┘
         │                                                │
         └────────────┬───────────┴─────────────┬─────────┘
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

## 🎯 Data Flow

1. **VMs Generate Logs** → Security events, authentication attempts, system activities
2. **Log Analytics Collects** → Agents on VMs send logs to LAW workspace
3. **Sentinel Analyzes** → Applies analytics rules to detect threats
4. **Alerts Generated** → Suspicious activities trigger alerts
5. **Incidents Created** → Related alerts grouped into incidents
6. **Dashboard Visualizes** → Workbooks show security posture

## 📍Key Components

| Component | Role | Function |
|-----------|------|----------|
| **Log Analytics Workspace** | Log Storage | Centralized repository for all logs |
| **Microsoft Sentinel** | SIEM Engine | Threat detection & correlation |
| **Linux VM (Ubuntu)** | Data Collector | Generates Syslog events |
| **Windows VM (Server 2019)** | Data Collector | Generates Security events |
| **Analytics Rules** | Threat Detection | Custom queries detect attacks |
| **Incidents** | Grouped Alerts | Related security events |
| **Workbooks** | Visualization | Dashboard & reporting |


## 📍Quick Start Guide

### Phase 1: Deploy Infrastructure
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

### Phase 2: Enable Sentinel & Configure
Follow `portal/sentinelconfig.md`:
- Enable Microsoft Sentinel
- Connect data sources (Security Events, Syslog)
- Create analytics rules for threat detection
- Set up alerts & automation

### Phase 3: Generate & Detect Threats
Test attack detection by:
- Attempting failed logins (brute force)
- Running suspicious processes
- Making lateral movement attempts
- Checking generated incidents in Sentinel

### Phase 4: Investigate & Analyze
- Review generated incidents
- Run KQL queries (see `cloudshell/queries.txt`)
- Create custom workbooks
- Understand attack patterns

- ## 🚀Troubleshooting

**VMs not sending logs:**
- Verify agents are installed: `az vm extension list`
- Check agent health in Log Analytics
- Ensure NSG allows outbound 443 to Azure services

**No data in Sentinel:**
- Wait 10+ minutes after agent installation
- Check Log Analytics ingestion status
- Verify agent configuration with correct workspace ID

**False positives in alerts:**
- Adjust threshold values gradually
- Add filters for known good IPs
- Use custom analytics rules instead of default ones
