# set up the terragrunt completion (compatible for zsh)
autoload -Uz bashcompinit && bashcompinit
complete -C terragrunt terragrunt

# terragrunt version prompt function
function terragrunt_version_prompt_info() {
  # get the output of `terragrunt --version` in a single line, and get the third word after splitting by a space
  local terragrunt_version=${${(s: :)$(terragrunt --version)}[3]}
  # make sure to escape % signs in the version string to prevent command injection
  echo "${ZSH_THEME_TERRAGRUNT_VERSION_PROMPT_PREFIX-[}${terragrunt_version:gs/%/%%}${ZSH_THEME_TERRAGRUNT_VERSION_PROMPT_SUFFIX-]}"
}

alias tg='terragrunt'
alias tga='terragrunt run -- apply'
alias tgaa='terragrunt run -- apply -auto-approve'
alias tgc='terragrunt run -- console'
alias tgd='terragrunt run -- destroy'
alias tgd!='terragrunt run -- destroy -auto-approve'
alias tgi='terragrunt run -- init'
alias tgo='terragrunt run -- output'
alias tgp='terragrunt run -- plan'
alias tgv='terragrunt run -- validate'
alias tgs='terragrunt run -- state'
alias tgsh='terragrunt run -- show'
alias tgr='terragrunt run -- refresh'
alias tgt='terragrunt run -- test'
alias tgws='terragrunt run -- workspace'
