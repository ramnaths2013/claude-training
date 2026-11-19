---
description: Publish this project to a GitHub repo (code, README, About, Pages, CI/CD, secret scan)
argument-hint: <owner/repo | https://github.com/owner/repo>
allowed-tools: Bash(git:*), Bash(gh:*), Bash(grep:*), Bash(ls:*), Bash(curl:*), Read, Write, Edit, Glob, Grep, AskUserQuestion, mcp__github__*
---

# /publish-to-github

Publish this project to the GitHub repository given in `$ARGUMENTS`, set up its
README, About box, GitHub Pages and CI/CD, and make sure nothing sensitive goes
online. Work through the steps in order. Re-running must be safe: update files
and settings in place, never duplicate them.

## Step 0 - Parse input and confirm
1. Normalise `$ARGUMENTS` to `owner/repo` (accept `owner/repo`, `https://github.com/owner/repo(.git)`, `git@github.com:owner/repo.git`). If empty or unparseable, ask the user for it with AskUserQuestion. Do not guess.
2. Read `CLAUDE.md` and follow its constraints (single `index.html`, vanilla, no persistence, no external resources, no real UOB branding).
3. Tool choice: use the `gh` CLI if it is installed and authenticated (`gh auth status`); otherwise use the `mcp__github__*` tools. If the repo is outside the session's granted GitHub scope, call `add_repo` or report the block. Do not work around it.
4. Tell the user what will be pushed, to which repo and branch, and ask for confirmation before the first push and before creating a repo or changing repo settings (skip only if they already said to go ahead).

## Step 1 - Sensitive-data gate (BLOCKING, runs before any push)
Run all checks. **Any finding stops the command**: report `file:line` (redact the secret value) and push nothing until it is fixed.
1. **Forbidden files** in `git ls-files` and the working tree: `.env*`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `id_rsa*`, `*.kdbx`, `credentials*`, `secrets*`, `.claude/settings.local.json`, `*.sqlite`, `*.log`. Never stage them; add them to `.gitignore`.
2. **Secret patterns** in the working tree AND full history (`git log -p --all`): `AKIA[0-9A-Z]{16}`, `gh[pousr]_[A-Za-z0-9]{20,}`, `github_pat_`, `sk-[A-Za-z0-9]{20,}`, `xox[abprs]-`, `-----BEGIN .*PRIVATE KEY-----`, `(password|passwd|secret|token|api[_-]?key)\s*[:=]\s*['"][^'"]+['"]`, `Bearer\s+[A-Za-z0-9._-]{20,}`.
3. **Personal data**: email addresses in tracked files, especially the `FORMSUBMIT_ENDPOINT` constant. A raw personal email in that URL exposes it publicly, so use FormSubmit's random alias/hash form or a clearly marked placeholder, and warn the user. Also check commit author metadata and warn if it exposes a private email (suggest the GitHub `noreply` address).
4. **Project rules**: `grep -nE 'localStorage|sessionStorage|indexedDB|cookie|!important' index.html` must return nothing; no external `src=`/`href=` resources other than FormSubmit.
5. Run GitHub secret scanning (`mcp__github__run_secret_scanning`) on the changes when available.
6. Create or extend `.gitignore` (env files, keys, logs, `.claude/settings.local.json`, OS/editor junk such as `.DS_Store`, `.idea/`, `.vscode/`, `node_modules/`).

## Step 2 - Upload the code
1. Set `origin` to the target repo (`git remote add` or `git remote set-url`; do not embed tokens in the URL). If the repo does not exist, ask before creating it (public/private, empty).
2. Commit with a clear message, including any attribution lines the session requires. Stage files by name, never `git add -A` blindly.
3. Push the session's development branch: `git push -u origin <branch>`. Retry network errors up to 4 times with backoff. **Never** use `--force` or `--no-verify`.
4. GitHub Pages deploys from the default branch. If the dev branch is not the default branch, ask the user whether to merge it. Do not open a pull request unless asked.

## Step 3 - README.md (create or edit in place)
Preserve existing user-written content. Include:
- Title and one-line description (single-page IT PMO Kanban board, demo/training tool).
- Live demo link (filled in at Step 6) and CI and Pages status badges.
- Features: drag-and-drop, Move select, filters, inline delete confirm, form validation, add-task flow with toasts, responsive layout below 768px.
- Run: double-click `index.html`; no build, server or install.
- Constraints: vanilla HTML/CSS/JS, no external resources, no persistence (state resets on refresh), the only network call is the FormSubmit notification.
- Disclaimer: fictitious bank, demo only, no real UOB logos or trademarks.

## Step 4 - CI/CD with GitHub Actions
Create or update these files. Pin actions to major versions and use least-privilege `permissions`.
- `.github/workflows/ci.yml` on push and pull_request:
  - checkout
  - fail if `grep -nE 'localStorage|sessionStorage|indexedDB|cookie|!important' index.html` matches
  - fail on external resources (`src|href` to `http(s)://` other than the FormSubmit endpoint)
  - Playwright headless smoke test: open `index.html` via `file://`, expect 8 seeded cards and no console errors
- `.github/workflows/pages.yml` on push to the default branch (and `workflow_dispatch`):
  - `permissions: contents: read, pages: write, id-token: write`; `concurrency: group: pages`
  - checkout, copy only `index.html` into `_site/`, `actions/configure-pages`, `actions/upload-pages-artifact` (path `_site`), `actions/deploy-pages`

## Step 5 - GitHub Pages
1. Enable Pages with source **GitHub Actions**: `gh api -X POST repos/OWNER/REPO/pages -f build_type=workflow` (use `PUT` if it already exists), or the MCP equivalent.
2. If the token lacks admin rights, tell the user the manual path: repo Settings -> Pages -> Source: GitHub Actions.
3. Expected URL: `https://OWNER.github.io/REPO/`. Wait for the deploy run to finish, then verify with `curl -sI` that it returns 200. If the first run fails, read the job logs and fix the cause.

## Step 6 - Repo About + Pages link
1. Set description, topics and homepage: `gh repo edit OWNER/REPO --description "Single-page IT PMO Kanban board - demo/training tool (fictitious bank)" --homepage "https://OWNER.github.io/REPO/" --add-topic kanban --add-topic pmo --add-topic vanilla-js --add-topic github-pages --add-topic demo` (fallback: `gh api -X PATCH repos/OWNER/REPO`).
2. Put the same Pages link into the README live-demo line and commit and push that change.

## Step 7 - Final verification and report
1. Re-run the Step 1 scans against what is actually on the remote (`git ls-tree -r origin/<branch>` plus the pushed content).
2. Confirm the CI run is green, the Pages URL returns 200, and About shows the homepage.
3. Report a short checklist (done / failed / skipped, with reasons) and give full markdown links to the repo, Pages site and workflow runs. State failures plainly. Never claim success for a step you did not verify.

## Safety rules
- Never print, log or commit tokens or secrets. Never send the user's email address to any service.
- No force-push, no `--no-verify`, no deleting remote branches or repos.
- Confirm before creating a repo, the first push and settings changes.
