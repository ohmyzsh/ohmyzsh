SCM_DEBUG=yes # comment line to disable debugging
_scm_types=(git hg svn) && export _scm_types

function _scm_debug { [ $SCM_DEBUG ] && echo $* >&2 }

# Checks given 1st path argument if it's root of .git|.hg|.svn 
function _scm_get_scm_type {
  for type ($_scm_types) {
    [ ! -d "$1/.$type" ] && continue

    _scm_debug "   -> Is a $type repository"
    export SCM_ROOT=$1
    export SCM_TYPE=$type
    return 0
  }
  
  return 1
} 

# Recursive lookup for possible SCM root from current dir => /
function scm_detect_root {
  [[ $# -eq 1 && "$1" = "" ]] && return # touched the root (/)
  _DETECT_WD=${1:-$PWD}
  
  _scm_debug -ne "."

  _scm_get_scm_type "$_DETECT_WD" && return
  scm_detect_root "${_DETECT_WD%/*}"
} 
