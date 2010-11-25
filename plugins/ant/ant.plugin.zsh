_ant_does_target_list_need_generating () {
  if [ ! -f .ant_targets ]; then return 0;
  else
    accurate=$(stat -f%m .ant_targets)
    changed=$(stat -f%m build.xml)
    return $(expr $accurate '>=' $changed)
  fi
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
