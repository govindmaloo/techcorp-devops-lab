# DevOps Lab: Monitoring, Users & Web Server Backups

This repository contains scripts and documentation for **TechCorp** development environment tasks (monitoring, user management, automated backups). You can run everything on a **Linux lab VM** or use the included **Docker** lab (recommended for screenshots and local deliverables).

---

## Expected deliverables (assignment)

These match the course submission requirements.

| Deliverable | What to provide |
|-------------|-----------------|
| **Task 1 — evidence** | Screenshots or terminal output showing **htop** or **nmon**, **df** / **du** style disk usage, process visibility (e.g. **ps** or metrics log), and **metrics logging** (e.g. output from `collect_system_metrics.sh` or `tail` of the daily log under `/var/log/sysmetrics/`, or host path `docker-artifacts/sysmetrics/` in Docker). |
| **Task 2 — evidence** | Screenshots or terminal output for **user accounts** (Sarah / Mike), **`ls -ld`** on home and workspace dirs, **`chage -l`** showing 30-day policy, **permission denied** when one user tries to access the other’s workspace, and (where applicable) **password complexity** (e.g. `pam_pwquality` / `pwquality.conf`). |
| **Task 3 — evidence** | **Cron** configuration (e.g. `cat /etc/cron.d/devops-backups` or `crontab -l`) showing **Tuesday 00:00** (`0 0 * * 2`), **backup archives** under `/backups/` with names like `apache_backup_YYYY-MM-DD.tar.gz` and `nginx_backup_YYYY-MM-DD.tar.gz`, and **verification logs** showing archive integrity (**`tar -tzf`** listing in `apache_verification.log` / `nginx_verification.log`). With Docker, the same files appear on the host in **`docker-artifacts/backups/`**. |
| **Report** | **`REPORT.md`** completed: implementation summary, **challenges**, and pointers to your evidence (or pasted excerpts). Convert to PDF/Word if your rubric requires it. |
| **GitHub + Vlearn** | Push this repo to **GitHub** and submit the **repository URL** via **Vlearn** (in a text/PDF/Word file if instructed). |

Optional: attach **`deliverables-terminal.txt`** if you save the verify script output (see steps below). Generated backup `.tar.gz` and `.log` files are **gitignored** under `docker-artifacts/`; include them in your submission package if the grader wants files outside GitHub.

---

## Steps followed to finalize this task

Use this checklist to reproduce and close out the assignment.

1. **Repository layout**  
   Ensure scripts, `docs/`, `cron/`, `docker/`, `REPORT.md`, and `README.md` are present. Make scripts executable: `chmod +x scripts/*.sh`.

2. **Task 1 — monitoring**  
   - Install **htop** / **nmon** (Docker image already includes them; on a bare VM use `docs/TASK1_MONITORING.md` or `scripts/install_monitoring_tools.sh`).  
   - Run **`scripts/collect_system_metrics.sh`** (optionally on a schedule) and keep a sample log or screenshot.  
   - Capture **df** / **du** and a **resource snapshot** (verify script prints these in Docker).

3. **Task 2 — users and access**  
   - Follow **`docs/TASK2_USER_MANAGEMENT.md`** on a VM, or rely on the **Dockerfile** (users **sarah** / **mike**, `/home/Sarah/workspace`, `/home/mike/workspace`, `700`, `chage -M 30`, pwquality lines).  
   - Record **terminal output** for `getent passwd`, `ls -ld`, `chage -l`, and failed cross-user `ls` (verify script demonstrates the failures in Docker).

4. **Task 3 — backups and cron**  
   - Confirm **`scripts/backup_apache_sarah.sh`** and **`scripts/backup_nginx_mike.sh`** target the required paths.  
   - Install cron entries (**`cron/crontab.example`**, **`cron/devops-backups.cron`**, or Docker **`docker/crontab-lab`** → `/etc/cron.d/devops-backups`).  
   - Run backups manually at least once; confirm **`tar -tzf`** output is appended to the verification logs.

5. **Docker evidence (recommended)**  
   - Start Docker, then from the **repo root**:  
     `docker compose -f docker/docker-compose.yml build`  
   - Long-running lab (optional, for **htop** in a real shell):  
     `docker compose -f docker/docker-compose.yml up -d`  
     `docker compose -f docker/docker-compose.yml exec -it lab htop`  
   - One-shot transcript for Tasks 1–3 (screenshot or save to file):  
     `docker compose -f docker/docker-compose.yml run --rm --entrypoint /bin/bash lab /opt/devops-lab/tls/docker/verify-deliverables.sh`  
     Example save: add `| tee deliverables-terminal.txt` to the end of that command.

6. **Report and submission**  
   - Fill in **`REPORT.md`**: steps, challenges, GitHub URL placeholder, and where each screenshot/file lives.  
   - Push to GitHub: create a remote repository, `git remote add origin …`, `git push -u origin main` (or your branch name).  
   - Submit the **GitHub link** (and any required PDF/attachments) through **Vlearn**.

---

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
| `docker/` | Rocky Linux 9 lab image + `verify-deliverables.sh` for one-shot evidence |

---

## Quick start (Docker — screenshots / Task 3 artifacts on host)

From the **repository root**:

```bash
docker compose -f docker/docker-compose.yml up -d --build
```

- **Apache (Sarah):** [http://localhost:8080](http://localhost:8080) → container port 80  
- **Nginx (Mike):** [http://localhost:8081](http://localhost:8081) → container port 8080  

**Interactive `htop` (Task 1 screenshot):**

```bash
docker compose -f docker/docker-compose.yml exec -it lab htop
```

**One-shot terminal output for all tasks** (copy, save as `.txt`, or screenshot the scrollback):

```bash
docker compose -f docker/docker-compose.yml run --rm --entrypoint /bin/bash lab \
  /opt/devops-lab/tls/docker/verify-deliverables.sh
```

**Save output to a file for submission:**

```bash
docker compose -f docker/docker-compose.yml run --rm --entrypoint /bin/bash lab \
  -c '/opt/devops-lab/tls/docker/verify-deliverables.sh' | tee deliverables-terminal.txt
```

Backups and verification logs are written to **`docker-artifacts/backups/`** on your machine (bind-mounted). Lab-only passwords (change if you like): **sarah** / `LabSecure!Sarah2025`, **mike** / `LabSecure!Mike2025`.

---

## Quick start (lab server)

```bash
sudo mkdir -p /backups /var/log/sysmetrics
chmod +x scripts/*.sh
```

Install tools and register cron as described in `docs/`.

---

## Submission

Push this repository to **GitHub** and submit the **repository URL** via **Vlearn** as required by your course. Include screenshots or terminal captures and Task 3 artifacts per **Expected deliverables** above.
