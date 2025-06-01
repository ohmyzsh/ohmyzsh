# if jj is not found, don't do the rest of the script
if (( ! $+commands[jj] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `jj`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_jj" ]]; then
  typeset -g -A _comps
  autoload -Uz _jj
  _comps[jj]=_jj
fi

COMPLETE=zsh jj >| "$ZSH_CACHE_DIR/completions/_jj" &|

function __jj_prompt_jj() {
  local -a flags
  flags=("--no-pager")
  if zstyle -t ':omz:plugins:jj' ignore-working-copy; then
    flags+=("--ignore-working-copy")
  fi
  command jj $flags "$@"
}

# convenience functions for themes
function jj_prompt_template_raw() {
  __jj_prompt_jj log --no-graph -r @ -T "$@" 2> /dev/null
}

function jj_prompt_template() {
  local out
  out=$(jj_prompt_template_raw "$@") || return 1
  echo "${out:gs/%/%%}"
}

# Aliases (sorted alphabetically)
alias jjc='jj commit'
alias jjcmsg='jj commit --message'
alias jjd='jj diff'
alias jjdmsg='jj desc --message'
alias jjds='jj desc'
alias jje='jj edit'
alias jjgcl='jj git clone'
alias jjgf='jj git fetch'
alias jjgfa='jj git fetch --all-remotes'
alias jjgp='jj git push'
alias jjl='jj log'
alias jjla='jj log -r "all()"'
alias jjn='jj new'
alias jjrb='jj rebase'
alias jjrs='jj restore'
alias jjrt='cd "$(jj root || echo .)"'
alias jjsp='jj split'
alias jjsq='jj squash'
