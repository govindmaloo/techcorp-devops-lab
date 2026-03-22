# Task 2: User Management and Access Control

## Requirements summary

| Item | Detail |
|------|--------|
| Users | **Sarah**, **Mike** — strong unique passwords (set interactively; do not commit passwords). |
| Directories | `/home/Sarah/workspace`, `/home/mike/workspace` |
| Permissions | Only the owning user can access their workspace (no group/others). |
| Password policy | Complexity + **30-day expiration** (system defaults + per-user `chage`). |

> **Case sensitivity:** The brief specifies `/home/Sarah/workspace` (capital **S**). Linux usernames are usually lowercase; you can use username `sarah` with home `/home/Sarah` only if you override defaults, or use `useradd -m -d /home/Sarah sarah` as below. Adjust to match your instructor’s exact spelling.

## 1. Create users and home layout

As root:

```bash
# Sarah — home directory explicitly /home/Sarah
sudo useradd -m -d /home/Sarah sarah
sudo mkdir -p /home/Sarah/workspace
sudo chown -R sarah:sarah /home/Sarah
sudo chmod 700 /home/Sarah /home/Sarah/workspace

# Mike
sudo useradd -m -d /home/mike mike
sudo mkdir -p /home/mike/workspace
sudo chown -R mike:mike /home/mike
sudo chmod 700 /home/mike /home/mike/workspace
```

Set passwords (prompted; type strong passwords):

```bash
sudo passwd sarah
sudo passwd mike
```

## 2. Enforce 30-day password expiration

Per user:

```bash
sudo chage -M 30 sarah
sudo chage -M 30 mike
sudo chage -l sarah
sudo chage -l mike
```

System-wide defaults (optional, affects new users):

```bash
# Edit as root
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t30/' /etc/login.defs
```

## 3. Password complexity (RHEL-family with **pwquality**)

Install PAM module if needed:

```bash
sudo dnf install -y libpwquality
```

Edit `/etc/security/pwquality.conf` (example minimums):

```conf
minlen = 12
minclass = 3
```

Ensure `/etc/pam.d/system-auth` (or `password-auth`) includes a line like:

```text
password requisite pam_pwquality.so try_first_pass local_users_only retry=3
```

Ubuntu/Debian often uses **pam_pwquality** or **pam_cracklib** similarly under `/etc/pam.d/common-password`.

After changes, test with `passwd` as each user; weak passwords should be rejected.

## 4. Verify isolation

As **sarah**, this should **fail** (permission denied):

```bash
ls /home/mike/workspace
```

As **mike**:

```bash
ls /home/Sarah/workspace
```

Each user should read/write only under their own `workspace`.

## Evidence for your report

- Output of `getent passwd sarah mike`
- Output of `ls -ld /home/Sarah /home/Sarah/workspace /home/mike /home/mike/workspace`
- Output of `chage -l sarah` and `chage -l mike`
- Screenshot or transcript of a failed cross-user `ls` on the peer’s workspace

## Challenges (examples)

- Matching **Sarah** home path casing with default `useradd` behavior.
- PAM differences between RHEL and Ubuntu — verify the correct `pam.d` file for your distro.
