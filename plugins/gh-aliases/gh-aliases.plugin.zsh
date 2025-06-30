# gh plugin for oh-my-zsh
# Provides aliases for GitHub CLI (gh) commands
# https://cli.github.com

# Return if gh is not installed
if (( ! $+commands[gh] )); then
  return
fi

# ============================================
# Completions Setup
# ============================================

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `gh`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_gh" ]]; then
  typeset -g -A _comps
  autoload -Uz _gh
  _comps[gh]=_gh
fi

# Generate completion file in background
gh completion --shell zsh >| "$ZSH_CACHE_DIR/completions/_gh" &|

# ============================================
# Authentication Commands (gh auth)
# ============================================
alias ghal='gh auth login'
alias ghas='gh auth status'
alias ghaw='gh auth switch'
alias ghao='gh auth logout'
alias ghar='gh auth refresh'
alias ghat='gh auth token'

# ============================================
# Repository Commands (gh repo)
# ============================================
alias ghrc='gh repo clone'
alias ghrv='gh repo view'
alias ghrl='gh repo list'
alias ghrf='gh repo fork'
alias ghrs='gh repo sync'
alias ghrn='gh repo create'
alias ghrd='gh repo delete'
alias ghre='gh repo edit'
alias ghra='gh repo archive'
alias ghru='gh repo unarchive'
alias ghrr='gh repo rename'

# ============================================
# Issue Commands (gh issue)
# ============================================
alias ghiv='gh issue view'
alias ghic='gh issue create'
alias ghil='gh issue list'
alias ghie='gh issue edit'
alias ghix='gh issue close'
alias ghir='gh issue reopen'
alias ghid='gh issue delete'
alias ghia='gh issue assign'
alias ghit='gh issue transfer'
alias ghip='gh issue pin'
alias ghiu='gh issue unpin'
alias ghico='gh issue comment'
alias ghis='gh issue status'

# ============================================
# Pull Request Commands (gh pr)
# ============================================
alias ghpc='gh pr create'
alias ghpv='gh pr view'
alias ghpl='gh pr list'
alias ghpm='gh pr merge'
alias ghpe='gh pr edit'
alias ghpo='gh pr checkout'
alias ghpx='gh pr close'
alias ghpr='gh pr reopen'
alias ghpd='gh pr diff'
alias ghpw='gh pr review'
alias ghps='gh pr status'
alias ghpa='gh pr assign'
alias ghpt='gh pr ready'
alias ghpco='gh pr comment'
alias ghpch='gh pr checks'

# ============================================
# Workflow Commands (gh workflow)
# ============================================
alias ghwl='gh workflow list'
alias ghwr='gh workflow run'
alias ghwv='gh workflow view'
alias ghwe='gh workflow enable'
alias ghwd='gh workflow disable'

# ============================================
# Run Commands (gh run)
# ============================================
# Using 'rn' prefix to avoid conflicts with repo commands
alias ghrnl='gh run list'
alias ghrnv='gh run view'
alias ghrnc='gh run cancel'
alias ghrnr='gh run rerun'
alias ghrnd='gh run download'
alias ghrnw='gh run watch'

# ============================================
# Release Commands (gh release)
# ============================================
# Using 're' prefix to distinguish from repo/run commands
alias ghrec='gh release create'
alias ghrel='gh release list'
alias ghrev='gh release view'
alias ghred='gh release delete'
alias ghreu='gh release upload'
alias ghrdo='gh release download'
alias ghree='gh release edit'

# ============================================
# Gist Commands (gh gist)
# ============================================
alias ghgc='gh gist create'
alias ghgv='gh gist view'
alias ghgl='gh gist list'
alias ghge='gh gist edit'
alias ghgd='gh gist delete'
alias ghgn='gh gist clone'

# ============================================
# Project Commands (gh project)
# ============================================
# Using 'pj' to distinguish from pull request commands
alias ghpjc='gh project create'
alias ghpjl='gh project list'
alias ghpjv='gh project view'
alias ghpje='gh project edit'
alias ghpjx='gh project close'
alias ghpjd='gh project delete'

# ============================================
# Search Commands (gh search)
# ============================================
alias ghsr='gh search repos'
alias ghsc='gh search code'
alias ghsi='gh search issues'
alias ghsp='gh search prs'
alias ghsu='gh search users'
alias ghsm='gh search commits'

# ============================================
# Secret Commands (gh secret)
# ============================================
# Using 'se' prefix to avoid conflicts with search commands
alias ghsec='gh secret set'
alias ghsel='gh secret list'
alias ghsed='gh secret delete'

# ============================================
# SSH Key Commands (gh ssh-key)
# ============================================
alias ghka='gh ssh-key add'
alias ghkl='gh ssh-key list'
alias ghkd='gh ssh-key delete'

# ============================================
# Label Commands (gh label)
# ============================================
alias ghll='gh label list'
alias ghlc='gh label create'
alias ghle='gh label edit'
alias ghld='gh label delete'

# ============================================
# Alias Commands (gh alias)
# ============================================
# Using 'al' prefix to distinguish from auth commands
alias ghalc='gh alias set'
alias ghall='gh alias list'
alias ghald='gh alias delete'

# ============================================
# Config Commands (gh config)
# ============================================
alias ghcg='gh config get'
alias ghcs='gh config set'
alias ghcl='gh config list'

# ============================================
# Extension Commands (gh extension)
# ============================================
alias ghei='gh extension install'
alias ghel='gh extension list'
alias gher='gh extension remove'
alias gheu='gh extension upgrade'
alias ghec='gh extension create'

