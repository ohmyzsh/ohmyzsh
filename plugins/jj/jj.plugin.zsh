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

jj util completion zsh >| "$ZSH_CACHE_DIR/completions/_jj" &|

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
alias jc='jj commit'
alias jcmsg='jj commit --message'
alias jd='jj diff'
alias jdmsg='jj desc --message'
alias jds='jj desc'
alias je='jj edit'
alias jgcl='jj git clone'
alias jgf='jj git fetch'
alias jgp='jj git push'
alias jl='jj log'
alias jla='jj log -r "all()"'
alias jn='jj new'
alias jrb='jj rebase'
alias jrs='jj restore'
alias jrt='cd "$(jj root || echo .)"'
alias jsp='jj split'
alias jsq='jj squash'
