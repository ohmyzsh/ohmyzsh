_phing_does_target_list_need_generating () {
  if [ ! -f .phing_targets ]; then return 0;
  else
    accurate=$(stat -f%m .phing_targets)
    changed=$(stat -f%m build.xml)
    return $(expr $accurate '>=' $changed)
  fi
}

_phing () {
  if [ -f build.xml ]; then
    if _phing_does_target_list_need_generating; then
      phing -l |grep -v ":" |grep -v "^$"|grep -v "\-" > .phing_targets
    fi
    compadd `cat .phing_targets`
  fi
}

compdef _phing phing
