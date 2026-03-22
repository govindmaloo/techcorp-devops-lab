#!/usr/bin/env bash
# Task 1: Install interactive monitors (htop and/or nmon). RHEL-family + Debian.

set -euo pipefail

if [[ "${EUID:-0}" -ne 0 ]]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

if command -v dnf >/dev/null 2>&1; then
  dnf install -y htop nmon || dnf install -y htop
elif command -v yum >/dev/null 2>&1; then
  yum install -y htop nmon || yum install -y htop
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y htop nmon || apt-get install -y htop
else
  echo "Unknown package manager; install htop/nmon manually." >&2
  exit 1
fi

echo "Installed. Use: htop   or   nmon"
