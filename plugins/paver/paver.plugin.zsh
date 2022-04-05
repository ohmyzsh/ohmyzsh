_paver_does_target_list_need_generating () {
<<<<<<< HEAD
  [ ! -f .paver_targets ] && return 0;
  [ pavement.py -nt .paver_targets ] && return 0;
  return 1;
=======
  [ ! -f .paver_targets ] && return 0
  [ pavement.py -nt .paver_targets ] && return 0
  return 1
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
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
