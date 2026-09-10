# set up the terragrunt completion (compatible for zsh)
autoload -Uz bashcompinit && bashcompinit
complete -C terragrunt terragrunt

# terragrunt workspace prompt function
function terragrunt_prompt_info() {
 # only show the workspace name if we're in an openterragrunt project
 # i.e. if a .terragrunt-cache directory exists within the hierarchy
 local dir="$PWD"
 while [[ ! -d "${dir}/.terragrunt-cache" ]]; do
  [[ "$dir" != / ]] || return 0 # stop at the root directory
  dir="${dir:h}"        # get the parent directory
 done

 # Run the command and capture the full line of output
 local full_output
 full_output="$(terragrunt run -- workspace show)"

 # Use Zsh parameter expansion to keep only the part after the last space.
 # The '##* ' pattern performs a "greedy" removal of everything up to
 # and including the final space in the string.
 local workspace="${full_output##* }"

 # make sure to escape % signs in the workspace name to prevent command injection
 echo "${ZSH_THEME_terragrunt_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_terragrunt_PROMPT_SUFFIX-]}"
}

# terragrunt version prompt function
function terragrunt_version_prompt_info() {
 # get the output of `terragrunt --version` in a single line, and get the second word after splitting by a space
 local terragrunt_version=${${(s: :)$(terragrunt --version)}[3]}
 # make sure to escape % signs in the version string to prevent command injection
 echo "${ZSH_THEME_terragrunt_VERSION_PROMPT_PREFIX-[}${terragrunt_version:gs/%/%%}${ZSH_THEME_terragrunt_VERSION_PROMPT_SUFFIX-]}"
}

alias tg='terragrunt'
alias tga='terragrunt -- run apply'
alias tgaa='terragrunt -- run apply -auto-approve'
alias tgc='terragrunt -- run console'
alias tgd='terragrunt -- run destroy'
alias tgd!='terragrunt -- run destroy -auto-approve'
alias tgf='terragrunt -- run fmt'
alias tgfr='terragrunt -- run fmt -recursive'
alias tgi='terragrunt -- run init'
alias tgo='terragrunt -- run output'
alias tgp='terragrunt -- run plan'
alias tgv='terragrunt -- run validate'
alias tgs='terragrunt -- run state'
alias tgsh='terragrunt -- run show'
alias tgr='terragrunt -- run refresh'
alias tgt='terragrunt -- run test'
alias tgws='terragrunt -- run workspace'
