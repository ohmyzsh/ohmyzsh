SCM_DEBUG=yes # comment line to disable debugging

declare -A _SCM_PROMPT_CHARS

_SCM_TYPES=(git hg svn) && export _SCM_TYPES
_SCM_PROMPT_CHARS[git]=± 
_SCM_PROMPT_CHARS[hg]=ʜɢ 
_SCM_PROMPT_CHARS[svn]=svn 

function _scm_debug { [ $SCM_DEBUG ] && echo $* >&2 }

# Checks given 1st path argument if it's root of .git|.hg|.svn 
function _scm_get_scm_type {
  [[ "$1" = "/" ]] && return 1

  for type ($_SCM_TYPES) {
    [ ! -d "$1/.$type" ] && continue

    export SCM_ROOT="$1"
    export SCM_TYPE=$type
    return 0
  }

  return 1
} 

function _scm_reset {
  unset SCM_ROOT
  unset SCM_TYPE
}

# Recursive lookup for possible SCM root
function scm_detect_root {
  _DETECT_WD=${1:-$PWD}

  [ $SCM_ROOT ] && [[ $_DETECT_WD == $SCM_ROOT* ]] && return
  _scm_reset

  until [ "$_DETECT_WD" = "" ]; do
    _scm_get_scm_type "$_DETECT_WD" && return
    
    _DETECT_WD=${_DETECT_WD%/*}
  done
}

function scm_prompt_char() {
  [ ! $SCM_TYPE ] && return

  echo $_SCM_PROMPT_CHARS[$SCM_TYPE]
}


function scm_prompt_info_for_git() {
  git_prompt_info
}

function scm_prompt_info_for_hg() {}
function scm_prompt_info_for_svn() {}

function scm_prompt_info() {
  [ ! $SCM_TYPE ] && return

  scm_prompt_info_for_$SCM_TYPE # calls scm type specific prompt generator
}
