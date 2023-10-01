function tf_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" != ~ ]] || return
  # check if in terraform dir and file exists
  [[ -d .terraform && -r .terraform/environment ]] || return

  local workspace="$(< .terraform/environment)"
  echo "${ZSH_THEME_TF_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_TF_PROMPT_SUFFIX-]}"
}

function tf_version_prompt_info() {
    local terraform_version
    terraform_version=$(terraform --version | head -n 1 | cut -d ' ' -f 2)
    echo "${ZSH_THEME_TF_VERSION_PROMPT_PREFIX-[}${terraform_version:gs/%/%%}${ZSH_THEME_TF_VERSION_PROMPT_SUFFIX-]}"
}


alias tf='terraform'
alias tfa='terraform apply'
alias tfc='terraform console'
alias tfd='terraform destroy'
alias tff='terraform fmt'
alias tfi='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfv='terraform validate'
alias tfs='terraform state'
alias tfsh='terraform show'
