_phing_does_target_list_need_generating () {
  [ ! -f .phing_targets ] && return 0;
  [ build.xml -nt .phing_targets ] && return 0;
  return 1;
}

_phing () {
  if [ -f build.xml ]; then
    if _phing_does_target_list_need_generating; then
      phing -l|grep -v "\[property\]"|grep -v "Buildfile"|sed 1d|grep -v ":$" |grep -v "^\-*$"|awk '{print $1}' > .phing_targets
    fi
    compadd `cat .phing_targets`
  fi
}

compdef _phing phing
