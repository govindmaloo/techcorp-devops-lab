# DevOps Lab: Monitoring, Users & Web Server Backups

This repository contains scripts and documentation for **TechCorp** development environment tasks (monitoring, user management, automated backups). Run the shell scripts on a **Linux lab VM** (RHEL/CentOS/Rocky/AlmaLinux or Ubuntu) with root or sudo where indicated.

## Contents

| Path | Purpose |
|------|---------|
| `scripts/collect_system_metrics.sh` | Task 1: periodic metrics (CPU/memory/processes, `df`, `du`) |
| `scripts/install_monitoring_tools.sh` | Task 1: install `htop` and/or `nmon` (optional helper) |
| `scripts/backup_apache_sarah.sh` | Task 3: Apache paths → `/backups/apache_backup_YYYY-MM-DD.tar.gz` |
| `scripts/backup_nginx_mike.sh` | Task 3: Nginx paths → `/backups/nginx_backup_YYYY-MM-DD.tar.gz` |
| `cron/crontab.example` | Example crontab lines (Tuesday 00:00) |
| `docs/` | Step-by-step documentation per task |
| `REPORT.md` | Implementation summary for submission |

## Quick start (lab server)

```bash
sudo mkdir -p /backups /var/log/sysmetrics
chmod +x scripts/*.sh
```

Install tools and register cron as described in `docs/`.

## Submission

Push this repository to GitHub and submit the repository URL via Vlearn as required by your course.
