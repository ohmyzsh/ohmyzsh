function tofu_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" != ~ ]] || return
  # to keep compatibility with opentofu, the data dir names .terraform in OpenTofu
  [[ -d .terraform && -r .terraform/environment ]] || return
  
  local workspace="$(< .terraform/environment)"
  echo "${ZSH_THEME_TOFU_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_TOFU_PROMPT_SUFFIX-]}"
}

function tofu_version_prompt_info() {
  local tofu_version
  tofu_version=$(tofu --version | head -n 1 | cut -d ' ' -f 2)
  echo "${ZSH_THEME_TOFU_VERSION_PROMPT_PREFIX-[}${tofu_version:gs/%/%%}${ZSH_THEME_TOFU_VERSION_PROMPT_SUFFIX-]}"
}


alias tt='tofu'
alias tta='tofu apply'
alias ttc='tofu console'
alias ttd='tofu destroy'
alias ttf='tofu fmt'
alias tti='tofu init'
alias tto='tofu output'
alias ttp='tofu plan'
alias ttv='tofu validate'
alias tts='tofu state'
alias ttsh='tofu show'
alias ttr='tofu refresh'
alias ttt='tofu test'
alias ttws='tofu workspace'