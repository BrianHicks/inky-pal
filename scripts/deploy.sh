#!/usr/bin/env bash
set -euo pipefail

SSH_TARGET="${1:-}"

if test -z "$SSH_TARGET"; then
  echo "usage: ${0:-} SSH_TARGET"
  exit 1
fi

CODE_LOC="inky-pal"
VENV_LOC="inky-pal-venv"

echo "== COPYING CODE"
rsync -rv --filter ':- .gitignore' --exclude '/.git' --exclude '/.direnv' . "$SSH_TARGET:$CODE_LOC"

echo
echo "== SETTING UP VENV"
ssh "$SSH_TARGET" "if ! test -d $VENV_LOC; then python3 -m venv $VENV_LOC; fi"

echo
echo "== INSTALLING DEPS"
ssh "$SSH_TARGET" "$VENV_LOC/bin/pip install -r $CODE_LOC/requirements.txt"

echo
echo "== ALL DONE HOORAY"
