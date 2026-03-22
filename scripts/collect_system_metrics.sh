#!/usr/bin/env bash
# Task 1: Log CPU/memory/process and disk usage for capacity planning.
# Run via cron (e.g. hourly) or manually: sudo ./collect_system_metrics.sh

set -euo pipefail

LOG_DIR="${SYSMETRICS_LOG_DIR:-/var/log/sysmetrics}"
LOG_FILE="${LOG_DIR}/metrics_$(date +%Y-%m-%d).log"
mkdir -p "$LOG_DIR"

{
  echo "========== $(date -Is) =========="
  echo "--- load / uptime ---"
  uptime 2>/dev/null || true
  echo "--- memory (summary) ---"
  if command -v free >/dev/null 2>&1; then
    free -h
  else
    vm_stat 2>/dev/null || true
  fi
  echo "--- top CPU processes (snapshot) ---"
  if command -v ps >/dev/null 2>&1; then
    ps aux --sort=-%cpu 2>/dev/null | head -n 15 || ps aux | head -n 15
  fi
  echo "--- top memory processes (snapshot) ---"
  ps aux --sort=-%mem 2>/dev/null | head -n 15 || true
  echo "--- disk free (df -h) ---"
  df -hP 2>/dev/null || df -h
  echo "--- disk usage sample (du -sh, depth 1 under /var and /home) ---"
  du -sh /var/* 2>/dev/null | sort -hr | head -n 20 || true
  du -sh /home/* 2>/dev/null | sort -hr | head -n 20 || true
  echo ""
} >>"$LOG_FILE"

echo "Metrics appended to $LOG_FILE"
