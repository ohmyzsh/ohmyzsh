_phing_does_target_list_need_generating () {
  [ ! -f .phing_targets ] && return 0;
  [ .phing_targets -nt build.xml ] && return 0;
  return 1;
}

_phing () {
  if [ -f build.xml ]; then
    if _phing_does_target_list_need_generating; then
      phing -l |grep -v ":$" |grep -v "^-*$" > .phing_targets
    fi
    compadd `cat .phing_targets`
  fi
}

compdef _phing phing
