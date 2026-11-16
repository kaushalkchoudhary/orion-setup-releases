#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f source-commit || -L source-commit ]]; then
  echo 'source-commit must be a regular file containing one full source revision.' >&2
  exit 1
fi

commit=$(cat source-commit)
bytes=$(LC_ALL=C wc -c < source-commit)
if [[ ! "$commit" =~ ^[a-f0-9]{40}$ ]] || (( bytes < 40 || bytes > 41 )); then
  echo 'source-commit must contain exactly 40 lowercase hexadecimal characters, with at most one trailing newline.' >&2
  exit 1
fi
printf 'Source revision is valid: %s\n' "$commit"
