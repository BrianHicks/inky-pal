#!/usr/bin/env bash
set -euo pipefail

SSH_TARGET="${1:-}"

if test -z "$SSH_TARGET"; then
  echo "usage: ${0:-} SSH_TARGET"
  exit 1
fi
