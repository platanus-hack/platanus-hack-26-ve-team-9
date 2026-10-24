#!/usr/bin/env bash
# Configures `origin` so a single `git push` updates both the org repo
# (hackathon submission) and the private deploy repo (Vercel, Render, ...).
# Safe to re-run: it resets the push URLs every time.
set -euo pipefail

ORG_REPO="https://github.com/platanus-hack/platanus-hack-26-ve-team-9.git"
DEPLOY_REPO="https://github.com/EwaldoChikito/platanus-hack-26-ve-team-9-deploy.git"

cd "$(git rev-parse --show-toplevel)"

git remote get-url origin >/dev/null 2>&1 || git remote add origin "$ORG_REPO"

# Fetch from the org repo, the source of truth for the hackathon.
git remote set-url origin "$ORG_REPO"

# Reset push URLs, then register both targets.
git config --unset-all remote.origin.pushurl 2>/dev/null || true
git remote set-url --add --push origin "$ORG_REPO"
git remote set-url --add --push origin "$DEPLOY_REPO"

echo "origin now pushes to both repositories:"
git remote -v
