# Oh My Zsh plugin for GitLab CLI (glab)

# --- Environment setup ---
# Load GITLAB_HOST and GITLAB_TOKEN from ~/.netrc if not already set
if [ -z "$GITLAB_HOST" ] || [ -z "$GITLAB_TOKEN" ]; then
  if [ -f "$HOME/.netrc" ]; then
    __glab_machine=$(awk '/^machine/{print $2; exit}' "$HOME/.netrc")
    __glab_pass=$(awk -v host="$__glab_machine" '$2==host{getline; getline; if($1=="password") print $2}' "$HOME/.netrc")

    if [ -n "$__glab_machine" ] && [ -n "$__glab_pass" ]; then
      export GITLAB_HOST="$__glab_machine"
      export GITLAB_TOKEN="$__glab_pass"
    fi
  fi
fi
unset __glab_machine __glab_pass

# --- Completions ---
if command -v glab >/dev/null 2>&1; then
  eval "$(glab completion -s zsh 2>/dev/null || true)"
fi

# --- Aliases ---
alias gl='glab'
alias glmr='glab mr'
alias glissue='glab issue'
alias glrepo='glab repo'
alias glci='glab ci'
alias glprj='glab project'
alias glrelease='glab release'

# --- Merge Request Helper Functions ---

# Open a merge request in browser
glmr-open() {
  glab mr view --web "$@"
}

# Checkout a merge request branch locally
glmr-checkout() {
  glab mr checkout "$1"
}

# Merge a merge request
glmr-merge() {
  glab mr merge "$1" --remove-source-branch
}

# List merge requests assigned to me
glmr-list() {
  glab mr list --assignee "@me" "$@"
}

# --- Issue Helper Functions ---

# Create a new issue with optional title
glissue-new() {
  if [ $# -eq 0 ]; then
    glab issue create
  else
    glab issue create -t "$*"
  fi
}

# Close an issue
glissue-close() {
  glab issue close "$1"
}

# List open issues assigned to me
glissue-list() {
  glab issue list --assignee "@me" --state opened "$@"
}

# --- CI/CD Helper Functions ---

# Show current CI pipeline status in browser
glci-status() {
  glab ci view --web "$@"
}

# Retry a pipeline
glci-retry() {
  glab ci retry "$1"
}

# View the latest pipeline
glci-latest() {
  latest_id=$(glab ci list --limit 1 --json id -q '.[0].id')
  glab ci view "$latest_id"
}

# --- Repository Helper Functions ---

# Clone a project
glrepo-clone() {
  glab repo clone "$1"
}

# List all projects I’m a member of
glrepo-list() {
  glab repo list --membership "$@"
}

# Open a repository in browser
glrepo-open() {
  glab repo view --web "$@"
}

# List starred projects
glrepo-starred() {
  glab repo list --starred "$@"
}

# --- Release Helper Functions ---

# Create a release: glrelease-create "Title" "Tag"
glrelease-create() {
  glab release create -t "$1" "$2"
}

# --- Search Helper Function ---

# Search merge requests and issues
glsearch() {
  echo "Merge Requests:"
  glab mr list --search "$1"
  echo ""
  echo "Issues:"
  glab issue list --search "$1"
}

# --- Optional Auto-completion for Custom Commands ---
# Example: completion for glmr-open
_glmr_open_completion() {
  _arguments "1:merge-request ID:_glab_mr"
}
compdef _glmr_open_completion glmr-open
