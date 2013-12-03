function vagrant_prompt_status {
  if [ ! -f Vagrantfile ]; then
    return
  fi

  VAGRANT_BOX=$(grep 'config.vm.box =' Vagrantfile | awk '{print $3}')
  VARGANT_STATE=$(vagrant status 2>/dev/null | grep default | awk {'print $2'})
  case "$VARGANT_STATE" in
      "running")                  VARGANT_STATUS=$ZSH_THEME_VAGRANT_PROMPT_ON;;
      stopped|poweroff|saved)     VARGANT_STATUS=$ZSH_THEME_VAGRANT_PROMPT_OFF;;
      *)                          return
  esac

  echo "default($VAGRANT_BOX): $VARGANT_STATE $VARGANT_STATUS"
}
