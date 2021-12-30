function tf_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" != ~ ]] || return
  # check if in terraform dir and file exists
  [[ -d .terraform && -r .terraform/environment ]] || return

  local workspace="$(< .terraform/environment)"
  echo "${ZSH_THEME_TF_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_TF_PROMPT_SUFFIX-]}"
}

alias tf='terraform'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tff='terraform fmt'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfv='terraform validate'
