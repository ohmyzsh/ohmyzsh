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
