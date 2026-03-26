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
git push origin main

echo "Synced to GitHub Pages source: main"
