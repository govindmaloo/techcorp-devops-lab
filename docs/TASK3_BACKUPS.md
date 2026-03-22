# Task 3: Backup Configuration for Web Servers

## Scope

| Owner | Stack | Paths backed up |
|-------|--------|-----------------|
| Sarah | Apache | `/etc/httpd/` (and `/etc/apache2` on Debian/Ubuntu if present), `/var/www/html/` |
| Mike | Nginx | `/etc/nginx/`, `/usr/share/nginx/html/` |

Archives: **`/backups/apache_backup_YYYY-MM-DD.tar.gz`** and **`/backups/nginx_backup_YYYY-MM-DD.tar.gz`**

Schedule: **Every Tuesday at 12:00 AM** — cron: `0 0 * * 2` (Sunday=0, Tuesday=2 in Vixie cron).

## 1. Prepare directories and scripts

```bash
sudo mkdir -p /backups
sudo cp -a /path/to/tls/scripts /opt/devops-lab/tls/scripts   # or symlink
sudo chmod +x /opt/devops-lab/tls/scripts/*.sh
```

Ensure **httpd** and **nginx** are installed (or create placeholder dirs for a dry run):

```bash
sudo dnf install -y httpd nginx   # RHEL example
```

## 2. Manual test

```bash
sudo bash /opt/devops-lab/tls/scripts/backup_apache_sarah.sh
sudo bash /opt/devops-lab/tls/scripts/backup_nginx_mike.sh
ls -lh /backups/*.tar.gz
tail -n 40 /backups/apache_verification.log
tail -n 40 /backups/nginx_verification.log
```

Integrity check: each run appends a **`tar -tzf`** listing to the verification logs.

## 3. Cron configuration

**Option A — root crontab**

```bash
sudo crontab -e
```

Add (fix path):

```cron
0 0 * * 2 /usr/bin/bash /opt/devops-lab/tls/scripts/backup_apache_sarah.sh
0 0 * * 2 /usr/bin/bash /opt/devops-lab/tls/scripts/backup_nginx_mike.sh
```

**Option B — `/etc/cron.d`**

```bash
sudo cp cron/devops-backups.cron /etc/cron.d/devops-backups
sudo sed -i 's|/opt/devops-lab/tls/scripts|/your/actual/path/scripts|g' /etc/cron.d/devops-backups
sudo chmod 644 /etc/cron.d/devops-backups
```

List:

```bash
sudo crontab -l
ls -l /etc/cron.d/devops-backups
```

## Evidence for your report

- `crontab -l` or contents of `/etc/cron.d/devops-backups`
- `ls -lh /backups/`
- Snippet from `apache_verification.log` / `nginx_verification.log` showing `tar -tzf` output

## Challenges (examples)

- Scripts must run as a user that can read all backed-up paths (often **root**).
- Same calendar day: re-running the script **overwrites** the same `*_backup_YYYY-MM-DD.tar.gz`; that is usually acceptable for a weekly Tuesday job.
