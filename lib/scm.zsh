SCM_DEBUG=yes # comment line to disable debugging

declare -A _SCM_PROMPT_CHARS

_SCM_TYPES=(git hg svn) && export _SCM_TYPES
_SCM_PROMPT_CHARS[git]=± 
_SCM_PROMPT_CHARS[hg]=ʜɢ 
_SCM_PROMPT_CHARS[svn]=svn 

function _scm_debug { [ $SCM_DEBUG ] && echo $(xterm_color 237 "$*") >&2 }

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
  unset SCM_PROMPT_INFO
}

# Recursive lookup for possible SCM root
function scm_detect_root {
  _DETECT_WD=${1:-$PWD}

  # skip detection if SCM root already detected and current folder is sub folder of SCM
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


function scm_prompt_info_for_git() { echo "$(git_prompt_info)$(git_prompt_status)" }
function scm_prompt_info_for_hg() {}
function scm_prompt_info_for_svn() {}

function scm_build_prompt_info() {
  [ ! $SCM_TYPE ] && return

  SCM_DATA_DIR=$SCM_ROOT/.$SCM_TYPE
  SCM_PROMPT_CACHE_FILE=$SCM_DATA_DIR/prompt_cache

  if [ ! -e "$SCM_PROMPT_CACHE_FILE" ]; then
    _scm_debug "Creating $SCM_PROMPT_CACHE_FILE"
    touch "$SCM_PROMPT_CACHE_FILE"
    SCM_PROMPT_INFO=$(scm_prompt_info_for_$SCM_TYPE) # calls scm type specific prompt generator
  else 
    LAST_UPDATE_TIME=`stat -c %Y $SCM_PROMPT_CACHE_FILE`
    DIRSTATE_TIME=`stat -c %Y $SCM_DATA_DIR`

    if [[ $DIRSTATE_TIME -gt $LAST_UPDATE_TIME || "$1" == "force" ]]; then
      _scm_debug "Updating $SCM_PROMPT_CACHE_FILE"
      SCM_PROMPT_INFO=$(scm_prompt_info_for_$SCM_TYPE) # calls scm type specific prompt generator
      touch "$SCM_PROMPT_CACHE_FILE"
    fi
  fi

  SCM_PROMPT_INFO=${SCM_PROMPT_INFO:-$(scm_prompt_info_for_$SCM_TYPE)}
  export SCM_PROMPT_INFO
}
