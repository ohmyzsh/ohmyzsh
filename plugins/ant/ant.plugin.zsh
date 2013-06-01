_ant_does_target_list_need_generating () {
  [ ! -f .ant_targets ] && return 0;
  [ .ant_targets -nt build.xml ] && return 0;
  return 1;
}

_ant () {
  if [ -f build.xml ]; then
    if _ant_does_target_list_need_generating; then
     sed -n '/<target/s/<target.*name="\([^"]*\).*$/\1/p' build.xml > .ant_targets
    fi
    compadd `cat .ant_targets`
  fi
}

compdef _ant ant
