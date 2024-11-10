# set up the tofu completion (compatible for zsh)
autoload -Uz bashcompinit && bashcompinit
complete -C tofu tofu

# tofu workspace prompt function
function tofu_prompt_info() {
  # only show the workspace name if we're in an opentofu project
  # i.e. if a .terraform directory exists within the hierarchy
  local dir="$PWD"
  while [[ ! -d "${dir}/.terraform" ]]; do
    [[ "$dir" != / ]] || return 0 # stop at the root directory
    dir="${dir:h}"                # get the parent directory
  done

  # workspace might be different than the .terraform/environment file
  # for example, if set with the TF_WORKSPACE environment variable
  local workspace="$(tofu workspace show)"
  # make sure to escape % signs in the workspace name to prevent command injection
  echo "${ZSH_THEME_TOFU_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_TOFU_PROMPT_SUFFIX-]}"
}

# tofu version prompt function
function tofu_version_prompt_info() {
  # get the output of `tofu --version` in a single line, and get the second word after splitting by a space
  local tofu_version=${${(s: :)$(tofu --version)}[2]}
  # make sure to escape % signs in the version string to prevent command injection
  echo "${ZSH_THEME_TOFU_VERSION_PROMPT_PREFIX-[}${tofu_version:gs/%/%%}${ZSH_THEME_TOFU_VERSION_PROMPT_SUFFIX-]}"
}

alias tt='tofu'
alias tta='tofu apply'
alias ttaa='tofu apply -auto-approve'
alias ttc='tofu console'
alias ttd='tofu destroy'
alias ttd!='tofu destroy -auto-approve'
alias ttf='tofu fmt'
alias ttfr='tofu fmt -recursive'
alias tti='tofu init'
alias tto='tofu output'
alias ttp='tofu plan'
alias ttv='tofu validate'
alias tts='tofu state'
alias ttsh='tofu show'
alias ttr='tofu refresh'
alias ttt='tofu test'
alias ttws='tofu workspace'
