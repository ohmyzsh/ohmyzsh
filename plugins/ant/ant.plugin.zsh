stat -f%m . > /dev/null 2>&1
if [ "$?" = 0 ]; then
	stat_cmd=(stat -f%m)
else
	stat_cmd=(stat -L --format=%y)
fi

_ant_does_target_list_need_generating () {
  if [ ! -f .ant_targets ]; then return 0;
  else
    accurate=$($stat_cmd -f%m .ant_targets)
    changed=$($stat_cmd -f%m build.xml)
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
