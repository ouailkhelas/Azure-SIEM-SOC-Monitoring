# Microsoft Sentinel Configuration Guide

## Step 1: Enable Microsoft Sentinel

1. Go to Azure Portal
2. Search for "Microsoft Sentinel"
3. Click "Create"
4. Select the Log Analytics Workspace created by Terraform
5. Click "Add" to enable Sentinel

---

## Step 2: Connect Data Sources

### Enable Windows Security Events
1. Go to Sentinel → Data Connectors
2. Search for "Security Events via Legacy Agent"
3. Click "Open connector page"
4. Select "Install agent on non-Azure machines" or use existing agents
5. Select data to collect:
   - All Security Events (recommended for lab)
6. Click "Apply Changes"

### Enable Syslog (Linux Logs)
1. Go to Sentinel → Data Connectors
2. Search for "Syslog"
3. Click "Open connector page"
4. Click "Connect through Log Analytics agent"
5. Configure syslog facilities:
   - Auth (authentication logs)
   - Authpriv (private auth logs)
   - Local0 through Local7
6. Click "Apply Changes"

---

## Step 3: Create Analytics Rules (Detection)

### Rule 1: Brute Force Detection
1. Go to Sentinel → Analytics → Create → Scheduled query rule
2. **Name:** Brute Force Attack Detection
3. **Query:**
```
SecurityEvent
| where EventID == 4625
| where TimeGenerated > ago(24h)
| summarize FailedLoginCount = count() by Computer, Account
| where FailedLoginCount > 10
```
4. **Run query every:** 1 hour
5. **Alert threshold:** > 0
6. **Group alerts:** By Account, Computer
7. Create automation rule → Send email notification

### Rule 2: Privilege Escalation
1. **Name:** Privilege Escalation Attempt
2. **Query:**
```
SecurityEvent
| where EventID in (4673, 4674)
| where TimeGenerated > ago(1h)
| summarize count() by Computer, Account
```
3. **Severity:** High
4. **Run every:** 15 minutes

### Rule 3: RDP Attack Pattern
1. **Name:** Multiple Failed RDP Attempts
2. **Query:**
```
SecurityEvent
| where EventID == 4625
| where LogonType == 10
| where TimeGenerated > ago(1h)
| summarize FailureCount = count() by Computer, SourceIp
| where FailureCount > 5
```
3. **Severity:** Medium
4. **Run every:** 30 minutes

### Rule 4: Linux Failed SSH Attempts
1. **Name:** SSH Brute Force (Linux)
2. **Query:**
```
Syslog
| where ProcessName == "sshd"
| where SyslogMessage contains "Failed"
| where TimeGenerated > ago(1h)
| summarize FailureCount = count() by Computer
| where FailureCount > 10
```
3. **Severity:** High

---

## Step 4: Trigger Sample Alerts

### Generate Failed Logins (Test)
1. **On Windows VM:**
   ```
   # Try multiple failed RDP or SMB login attempts
   net use \\targetpc\share /user:baduser wrongpassword
   # Repeat 10+ times
   ```

2. **On Linux VM:**
   ```bash
   # Try failed SSH logins
   for i in {1..15}; do
     ssh -o ConnectTimeout=2 baduser@localhost 2>/dev/null
   done
   ```

3. Check Sentinel → Incidents to see generated alerts

---

## Step 5: Investigate Incidents

1. Go to Sentinel → Incidents
2. Click on an incident to view details:
   - Timeline of events
   - Related alerts
   - Entities (users, computers, IPs)
   - Recommendations
3. Update status:
   - New → In Progress → Closed (Benign/True Positive)

---

## Step 6: Create Workbook Dashboard

### Built-in Workbook
1. Go to Sentinel → Workbooks
2. Click "+ New" 
3. Search for "Security Overview" workbook
4. Click "Create" to add to your workspace

### Custom Workbook
1. Go to Sentinel → Workbooks → "+ New"
2. Click "Edit"
3. Add query blocks:
   ```
   SecurityEvent
   | where TimeGenerated > ago(7d)
   | summarize EventCount = count() by bin(TimeGenerated, 1d), EventID
   | render timechart
   ```
4. Add visualizations:
   - Timechart (failed logins over time)
   - Barchart (top attacked computers)
   - Stat (total security events)
5. Save as "SOC Dashboard"

---

## Step 7: Monitor Log Ingestion

### Check Data is Coming In
1. Go to Log Analytics Workspace
2. Click "Logs"
3. Run query:
```
SecurityEvent
| summarize count() by Computer
```
4. Should see your VMs with event counts

### Verify Agent Health
1. Go to Log Analytics Workspace → Agents
2. Check both VMs show as "Connected"

---

## Important KQL Queries for Sentinel

### Hunt for Suspicious Activities
```
SecurityEvent
| where TimeGenerated > ago(7d)
| where EventID in (4688, 4689)
| where CommandLine contains "powershell" or CommandLine contains "cmd"
| project TimeGenerated, Computer, Account, CommandLine
```

### Data Exfiltration Patterns
```
SecurityEvent
| where EventID == 5156
| where Direction == "Out"
| where DestinationPort in (443, 80, 8080)
| summarize DataTransfer = sum(BytesSent) by Computer, DestinationIp
| where DataTransfer > 1000000
```

### Lateral Movement Detection
```
SecurityEvent
| where EventID in (4624, 4648)
| where LogonType in (3, 9)
| summarize
    LoginAttempts = count(),
    SourceComputers = dcount(SourceComputerId),
    TargetComputers = dcount(Computer)
    by Account
| where SourceComputers > 3 and LoginAttempts > 10
```

