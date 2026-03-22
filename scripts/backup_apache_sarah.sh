#!/usr/bin/env bash
# Task 3 (Sarah): Backup Apache config + docroot. Run as user with read access or root.

set -euo pipefail

BACKUP_ROOT="${BACKUP_ROOT:-/backups}"
mkdir -p "$BACKUP_ROOT"

DATE="$(date +%Y-%m-%d)"
ARCHIVE="${BACKUP_ROOT}/apache_backup_${DATE}.tar.gz"
VERIFY_LOG="${BACKUP_ROOT}/apache_verification.log"

# Adjust paths if your distro uses /etc/apache2 and /var/www/html only
SOURCES=()
for p in /etc/httpd /etc/apache2 /var/www/html; do
  if [[ -e "$p" ]]; then
    SOURCES+=("$p")
  fi
done

if [[ ${#SOURCES[@]} -eq 0 ]]; then
  echo "No Apache paths found (/etc/httpd, /etc/apache2, /var/www/html). Install httpd or create paths." >&2
  exit 1
fi

tar -czf "$ARCHIVE" "${SOURCES[@]}"

{
  echo "========== $(date -Is) apache backup =========="
  echo "Archive: $ARCHIVE"
  tar -tzf "$ARCHIVE" | head -n 50
  echo "... (listing truncated if very large; full count: $(tar -tzf "$ARCHIVE" | wc -l) entries)"
  echo ""
} >>"$VERIFY_LOG"

echo "Created $ARCHIVE ; verification appended to $VERIFY_LOG"
