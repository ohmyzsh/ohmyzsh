SCM_DEBUG=yes # comment line to disable debugging

declare -A _scm_prompt_chars

_scm_types=(git hg svn) && export _scm_types
_scm_prompt_chars[git]=± 
_scm_prompt_chars[hg]=ʜɢ 
_scm_prompt_chars[svn]=svn 

function _scm_debug { [ $SCM_DEBUG ] && echo $* >&2 }

# Checks given 1st path argument if it's root of .git|.hg|.svn 
function _scm_get_scm_type {
  for type ($_scm_types) {
    [ ! -d "$1/.$type" ] && continue

    export SCM_ROOT="$1"
    export SCM_TYPE=$type
    
    return 0
  }
  
  return 1
} 

# Recursive lookup for possible SCM root
function scm_detect_root {
  _DETECT_WD=${1:-$PWD}

  [ $SCM_ROOT ] && [[ $_DETECT_WD == $SCM_ROOT* ]] && return

  unset SCM_ROOT
  unset SCM_TYPE

  until [ "$_DETECT_WD" = "" ]; do
    _scm_get_scm_type "$_DETECT_WD" && return
    
    _DETECT_WD=${_DETECT_WD%/*}
  done
}

function scm_prompt_char() {
  [ ! $SCM_TYPE ] && return

  echo $_scm_prompt_chars[$SCM_TYPE]
}
