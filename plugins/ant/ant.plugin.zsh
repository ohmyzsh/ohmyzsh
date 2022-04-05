<<<<<<< HEAD
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
=======
# Default to colored output
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
