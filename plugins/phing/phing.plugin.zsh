<<<<<<< HEAD
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
=======
_phing () {
  if [ -f build.xml ]; then
    compadd $(phing -l|grep -v "\[property\]"|grep -v "Buildfile"|sed 1d|grep -v ":$" |grep -v "^\-*$"|grep -v "Warning:"|awk '{print $1}')
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  fi
}

compdef _phing phing
