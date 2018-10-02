# vim:ft=zsh ts=2 sw=2 sts=2
#
# To display Vagrant infos on your prompt add the vagrant_prompt_info to the
# $PROMPT variable in your theme. Example:
#
# PROMPT='%{$fg[$NCOLOR]%}%B%n%b%{$reset_color%}:%{$fg[blue]%}%B%c/%b%{$reset_color%} $(vagrant_prompt_info)$(svn_prompt_info)$(git_prompt_info)%(!.#.$) '
#
# `vagrant_prompt_info` makes use of some custom variables. This is an example
# definition:
#
# ZSH_THEME_VAGRANT_PROMPT_PREFIX="%{$fg_bold[blue]%}["
# ZSH_THEME_VAGRANT_PROMPT_SUFFIX="%{$fg_bold[blue]%}]%{$reset_color%} "
# ZSH_THEME_VAGRANT_PROMPT_RUNNING="%{$fg_no_bold[green]%}●"
# ZSH_THEME_VAGRANT_PROMPT_POWEROFF="%{$fg_no_bold[red]%}●"
# ZSH_THEME_VAGRANT_PROMPT_SUSPENDED="%{$fg_no_bold[yellow]%}●"
# ZSH_THEME_VAGRANT_PROMPT_NOT_CREATED="%{$fg_no_bold[white]%}○"

function vagrant_prompt_info() {
  test -d .vagrant && test -f Vagrantfile
  if [[ "$?" == "0" ]]; then
    statuses=$(vagrant status 2> /dev/null | grep -P "\w+\s+[\w\s]+\s\(\w+\)")
    statuses=("${(f)statuses}")
    printf '%s' $ZSH_THEME_VAGRANT_PROMPT_PREFIX
    for vm_details in $statuses; do
      vm_state=$(echo $vm_details | grep -o -E "saved|poweroff|not created|running")
      if [[ "$vm_state" == "running" ]]; then
        printf '%s' $ZSH_THEME_VAGRANT_PROMPT_RUNNING
      elif [[ "$vm_state" == "saved" ]]; then
        printf '%s' $ZSH_THEME_VAGRANT_PROMPT_SUSPENDED
      elif [[ "$vm_state" == "not created" ]]; then
        printf '%s' $ZSH_THEME_VAGRANT_PROMPT_NOT_CREATED
      elif [[ "$vm_state" == "poweroff" ]]; then
        printf '%s' $ZSH_THEME_VAGRANT_PROMPT_POWEROFF
      fi
    done
    printf '%s' $ZSH_THEME_VAGRANT_PROMPT_SUFFIX
  fi
}
