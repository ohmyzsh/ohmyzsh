function tf_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" != ~ ]] || return
  # check if in terraform dir and file exists
  [[ -d .terraform && -r .terraform/environment ]] || return

  local workspace="$(< .terraform/environment)"
  echo "${ZSH_THEME_TF_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_TF_PROMPT_SUFFIX-]}"
}

alias tf='terraform'
alias tfi='terraform init'
alias tff='terraform fmt'
alias tffr='terraform fmt -recursive'
alias tfv='terraform validate'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfa!='terraform apply -auto-approve'
alias tfd='terraform destroy'
alias tfd!='terraform destroy -auto-approve'
alias tfo='terraform output'
alias tfc='terraform console'
alias tfall='terraform init && terraform fmt -recursive && terraform validate && terraform plan && terraform apply'
alias tfall!='terraform init && terraform fmt -recursive && terraform validate && terraform plan && terraform apply -auto-approve'
alias tfw='terraform workspace'
alias tfws='terraform workspace select'
alias tfwn='terraform workspace new'
alias tfwd='terraform workspace delete'
alias tfwls='terraform workspace list'
alias tfr='terraform refresh'
