function tf_prompt_info() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [ -d .terraform ]; then
      workspace=$(terraform workspace show 2> /dev/null) || return
      echo "$fg_bold[blue]terraform:($fg[red]${workspace}$fg_bold[blue]) "
    fi
}

alias twl='terraform workspace list'
alias twn='terraform workspace new'
alias tws='terraform workspace select'
alias twd='terraform workspace delete'

alias tinit='terraform init'
alias tval='terraform validate'
alias tplan='terraform plan'
alias tapp='terraform apply'
alias tdest='terraform destroy'

alias tfmt='terraform fmt'
alias tfu='terraform force-unlock'
alias tget='terraform get'
alias tshow='terraform show'
