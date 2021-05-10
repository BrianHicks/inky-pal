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
echo "== INSTALLING SYSTEM DEPENDENCIES"

system-dep() {
  echo "${1:-}"
  if ! ssh "$SSH_TARGET" "dpkg -s ${1:-}" > /dev/null 2>&1; then
    ssh "$SSH_TARGET" "sudo apt-get install --assume-yes ${1:-}"
  fi
}

system-dep libatlas-base-dev
system-dep libopenjp2-7-dev
system-dep libtiff-dev

echo
echo "== SETTING UP VENV"
ssh "$SSH_TARGET" "if ! test -d $VENV_LOC; then python3 -m venv $VENV_LOC; fi"

echo
echo "== INSTALLING DEPS"
ssh "$SSH_TARGET" "$VENV_LOC/bin/pip install -r $CODE_LOC/requirements.txt"

echo
echo "== ALL DONE HOORAY"
