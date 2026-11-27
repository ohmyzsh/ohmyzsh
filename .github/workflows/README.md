# Workflow checks

The `Workflow lint` workflow runs jactionlint on pull requests and pushes to
`master`. It checks workflows and Dependabot configuration with the default
profile, including ShellCheck for inline shell scripts. It runs without online
checks or publishing credentials.

To run the same checks locally, install jactionlint 2.6.0 and ShellCheck, then run
from the repository root:

```sh
jactionlint --profile=default --no-online
```

Keep the local jactionlint version aligned with the pinned action in `lint.yml`.
There is no baseline: new findings fail the check. Any rule exception should be
limited to the relevant line and explain why it is needed.

## Project tracking

`project.yml` intentionally uses `pull_request_target` so the GitHub App can add
fork contributions to the project board. It must not check out or execute PR
code. Project IDs are validated before passing them through step outputs, and
PR-derived plugin/theme names are restricted to letters, digits, dots, underscores
and hyphens.

The App tokens request explicit permissions: project tracking needs organization
projects write access and issues/pull requests read access; dependency updates
need contents read access and issues/pull requests write access. Dependency pushes
use the job's separate `GITHUB_TOKEN` with contents write access.

## Installer deployment

The Vercel CLI is pinned in `installer/package.json` and `installer/package-lock.json`.
Dependabot checks this dependency weekly, with a seven-day cooldown for version
updates, like the other configured ecosystems. Deployment installs the lockfile
with `npm ci --ignore-scripts`; `.vercelignore` uploads only `install.sh`.

After changing the CLI version, update its lockfile and verify the CLI locally:

```sh
npm install --package-lock-only --ignore-scripts --prefix .github/workflows/installer
npm ci --ignore-scripts --prefix .github/workflows/installer
.github/workflows/installer/node_modules/.bin/vercel --version
```
