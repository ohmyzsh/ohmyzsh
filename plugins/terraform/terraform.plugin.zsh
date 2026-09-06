function tf_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" != ~ ]] || return
  # check if in terraform dir and file exists
  [[ -d "${TF_DATA_DIR:-.terraform}" && -r "${TF_DATA_DIR:-.terraform}/environment" ]] || return

  local workspace="$(<"${TF_DATA_DIR:-.terraform}/environment")"
  echo "${ZSH_THEME_TF_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_TF_PROMPT_SUFFIX-]}"
}

function tf_version_prompt_info() {
  local terraform_version
  terraform_version=$(terraform --version | head -n 1 | cut -d ' ' -f 2)
  echo "${ZSH_THEME_TF_VERSION_PROMPT_PREFIX-[}${terraform_version:gs/%/%%}${ZSH_THEME_TF_VERSION_PROMPT_SUFFIX-]}"
}

alias tf='terraform'
alias tfa='terraform apply'
alias tfa!='terraform apply -auto-approve'
alias tfap='terraform apply -parallelism=1'
alias tfapp='terraform apply tfplan'
alias tfc='terraform console'
alias tfd='terraform destroy'
alias tfd!='terraform destroy -auto-approve'
alias tfdp='terraform destroy -parallelism=1'
alias tff='terraform fmt'
alias tffr='terraform fmt -recursive'
alias tffck='terraform fmt -check -recursive'
alias tfg='terraform graph'
alias tfi='terraform init'
alias tfib='terraform init -backend=false'
alias tfir='terraform init -reconfigure'
alias tfiu='terraform init -upgrade'
alias tfiur='terraform init -upgrade -reconfigure'
alias tfip='terraform import'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfpo='terraform plan -out tfplan'
alias tfpr='terraform providers'
alias tfr='terraform refresh'
alias tfs='terraform state'
alias tfsr='terraform state rm'
alias tft='terraform test'
alias tfsh='terraform show'
alias tfv='terraform validate'
alias tfw='terraform workspace'
alias tfwl='terraform workspace list'
alias tfwn='terraform workspace new'
alias tfws='terraform workspace select'
