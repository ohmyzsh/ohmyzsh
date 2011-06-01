# Renders the name of the current branch.
function git_prompt_info() {
  local branch=$(git_current_branch)
  if [[ -n "$branch" ]]; then
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

# Gets the current branch.
function git_current_branch() {
  local ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n "$ref" ]]; then
    echo "${ref#refs/heads/}"
  fi
}

# Checks if the working tree is dirty.
function parse_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Checks if there are commits ahead from remote.
function git_prompt_ahead() {
  if $(echo "$(git log origin/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Formats the prompt string for current git commit short SHA.
function git_prompt_short_sha() {
  local sha=$(git rev-parse --short HEAD 2> /dev/null)
  if [[ -n "$sha" ]]; then
    echo "${ZSH_THEME_GIT_PROMPT_SHA_BEFORE}${sha}${ZSH_THEME_GIT_PROMPT_SHA_AFTER}"
  fi
}

# Formats the prompt string for current git commit long SHA.
function git_prompt_long_sha() {
  local sha=$(git rev-parse HEAD 2> /dev/null)
  if [[ -n "$sha" ]]; then
    echo "${ZSH_THEME_GIT_PROMPT_SHA_BEFORE}${sha}${ZSH_THEME_GIT_PROMPT_SHA_AFTER}"
  fi
}

# Gets the status of the working tree.
function git_prompt_status() {
  local indicators line untracked added modified renamed deleted
  while IFS=$'\n' read line; do
    if [[ "$line" =~ '^\?\? ' ]]; then
      [[ -n $untracked ]] && continue || untracked='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_UNTRACKED}${indicators}"
    fi
    if [[ "$line" =~ '^(((A|M|D|T) )|(AD|AM|AT|MM)) ' ]]; then
      [[ -n $added ]] && continue || added='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_ADDED}${indicators}"
    fi
    if [[ "$line" =~ '^(( (M|T))|(AM|AT|MM)) ' ]]; then
      [[ -n $modified ]] && continue || modified='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_MODIFIED}${indicators}"
    fi
    if [[ "$line" =~ '^R  ' ]]; then
      [[ -n $renamed ]] && continue || renamed='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_RENAMED}${indicators}"
    fi
    if [[ "$line" =~ '^( D|AD) ' ]]; then
      [[ -n $deleted ]] && continue || deleted='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_DELETED}${indicators}"
    fi
    if [[ "$line" =~ '^UU ' ]]; then
      [[ -n $unmerged ]] && continue || unmerged='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_UNMERGED}${indicators}"
    fi
  done < <(git status --porcelain 2> /dev/null)
  echo $indicators
}

alias g='git'
compdef g=git
alias gst='git status'
compdef _git gst=git-status
alias gl='git pull'
compdef _git gl=git-pull
alias gup='git fetch && git rebase'
compdef _git gup=git-fetch
alias gp='git push'
compdef _git gp=git-push
gdv() { git-diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gc='git commit -v'
compdef _git gc=git-commit
alias gca='git commit -v -a'
compdef _git gca=git-commit
alias gco='git checkout'
compdef _git gco=git-checkout
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias glg='git log --stat --max-count=5'
compdef _git glg=git-log
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git
alias ggpull='git pull origin $(git_current_branch)'
compdef ggpull=git
alias ggpush='git push origin $(git_current_branch)'
compdef ggpush=git
alias ggpnp='git pull origin $(git_current_branch) && git push origin $(git_current_branch)'
compdef ggpnp=git

