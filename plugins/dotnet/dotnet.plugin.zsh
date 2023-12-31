# This scripts is copied from (MIT License):
# https://raw.githubusercontent.com/dotnet/sdk/main/scripts/register-completions.zsh

#compdef dotnet
_dotnet_completion() {
  local -a completions=("${(@f)$(dotnet complete "${words}")}")
  compadd -a completions
  _files
}

compdef _dotnet_completion dotnet

# Aliases bellow are here for backwards compatibility
# added by Shaun Tabone (https://github.com/xontab) 

alias dn='dotnet new'
alias dr='dotnet run'
alias dt='dotnet test'
alias dw='dotnet watch'
alias dwr='dotnet watch run'
alias dwt='dotnet watch test'
alias ds='dotnet sln'
alias da='dotnet add'
alias dp='dotnet pack'
alias dng='dotnet nuget'
alias db='dotnet build'
