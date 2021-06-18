function tf_prompt_info() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [[ -d .terraform && -r .terraform/environment  ]]; then
      workspace=$(cat .terraform/environment) || return
      echo "[${workspace}]"
    fi
}

alias tf='terraform'
alias tfi='terraform init'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
