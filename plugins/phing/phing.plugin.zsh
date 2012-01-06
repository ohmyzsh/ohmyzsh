stat -f%m . > /dev/null 2>&1
if [ "$?" = 0 ]; then
  stat_cmd=(stat -f%m)
else
  stat_cmd=(stat -L --format=%Y)
fi

_phing_does_target_list_need_generating () {
  if [ ! -f .phing_targets ]; then return 0;
  else
    accurate=$($stat_cmd .phing_targets)
    changed=$($stat_cmd build.xml)
    return $(expr $accurate '>=' $changed)
  fi
}

_phing () {
  if [ -f build.xml ]; then
    if _phing_does_target_list_need_generating; then
      phing -l |grep -v ":" |grep -v "^$"|grep -v "\-" | awk '{print $1}' | uniq > .phing_targets
    fi
    compadd `cat .phing_targets`
  fi
}

compdef _phing phing
