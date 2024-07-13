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
  local vm_states vm_state
  if [[ -d .vagrant && -f Vagrantfile ]]; then
    vm_states=(${(f)"$(vagrant status 2> /dev/null | sed -nE 's/^.*(saved|poweroff|running|not created) \([[:alnum:]_]+\)$/\1/p')"})
    printf '%s' $ZSH_THEME_VAGRANT_PROMPT_PREFIX
    for vm_state in $vm_states; do
      case "$vm_state" in
        saved) printf '%s' $ZSH_THEME_VAGRANT_PROMPT_SUSPENDED ;;
        running) printf '%s' $ZSH_THEME_VAGRANT_PROMPT_RUNNING ;;
        poweroff) printf '%s' $ZSH_THEME_VAGRANT_PROMPT_POWEROFF ;;
        "not created") printf '%s' $ZSH_THEME_VAGRANT_PROMPT_NOT_CREATED ;;
      esac
    done
    printf '%s' $ZSH_THEME_VAGRANT_PROMPT_SUFFIX
  fi
}
