_ant_does_target_list_need_generating () {
  [ ! -f .ant_targets ] && return 0;
  [ build.xml -nt .ant_targets ] && return 0;
  return 1;
}

_ant () {
  if [ -f build.xml ]; then
    if _ant_does_target_list_need_generating; then
    	ant -p | awk -F " " 'NR > 5 { print lastTarget }{lastTarget = $1}' > .ant_targets
    fi
    compadd -- `cat .ant_targets`
  fi
}

compdef _ant ant
