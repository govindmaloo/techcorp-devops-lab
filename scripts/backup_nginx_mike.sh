#!/usr/bin/env bash
# Task 3 (Mike): Backup Nginx config + default docroot.

set -euo pipefail

BACKUP_ROOT="${BACKUP_ROOT:-/backups}"
mkdir -p "$BACKUP_ROOT"

DATE="$(date +%Y-%m-%d)"
ARCHIVE="${BACKUP_ROOT}/nginx_backup_${DATE}.tar.gz"
VERIFY_LOG="${BACKUP_ROOT}/nginx_verification.log"

SOURCES=()
for p in /etc/nginx /usr/share/nginx/html; do
  if [[ -e "$p" ]]; then
    SOURCES+=("$p")
  fi
done

if [[ ${#SOURCES[@]} -eq 0 ]]; then
  echo "No Nginx paths found. Install nginx or adjust paths." >&2
  exit 1
fi

tar -czf "$ARCHIVE" "${SOURCES[@]}"

{
  echo "========== $(date -Is) nginx backup =========="
  echo "Archive: $ARCHIVE"
  tar -tzf "$ARCHIVE" | head -n 50
  echo "... (listing truncated if very large; full count: $(tar -tzf "$ARCHIVE" | wc -l) entries)"
  echo ""
} >>"$VERIFY_LOG"

echo "Created $ARCHIVE ; verification appended to $VERIFY_LOG"
