# if jj is not found, don't do the rest of the script
if (( ! $+commands[jj] )); then
  return
fi

source <(jj util completion zsh)
compdef _jj jj

function __jj_prompt_jj() {
  local flags=("--no-pager")
  if (( ${ZSH_THEME_JJ_IGNORE_WORKING_COPY:-0} )); then
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
alias j='jj'
alias jb='jj branch'
alias jbc='jj branch create'
alias jbd='jj branch d'
alias jbl='jj branch list'
alias jbr='jj branch rename'
alias jbs='jj branch set'
alias jbt='jj branch track'
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
alias jn='jj new'
alias jrb='jj rebase'
alias jrs='jj restore'
alias jrt='cd "$(jj root || echo .)"'
alias js='jj squash'
alias jsp='jj split'
alias jsps='jj split --siblings'
alias jst='jj st'
alias jsto='jj squash --into'
