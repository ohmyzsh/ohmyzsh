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

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_jj"
  zf_mv -f -- =( COMPLETE=zsh jj ) "$TMPPREFIX"
} &|

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
alias jja='jj abandon'
alias jjb='jj bookmark'
alias jjba='jj bookmark advance'
alias jjbc='jj bookmark create'
alias jjbd='jj bookmark delete'
alias jjbf='jj bookmark forget'
alias jjbl='jj bookmark list'
alias jjblt='jj bookmark list --tracked'
alias jjbm='jj bookmark move'
alias jjbr='jj bookmark rename'
alias jjbs='jj bookmark set'
alias jjbt='jj bookmark track'
alias jjbu='jj bookmark untrack'
alias jjc='jj commit'
alias jjcfg='jj config'
alias jjcfgl='jj config list'
alias jjcmsg='jj commit --message'
alias jjd='jj diff'
alias jjdmsg='jj desc --message'
alias jjds='jj desc'
alias jjdst='jj diff --stat'
alias jje='jj edit'
alias jjev='jj evolog'
alias jjf='jj file'
alias jjfl='jj file list'
alias jjg='jj git'
alias jjgcl='jj git clone'
alias jjgf='jj git fetch'
alias jjgfa='jj git fetch --all-remotes'
alias jjgi='jj git init'
alias jjgp='jj git push'
alias jjgpa='jj git push --all'
alias jjgpd='jj git push --deleted'
alias jjgpt='jj git push --tracked'
alias jjgrl='jj git remote list'
alias jjl='jj log'
alias jjla='jj log -r "all()"'
alias jjn='jj new'
alias jjnt='jj new "trunk()"'
alias jjop='jj op'
alias jjopl='jj op log'
alias jjor='jj op restore'
alias jjrb='jj rebase'
alias jjrbm='jj rebase -d "trunk()"'
alias jjrs='jj restore'
alias jjrt='cd "$(jj root || echo .)"'
alias jjs='jj show'
alias jjsp='jj split'
alias jjsq='jj squash'
alias jjst='jj status'
alias jju='jj undo'
alias jjw='jj workspace'
alias jjwa='jj workspace add'
alias jjwf='jj workspace forget'
alias jjwl='jj workspace list'
