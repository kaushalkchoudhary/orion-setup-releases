#!/usr/bin/env bash
set -euo pipefail

checker=$(cd "$(dirname "$0")" && pwd)/check-source-commit.sh
sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT
cd "$sandbox"
revision=0123456789abcdef0123456789abcdef01234567

check() {
  local expected=$1 content=$2 observed=0
  printf '%s' "$content" > source-commit
  bash "$checker" >/dev/null 2>&1 || observed=$?
  if [[ "$observed" != "$expected" ]]; then
    printf 'Expected exit %s, got %s for fixture %q\n' "$expected" "$observed" "$content" >&2
    exit 1
  fi
}

check 0 "$revision"
check 0 "$revision"$'\n'
check 1 ''
check 1 "${revision:0:39}"
check 1 "${revision}0"
check 1 "${revision} "
check 1 "${revision}"$'\r\n'
check 1 "${revision}"$'\n\n'
check 1 "${revision}"$'\n'"$revision"
check 1 '0123456789ABCDEF0123456789ABCDEF01234567'
rm source-commit
if bash "$checker" >/dev/null 2>&1; then echo 'Missing file was accepted' >&2; exit 1; fi
printf '%s\n' "$revision" > revision.txt
ln -s revision.txt source-commit
if bash "$checker" >/dev/null 2>&1; then echo 'Symlink was accepted' >&2; exit 1; fi
printf 'Source revision checks passed: 12 fixtures; no release or private-source access.\n'
