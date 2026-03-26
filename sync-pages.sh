#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$repo_dir"

if [[ -z "$(git status --porcelain)" ]]; then
  echo "No local changes."
  exit 0
fi

git add -A

if git diff --cached --quiet; then
  echo "No staged changes after ignore rules."
  exit 0
fi

msg="${*:-sync: $(date '+%Y-%m-%d %H:%M:%S')}"
git commit -m "$msg"

if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  b64="$(printf 'x-access-token:%s' "$GITHUB_TOKEN" | base64)"
  GIT_TERMINAL_PROMPT=0 git -c http.https://github.com/.extraheader="AUTHORIZATION: basic $b64" push origin main
else
  git push origin main
fi

echo "Synced to GitHub Pages source: main"