# ============================================
# Codespace Commands (gh codespace)
# ============================================
# Using 'cs' prefix
alias ghcsc='gh codespace create'
alias ghcsl='gh codespace list'
alias ghcss='gh codespace ssh'
alias ghcsd='gh codespace delete'
alias ghcsv='gh codespace view'
alias ghcse='gh codespace edit'
alias ghcsr='gh codespace rebuild'
alias ghcso='gh codespace code'

# ============================================
# Cache Commands (gh cache)
# ============================================
# Using 'ch' prefix
alias ghchl='gh cache list'
alias ghchd='gh cache delete'

# ============================================
# GPG Key Commands (gh gpg-key)
# ============================================
# Using 'gk' prefix
alias ghgka='gh gpg-key add'
alias ghgkl='gh gpg-key list'
alias ghgkd='gh gpg-key delete'

# ============================================
# Other Common Commands
# ============================================
alias ghs='gh status'
alias ghb='gh browse'
alias gha='gh api'
alias ghh='gh help'
alias ghv='gh version'

# ============================================
# Composite/Workflow Aliases
# ============================================
# Quick PR workflow
alias ghpcw='gh pr create -w'  # Create PR in web browser
alias ghpmd='gh pr merge -d'   # Merge and delete branch
alias ghpms='gh pr merge -s'   # Squash and merge
alias ghpmr='gh pr merge -r'   # Rebase and merge

# Quick issue workflow
alias ghicw='gh issue create -w'  # Create issue in web browser
alias ghilm='gh issue list -L 10' # List last 10 issues
alias ghilmy='gh issue list -a @me' # List my issues

# Quick repo workflow
alias ghrcr='gh repo clone --recurse-submodules' # Clone with submodules
alias ghrcp='gh repo create --private' # Create private repo
alias ghrcpu='gh repo create --public' # Create public repo

# ============================================
# Helper Functions
# ============================================

# Clone a repo and cd into it
function ghrc-cd() {
    if [[ -z "$1" ]]; then
        echo "Usage: ghrc-cd <repo>"
        return 1
    fi
    gh repo clone "$1" && cd "$(basename "$1" .git)"
}

# Create a new repo and clone it
function ghrn-cd() {
    if [[ -z "$1" ]]; then
        echo "Usage: ghrn-cd <repo-name>"
        return 1
    fi
    gh repo create "$1" && gh repo clone "$1" && cd "$1"
}

# View PR in browser
function ghpb() {
    if [[ -z "$1" ]]; then
        gh pr view --web
    else
        gh pr view "$1" --web
    fi
}

# View issue in browser
function ghib() {
    if [[ -z "$1" ]]; then
        gh issue view --web
    else
        gh issue view "$1" --web
    fi
}

# Quick status check
function gh-status() {
    echo "=== GitHub Status ==="
    gh status
    echo -e "\n=== Repository ==="
    gh repo view 2>/dev/null || echo "Not in a GitHub repository"
    echo -e "\n=== Pull Requests ==="
    gh pr status 2>/dev/null || echo "No PR information available"
}

# Create PR from current branch
function ghpc-current() {
    local branch=$(git branch --show-current)
    if [[ "$branch" == "main" ]] || [[ "$branch" == "master" ]]; then
        echo "Cannot create PR from default branch"
        return 1
    fi
    gh pr create
}

# ============================================
# Plugin Info Functions
# ============================================

# Function to list all gh aliases
function gh-aliases() {
    alias | grep '^gh' | sed 's/=/ = /' | sort
}

# Function to search gh aliases
function gh-alias-search() {
    if [[ -z "$1" ]]; then
        echo "Usage: gh-alias-search <search-term>"
        return 1
    fi
    alias | grep '^gh' | grep -i "$1" | sed 's/=/ = /'
}

# Function to show gh cheatsheet
function gh-cheat() {
    cat <<'EOF'
GitHub CLI (gh) Aliases Cheatsheet
==================================

Authentication:
  ghal  = gh auth login          ghas  = gh auth status
  ghaw  = gh auth switch         ghao  = gh auth logout

Repository:
  ghrc  = gh repo clone          ghrv  = gh repo view
  ghrl  = gh repo list           ghrf  = gh repo fork
  ghrn  = gh repo create         ghrs  = gh repo sync

Issues:
  ghic  = gh issue create        ghiv  = gh issue view
  ghil  = gh issue list          ghie  = gh issue edit
  ghix  = gh issue close         ghir  = gh issue reopen

Pull Requests:
  ghpc  = gh pr create           ghpv  = gh pr view
  ghpl  = gh pr list             ghpm  = gh pr merge
  ghpo  = gh pr checkout         ghpd  = gh pr diff

Workflows:
  ghwl  = gh workflow list       ghwr  = gh workflow run
  ghrnl = gh run list            ghrnv = gh run view

Other:
  ghs   = gh status              ghb   = gh browse
  gha   = gh api                 ghh   = gh help

Helper Functions:
  ghrc-cd <repo>    - Clone and cd into repo
  gh-status         - Show comprehensive status
  gh-aliases        - List all gh aliases
  gh-cheat          - Show this cheatsheet
EOF
}

# ============================================
# README Generation Function
# ============================================

function _gh_plugin_readme() {
    cat <<'EOF'
# gh plugin

This plugin provides aliases and functions for the [GitHub CLI](https://cli.github.com/).

To use it, add `gh` to the plugins array in your zshrc file:

```zsh
plugins=(... gh)
