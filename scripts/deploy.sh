#!/usr/bin/env bash
set -euo pipefail

SSH_TARGET="${1:-}"

if test -z "$SSH_TARGET"; then
  echo "usage: ${0:-} SSH_TARGET"
  exit 1
fi

echo "== COPYING CODE"
rsync -rv --filter ':- .gitignore' --exclude '/.git' --exclude '/.direnv' . "$SSH_TARGET:~/inky-pal"

echo
echo "== SETTING UP VENV"
VENV_LOC=/home/pi/inky-pal-venv
ssh "$SSH_TARGET" "test -d venv || python3 -m venv $VENV_LOC"

echo
echo "== INSTALLING DEPS"
scp requirements.txt "$SSH_TARGET:~/requirements.txt"
ssh "$SSH_TARGET" "$VENV_LOC/bin/pip install -r ~/requirements.txt"
