if stat -f%m . &> /dev/null; then
  stat_cmd=(stat -f%m)
else
  stat_cmd=(stat -L --format=%Y)
fi

function _ant_does_target_list_need_generating() {
  if [[ ! -f .ant_targets ]]; then
    return 0
  else
    accurate=$($stat_cmd .ant_targets)
    changed=$($stat_cmd build.xml)
    return $(expr $accurate '>=' $changed)
  fi
}

function _ant() {
  if [[ -f build.xml ]]; then
    if _ant_does_target_list_need_generating; then
      sed -n '/<target/s/<target.*name="\([^"]*\).*$/\1/p' build.xml > .ant_targets
    fi
    compadd `cat .ant_targets`
  fi
}

compdef _ant ant

