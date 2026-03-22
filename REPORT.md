# Overall Report: DevOps Development Environment (TechCorp)

**Role context:** Assisting Senior DevOps engineer Rahul with monitoring, user onboarding (Sarah, Mike), and automated web server backups.

---

## 1. Task 1 — System monitoring

### Implementation summary

- Installed **htop** and/or **nmon** for live CPU, memory, and process visibility.
- Used **`df -h`** for filesystem capacity and **`du`** (via the metrics script) for directory growth hotspots.
- Deployed **`scripts/collect_system_metrics.sh`** to append scheduled snapshots (load, memory summary, top CPU/memory processes, `df`, `du` samples) under `/var/log/sysmetrics/`.

### Steps performed (high level)

1. Run `scripts/install_monitoring_tools.sh` (or distro package manager).
2. Validate interactive monitoring with `htop` / `nmon`.
3. Create `/var/log/sysmetrics`, execute the collector, optionally add hourly cron.

### Challenges encountered

- *(Fill in: e.g. minimal image without `nmon` in repos; used `htop` only.)*
- *(Fill in: e.g. first-run permissions on log directory.)*

### Evidence

- *(Attach screenshot of htop/nmon, and terminal output of `tail` on the metrics log.)*

---

## 2. Task 2 — User management and access control

### Implementation summary

- Created accounts for **Sarah** and **Mike** with strong passwords (set locally, not stored in Git).
- Created **`/home/Sarah/workspace`** and **`/home/mike/workspace`** with **`700`** permissions so only the owner can access.
- Applied **30-day password expiration** with `chage` (and optional `/etc/login.defs` defaults).
- Configured **password complexity** using **pam_pwquality** (RHEL) or equivalent on Ubuntu.

### Challenges encountered

- *(Fill in: e.g. aligning username vs. `/home/Sarah` casing.)*
- *(Fill in: e.g. PAM file location on your distro.)*

### Evidence

- *(Paste `getent passwd`, `ls -ld` on home dirs, `chage -l`, and a failed peer `ls` attempt.)*

---

## 3. Task 3 — Automated backups

### Implementation summary

- **Sarah (Apache):** `scripts/backup_apache_sarah.sh` → `/backups/apache_backup_YYYY-MM-DD.tar.gz`
- **Mike (Nginx):** `scripts/backup_nginx_mike.sh` → `/backups/nginx_backup_YYYY-MM-DD.tar.gz`
- **Schedule:** Cron **`0 0 * * 2`** (Tuesday 00:00).
- **Integrity:** Each run appends **`tar -tzf`** listing to `/backups/apache_verification.log` and `/backups/nginx_verification.log`.

### Cron configuration

- *(Paste `sudo crontab -l` or `/etc/cron.d/devops-backups` as deployed.)*

### Challenges encountered

- *(Fill in: e.g. RHEL vs Debian Apache paths — script includes both `/etc/httpd` and `/etc/apache2`.)*

### Evidence

- *(Paste `ls -lh /backups/` and log excerpts.)*

---

## 4. Repository

**GitHub URL:** *(add after you push)*

---

## 5. Conclusion

Briefly state how the environment meets monitoring, least-privilege workspace isolation, password policy, and scheduled backup/verification requirements. Mention any follow-up (e.g. off-box copy of `/backups`, alerting on disk full).
