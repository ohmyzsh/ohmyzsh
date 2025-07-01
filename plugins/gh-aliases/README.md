# gh-aliases

Provides extensive aliases for the [GitHub CLI](https://cli.github.com/) (`gh`) commands, covering repositories, issues, pull requests, workflows, and more. This plugin makes GitHub CLI operations faster and more convenient by providing memorable short aliases for common tasks.

To use it, add `gh-aliases` to the plugins array in your zshrc file:

```zsh
plugins=(... gh-aliases)
```

## Requirements

- [GitHub CLI](https://cli.github.com/) (`gh`) must be installed
- You must be authenticated with GitHub (`gh auth login`)

## Aliases

### Authentication Commands (`gh auth`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghal` | `gh auth login` | Login to GitHub |
| `ghas` | `gh auth status` | Show authentication status |
| `ghaw` | `gh auth switch` | Switch between GitHub accounts |
| `ghao` | `gh auth logout` | Logout from GitHub |
| `ghar` | `gh auth refresh` | Refresh authentication token |
| `ghat` | `gh auth token` | Display the auth token |

### Repository Commands (`gh repo`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghrc` | `gh repo clone` | Clone a repository |
| `ghrv` | `gh repo view` | View repository details |
| `ghrl` | `gh repo list` | List repositories |
| `ghrf` | `gh repo fork` | Fork a repository |
| `ghrs` | `gh repo sync` | Sync a forked repository |
| `ghrn` | `gh repo create` | Create a new repository |
| `ghrd` | `gh repo delete` | Delete a repository |
| `ghre` | `gh repo edit` | Edit repository settings |
| `ghra` | `gh repo archive` | Archive a repository |
| `ghru` | `gh repo unarchive` | Unarchive a repository |
| `ghrr` | `gh repo rename` | Rename a repository |

### Issue Commands (`gh issue`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghiv` | `gh issue view` | View an issue |
| `ghic` | `gh issue create` | Create a new issue |
| `ghil` | `gh issue list` | List issues |
| `ghie` | `gh issue edit` | Edit an issue |
| `ghix` | `gh issue close` | Close an issue |
| `ghir` | `gh issue reopen` | Reopen an issue |
| `ghid` | `gh issue delete` | Delete an issue |
| `ghia` | `gh issue assign` | Assign an issue |
| `ghit` | `gh issue transfer` | Transfer an issue |
| `ghip` | `gh issue pin` | Pin an issue |
| `ghiu` | `gh issue unpin` | Unpin an issue |
| `ghico` | `gh issue comment` | Comment on an issue |
| `ghis` | `gh issue status` | Show issue status |

### Pull Request Commands (`gh pr`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghpc` | `gh pr create` | Create a pull request |
| `ghpv` | `gh pr view` | View a pull request |
| `ghpl` | `gh pr list` | List pull requests |
| `ghpm` | `gh pr merge` | Merge a pull request |
| `ghpe` | `gh pr edit` | Edit a pull request |
| `ghpo` | `gh pr checkout` | Checkout a pull request |
| `ghpx` | `gh pr close` | Close a pull request |
| `ghpr` | `gh pr reopen` | Reopen a pull request |
| `ghpd` | `gh pr diff` | Show pull request diff |
| `ghpw` | `gh pr review` | Review a pull request |
| `ghps` | `gh pr status` | Show pull request status |
| `ghpa` | `gh pr assign` | Assign a pull request |
| `ghpt` | `gh pr ready` | Mark pull request as ready |
| `ghpco` | `gh pr comment` | Comment on a pull request |
| `ghpch` | `gh pr checks` | Show pull request checks |

### Workflow Commands (`gh workflow`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghwl` | `gh workflow list` | List workflows |
| `ghwr` | `gh workflow run` | Run a workflow |
| `ghwv` | `gh workflow view` | View workflow details |
| `ghwe` | `gh workflow enable` | Enable a workflow |
| `ghwd` | `gh workflow disable` | Disable a workflow |

### Run Commands (`gh run`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghrnl` | `gh run list` | List workflow runs |
| `ghrnv` | `gh run view` | View a workflow run |
| `ghrnc` | `gh run cancel` | Cancel a workflow run |
| `ghrnr` | `gh run rerun` | Rerun a workflow |
| `ghrnd` | `gh run download` | Download run artifacts |
| `ghrnw` | `gh run watch` | Watch a workflow run |

### Release Commands (`gh release`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghrec` | `gh release create` | Create a release |
| `ghrel` | `gh release list` | List releases |
| `ghrev` | `gh release view` | View a release |
| `ghred` | `gh release delete` | Delete a release |
| `ghreu` | `gh release upload` | Upload release assets |
| `ghrdo` | `gh release download` | Download release assets |
| `ghree` | `gh release edit` | Edit a release |

### Gist Commands (`gh gist`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghgc` | `gh gist create` | Create a gist |
| `ghgv` | `gh gist view` | View a gist |
| `ghgl` | `gh gist list` | List gists |
| `ghge` | `gh gist edit` | Edit a gist |
| `ghgd` | `gh gist delete` | Delete a gist |
| `ghgn` | `gh gist clone` | Clone a gist |

### Project Commands (`gh project`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghpjc` | `gh project create` | Create a project |
| `ghpjl` | `gh project list` | List projects |
| `ghpjv` | `gh project view` | View a project |
| `ghpje` | `gh project edit` | Edit a project |
| `ghpjx` | `gh project close` | Close a project |
| `ghpjd` | `gh project delete` | Delete a project |

### Search Commands (`gh search`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghsr` | `gh search repos` | Search repositories |
| `ghsc` | `gh search code` | Search code |
| `ghsi` | `gh search issues` | Search issues |
| `ghsp` | `gh search prs` | Search pull requests |
| `ghsu` | `gh search users` | Search users |
| `ghsm` | `gh search commits` | Search commits |

### Secret Commands (`gh secret`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghsec` | `gh secret set` | Set a secret |
| `ghsel` | `gh secret list` | List secrets |
| `ghsed` | `gh secret delete` | Delete a secret |

### SSH Key Commands (`gh ssh-key`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghka` | `gh ssh-key add` | Add SSH key |
| `ghkl` | `gh ssh-key list` | List SSH keys |
| `ghkd` | `gh ssh-key delete` | Delete SSH key |

### Label Commands (`gh label`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghll` | `gh label list` | List labels |
| `ghlc` | `gh label create` | Create a label |
| `ghle` | `gh label edit` | Edit a label |
| `ghld` | `gh label delete` | Delete a label |

### Alias Commands (`gh alias`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghalc` | `gh alias set` | Create an alias |
| `ghall` | `gh alias list` | List aliases |
| `ghald` | `gh alias delete` | Delete an alias |

### Config Commands (`gh config`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghcg` | `gh config get` | Get config value |
| `ghcs` | `gh config set` | Set config value |
| `ghcl` | `gh config list` | List config |

### Extension Commands (`gh extension`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghei` | `gh extension install` | Install an extension |
| `ghel` | `gh extension list` | List extensions |
| `gher` | `gh extension remove` | Remove an extension |
| `gheu` | `gh extension upgrade` | Upgrade extensions |
| `ghec` | `gh extension create` | Create an extension |

### Codespace Commands (`gh codespace`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghcsc` | `gh codespace create` | Create a codespace |
| `ghcsl` | `gh codespace list` | List codespaces |
| `ghcss` | `gh codespace ssh` | SSH into codespace |
| `ghcsd` | `gh codespace delete` | Delete a codespace |
| `ghcsv` | `gh codespace view` | View codespace details |
| `ghcse` | `gh codespace edit` | Edit in codespace |
| `ghcsr` | `gh codespace rebuild` | Rebuild codespace |
| `ghcso` | `gh codespace code` | Open codespace in VS Code |

### Cache Commands (`gh cache`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghchl` | `gh cache list` | List caches |
| `ghchd` | `gh cache delete` | Delete cache |

### GPG Key Commands (`gh gpg-key`)

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghgka` | `gh gpg-key add` | Add GPG key |
| `ghgkl` | `gh gpg-key list` | List GPG keys |
| `ghgkd` | `gh gpg-key delete` | Delete GPG key |

### General Commands

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghs` | `gh status` | Show GitHub status |
| `ghb` | `gh browse` | Open repository in browser |
| `gha` | `gh api` | Make authenticated GitHub API requests |
| `ghh` | `gh help` | Show help |
| `ghv` | `gh version` | Show version |

### Composite/Workflow Aliases

These aliases combine common operations for faster workflows:

| Alias | Command | Description |
| :---- | :------ | :---------- |
| `ghpcw` | `gh pr create -w` | Create PR and open in web browser |
| `ghpmd` | `gh pr merge -d` | Merge PR and delete branch |
| `ghpms` | `gh pr merge -s` | Squash and merge PR |
| `ghpmr` | `gh pr merge -r` | Rebase and merge PR |
| `ghicw` | `gh issue create -w` | Create issue and open in web browser |
| `ghilm` | `gh issue list -L 10` | List last 10 issues |
| `ghilmy` | `gh issue list -a @me` | List my assigned issues |
| `ghrcr` | `gh repo clone --recurse-submodules` | Clone repo with submodules |
| `ghrcp` | `gh repo create --private` | Create private repository |
| `ghrcpu` | `gh repo create --public` | Create public repository |

## Functions

### Helper Functions

- **`ghrc-cd <repo>`**: Clone a repository and change into its directory
  ```bash
  ghrc-cd user/repo  # Clones and cd into repo directory
  ```

- **`ghrn-cd <repo-name>`**: Create a new repository, clone it, and change into its directory
  ```bash
  ghrn-cd my-new-repo  # Creates repo, clones it, and cd into it
  ```

- **`ghpb [pr-number]`**: View pull request in browser (current branch if no number provided)
  ```bash
  ghpb        # Opens current branch's PR in browser
  ghpb 123    # Opens PR #123 in browser
  ```

- **`ghib [issue-number]`**: View issue in browser
  ```bash
  ghib        # Opens current issue in browser (if applicable)
  ghib 456    # Opens issue #456 in browser
  ```

- **`gh-status`**: Show comprehensive GitHub status including repository, PR info
  ```bash
  gh-status   # Shows overall status, repo info, and PR status
  ```

- **`ghpc-current`**: Create a pull request from the current branch (prevents creating from main/master)
  ```bash
  ghpc-current  # Creates PR from current branch if not on main/master
  ```

## Usage Examples

### Common Workflows

**Quick PR Creation Workflow:**
```bash
# Make changes, commit, push
git push -u origin feature-branch

# Create PR from current branch
ghpc-current

# Or create PR and open in browser
ghpcw
```

**Repository Management:**
```bash
# Clone and enter a repository
ghrc-cd owner/repo

# Create new private repo and start working
ghrn-cd my-project
```

**Issue Tracking:**
```bash
# List my issues
ghilmy

# Create issue and open in browser
ghicw

# View issue in terminal then browser
ghiv 123
ghib 123
```

**Release Management:**
```bash
# List releases
ghrel

# View latest release
ghrev

# Create new release
ghrec v1.0.0
```

**CI/CD Workflow:**
```bash
# Check workflow status
ghwl

# Run a workflow
ghwr ci.yml

# Watch the latest run
ghrnw
```

## Tips

1. **Tab Completion**: The plugin sets up tab completion for all `gh` commands automatically
2. **Conflict Avoidance**: Aliases are designed to avoid conflicts with common git aliases
3. **Workflow Integration**: Use composite aliases like `ghpcw` for faster common operations
4. **Status Checking**: Use `gh-status` for a quick overview of your repository's GitHub state
5. **Browser Integration**: Functions like `ghpb` and `ghib` quickly open GitHub pages in your browser

## Customization

You can override any alias by defining it after the plugin loads in your `.zshrc`:

```zsh
# Override the gh status alias
alias ghs='gh status --detailed'

# Add your own composite aliases
alias ghquick='gh repo create --public && gh repo clone'
```