# Deploy mirror

Deploy platforms (Vercel, Render, Netlify) cannot connect to the org repo, so every
commit is mirrored to a private deploy repo.

- Org repo (hackathon submission): `platanus-hack/platanus-hack-26-ve-team-9`
- Deploy repo (private, connect Vercel/Render here): `EwaldoChikito/platanus-hack-26-ve-team-9-deploy`

## Setup (once per clone, every teammate)

```bash
git clone https://github.com/platanus-hack/platanus-hack-26-ve-team-9.git
cd platanus-hack-26-ve-team-9
./scripts/setup-mirror.sh
```

From then on `git push` sends every commit to **both** repositories. Both repos must
always hold the same commits: never push to only one of them.

## Requirements

- Write access to the org repo (team members already have it).
- Collaborator access to the deploy repo: ask its owner to invite your GitHub user.

## Verify

```bash
git remote -v   # origin must list two (push) URLs
```
