# Task 1: System Monitoring Setup

## Objectives

- Monitor CPU, memory, and processes with **htop** or **nmon**.
- Track disk usage with **df** and **du**.
- Identify resource-intensive processes (snapshot via **ps** sorted by CPU and memory).
- Persist metrics to log files for review.

## Implementation steps

### 1. Install monitoring tools

As root:

```bash
sudo bash scripts/install_monitoring_tools.sh
```

Or manually (RHEL/CentOS/Rocky):

```bash
sudo dnf install -y htop nmon
```

Ubuntu/Debian:

```bash
sudo apt-get update && sudo apt-get install -y htop nmon
```

**Interactive use**

- `htop` — F-keys for sort/filter; quit with `q`.
- `nmon` — press `c` (CPU), `m` (memory), `t` (top processes), `q` to quit.

### 2. Disk usage (manual checks)

```bash
df -hP
sudo du -sh /var/* | sort -hr | head
sudo du -sh /home/* | sort -hr | head
```

### 3. Automated metric logging

Create log directory and schedule collection:

```bash
sudo mkdir -p /var/log/sysmetrics
sudo chmod 755 scripts/collect_system_metrics.sh
sudo bash scripts/collect_system_metrics.sh
tail -n 80 /var/log/sysmetrics/metrics_$(date +%Y-%m-%d).log
```

Optional hourly cron (root `crontab -e`):

```cron
0 * * * * SYSMETRICS_LOG_DIR=/var/log/sysmetrics /usr/bin/bash /path/to/tls/scripts/collect_system_metrics.sh
```

## Evidence for your report

Capture terminal output showing:

- `htop` or `nmon` running (screenshot).
- `df -h` and a sample `du` summary.
- Last lines of `/var/log/sysmetrics/metrics_YYYY-MM-DD.log` after the script runs.

## Challenges (examples to document)

- **nmon** may be missing from minimal repos; **htop** alone still satisfies “htop or nmon.”
- **ps --sort** behaves differently on very old systems; the script falls back where needed.
