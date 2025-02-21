function vagrant_prompt_info() {
  if [[ ! -d .vagrant || ! -f Vagrantfile ]]; then
    return
  fi

  local vm_states vm_state
  vm_states=(${(f)"$(vagrant status 2> /dev/null | sed -nE 's/^[^ ]* *([[:alnum:] ]*) \([[:alnum:]_]+\)$/\1/p')"})
  printf '%s' $ZSH_THEME_VAGRANT_PROMPT_PREFIX
  for vm_state in $vm_states; do
    case "$vm_state" in
      running) printf '%s' $ZSH_THEME_VAGRANT_PROMPT_RUNNING ;;
      "not running"|poweroff) printf '%s' $ZSH_THEME_VAGRANT_PROMPT_POWEROFF ;;
      paused|saved|suspended) printf '%s' $ZSH_THEME_VAGRANT_PROMPT_SUSPENDED ;;
      "not created") printf '%s' $ZSH_THEME_VAGRANT_PROMPT_NOT_CREATED ;;
    esac
  done
  printf '%s' $ZSH_THEME_VAGRANT_PROMPT_SUFFIX
}
