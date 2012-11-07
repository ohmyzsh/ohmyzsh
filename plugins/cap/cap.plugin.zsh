stat -f%m . > /dev/null 2>&1
if [ "$?" = 0 ]; then
  stat_cmd=(stat -f%m)
else
  stat_cmd=(stat -L --format=%y)
fi

# Cache filename
_cap_show_undescribed_tasks=0

# Cache filename
_cap_task_cache_file='.cap_task_cache'

_cap_get_task_list () {
  if [ ${_cap_show_undescribed_tasks} -eq 0 ]; then
    cap -T | grep '^cap' | cut -d " " -f 2
  else
    cap -vT | grep '^cap' | cut -d " " -f 2
  fi
}

_cap_does_task_list_need_generating () {

  if [ ! -f ${_cap_task_cache_file} ]; then return 0;
  else
    accurate=$($stat_cmd $_cap_task_cache_file)
    changed=$($stat_cmd config/deploy.rb)
    return $(expr $accurate '>=' $changed)
  fi
}

function _cap () {
  if [ -f config/deploy.rb ]; then
    if _cap_does_task_list_need_generating; then
      _cap_get_task_list > ${_cap_task_cache_file}
    fi
    compadd `cat ${_cap_task_cache_file}`
  fi
}

compdef _cap cap
