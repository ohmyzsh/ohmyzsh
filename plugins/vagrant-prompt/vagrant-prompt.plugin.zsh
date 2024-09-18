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
