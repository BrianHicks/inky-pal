#!/usr/bin/env bash
set -euo pipefail

if ! test -d venv; then
  python3 -m venv venv
fi

./venv/bin/python3 -m pip install -r dev-requirements.txt
