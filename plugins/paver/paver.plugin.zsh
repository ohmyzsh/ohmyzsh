_paver_does_target_list_need_generating () {
  [ ! -f .paver_targets ] && return 0;
  [ pavement.py -nt .paver_targets ] && return 0;
  return 1;
}

_paver () {
  if [ -f pavement.py ]; then
    if _paver_does_target_list_need_generating; then
      paver --help 2>&1 |grep '-'|grep -v -e '--'|awk -F '-' '{print $1}'|tr -d ' ' > .paver_targets
    fi
    compadd `cat .paver_targets`
  fi
}

compdef _paver paver
