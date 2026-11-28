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
alias tfi='terraform init'
alias tfir='terraform init -reconfigure'
alias tfiu='terraform init -upgrade'
alias tfiur='terraform init -upgrade -reconfigure'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfpo='terraform plan -out tfplan'
alias tfv='terraform validate'
alias tfs='terraform state'
alias tft='terraform test'
alias tfsh='terraform show'
alias tfw='terraform workspace'
alias tfwl='terraform workspace list'
alias tfws='terraform workspace select'

if (( $+commands[terraform-docs] )); then
  # If the completion file doesn't exist yet, compinit hasn't registered it.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_terraform-docs" ]]; then
    typeset -g -A _comps
    autoload -Uz _terraform-docs
    _comps[terraform-docs]=_terraform-docs
  fi

  zmodload -F zsh/files b:zf_mv
  () {
    local completions
    completions=$(command terraform-docs completion zsh) || return
    [[ -n "$completions" ]] || return

    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._terraform-docs"
    zf_mv -f -- =(print -r -- "$completions") \
      "$ZSH_CACHE_DIR/completions/_terraform-docs"
  } &|
fi
