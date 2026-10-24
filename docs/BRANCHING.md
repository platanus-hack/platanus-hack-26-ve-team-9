# Branching workflow

```
main  ──●───────────────●──────  production (deploy platform listens here)
         \             /
dev       ●──●───●──●─●────────  integration + testing, branches from main
              \  /  \ /
feat/...       ●●    ●●          one branch per implementation, branches from dev
```

| Branch | Purpose | Rules |
| ------ | ------- | ----- |
| `main` | Production. Every push triggers a deploy. | Only receives merges from `dev`. Never commit here directly. |
| `dev` | Integration and testing. | Only receives merges from feature branches. Never commit here directly. |
| `<type>/<short-name>` | One implementation. Always created from `dev`. | Short-lived. Delete after merging. |

## Branch names

`<type>/<short-kebab-name>`, where type is one of:

`feat` (new functionality), `fix` (bug), `backend`, `frontend`, `ux` (UX/UI), `docs`, `chore`.

Examples: `feat/sos-button`, `backend/alerts-api`, `frontend/map-view`, `ux/onboarding`.

Commits use [Conventional Commits](https://www.conventionalcommits.org/): `feat: add sos button`.

## Day to day

Requires `./scripts/setup-mirror.sh` to have been run once (see [DEPLOY-MIRROR.md](DEPLOY-MIRROR.md)).

```bash
# 1. Start an implementation from an up-to-date dev
git switch dev && git pull --ff-only
git switch -c feat/sos-button

# 2. Work, commit, and push (goes to both repos)
git push -u origin feat/sos-button

# 3. Integrate into dev (merge locally, see warning below)
git switch feat/sos-button && git merge dev      # resolve conflicts here, not in dev
git switch dev && git pull --ff-only
git merge --no-ff feat/sos-button
git push                                          # test on dev

# 4. Clean up
git branch -d feat/sos-button
git push origin --delete feat/sos-button
```

## Release to production (dev → main)

Only when `dev` has been tested.

```bash
git switch main && git pull --ff-only
git merge --no-ff dev
git push                  # triggers the deploy
git switch dev && git merge --ff-only main    # keep dev aligned with main
git push
```

## Warning: merge locally, never with the GitHub button

`git push` sends commits to two repositories. The GitHub "Merge" button creates a commit in
**one** of them only, so the repos diverge and the next push to the other one is rejected.
Opening a pull request just for review is fine; close it by merging locally and pushing.

## Deploy platform

Set the **production branch to `main`** in Vercel/Render, connected to the private deploy
repo. Pushes to `dev` and feature branches can produce preview deployments, or none:
check the platform's preview settings.
