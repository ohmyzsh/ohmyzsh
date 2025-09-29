# glab plugin

This plugin adds support for the [GitLab CLI (`glab`)](https://gitlab.com/gitlab-org/cli), a tool to interact with GitLab from the terminal.

## Features

- **Shell completion**: enables `zsh` completions for `glab` automatically if it is installed.  
- **Environment setup**: loads `GITLAB_HOST` and `GITLAB_TOKEN` from `~/.netrc` if they are not already set.  
- **Aliases**: provides convenient shortcuts for common GitLab CLI commands.  
- **Helper functions**: adds extra functions for common GitLab workflows, including merge requests, issues, CI/CD pipelines, repositories, and releases.  

## Aliases

| Alias       | Command           | Description                     |
|------------ |------------------ |-------------------------------- |
| `gl`        | `glab`            | Shortcut for `glab`             |
| `glmr`      | `glab mr`         | Manage merge requests           |
| `glissue`   | `glab issue`      | Manage issues                   |
| `glrepo`    | `glab repo`       | Manage repositories             |
| `glci`      | `glab ci`         | Manage CI pipelines             |
| `glprj`     | `glab project`    | Manage projects                 |
| `glrelease` | `glab release`    | Manage releases                 |

## Helper functions

### Merge Requests
- `glmr-open [<MR>]`  
  Opens a merge request in the browser. If `<MR>` is not specified, opens the current branch MR.

- `glmr-checkout <MR>`  
  Checks out the merge request branch locally.

- `glmr-merge <MR>`  
  Merges a merge request and optionally removes the source branch.

- `glmr-list [<args>]`  
  Lists merge requests assigned to you. Additional `glab mr list` arguments can be passed.

### Issues
- `glissue-new [<title>]`  
  Creates a new issue. If a title is provided, it is used; otherwise an interactive prompt is opened.

- `glissue-close <issue>`  
  Closes the specified issue.

- `glissue-list [<args>]`  
  Lists open issues assigned to you. Additional `glab issue list` arguments can be passed.

### CI/CD
- `glci-status [<args>]`  
  Opens the current CI pipeline status in the browser.

- `glci-retry <pipeline>`  
  Retries the specified pipeline.

- `glci-latest`  
  Shows the latest pipeline.

### Repositories
- `glrepo-clone <project>`  
  Clones a repository.

- `glrepo-list [<args>]`  
  Lists all repositories you are a member of.

- `glrepo-open <project>`  
  Opens a repository in the browser.

- `glrepo-starred [<args>]`  
  Lists your starred repositories.

### Releases
- `glrelease-create "<title>" "<tag>"`  
  Creates a new release with the given title and tag.

### Search
- `glsearch <keyword>`  
  Searches for merge requests and issues matching the keyword.

## Environment variables

The plugin attempts to set the following variables if they are not already defined:

- `GITLAB_HOST` — taken from the first `machine` entry in `~/.netrc`.  
- `GITLAB_TOKEN` — the corresponding `password` from `~/.netrc`.  

## Usage

1. Install [`glab`](https://gitlab.com/gitlab-org/cli#installation).  
2. Enable the plugin in your `.zshrc`:

```zsh
plugins=(git glab)