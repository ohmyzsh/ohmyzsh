# Set to true to enable debugging output for theme functions
# Note that this can cause unstable behavior, especially with these themes:
# agnoster dstufft
ZSH_THEME_DEBUG=${ZSH_THEME_DEBUG:-false}

# Load a theme
# 
# Usage:
#   "theme <name>" loads the named theme
#   "theme random" or "theme" with no argument loads a random theme
# Return value:
#   0 on success
#   Nonzero on failure, such as requested theme not being found
function theme() {
  if [[ -z "$1" ]] || [[ "$1" = "random" ]]; then
    # Select a random theme
    local themes n random_theme
    themes=($(lstheme))
    n=${#themes[@]}
    ((n=(RANDOM%n)+1))
    random_theme=${themes[$n]}
    echo "[oh-my-zsh] Loading random theme '$random_theme'..."
    theme $random_theme
  else
    # Main case: load named theme
    local name theme_dir found
    name=$1
    found=false
    for theme_dir ($ZSH_CUSTOM $ZSH_CUSTOM/themes $ZSH/themes); do
      if [[ -f "$theme_dir/$name.zsh-theme" ]]; then
        found=true
        _omz_load_theme_from_file $name "$theme_dir/$name.zsh-theme"
        break
      fi
    done
    if [[ $found == false ]]; then
      echo "[oh-my-zsh] Theme not found: $name"
      return 1
    fi
  fi
}

# Variables to track hook functions installed by themes
_OMZ_THEME_CHPWD_FUNCTIONS=()
_OMZ_THEME_PRECMD_FUNCTIONS=()
_OMZ_THEME_PREEXEC_FUNCTIONS=()

# Implementation of loading a theme
# Most of the code in here is for tracking hooks and debugging support
function _omz_load_theme_from_file() {
  local name=$1 file=$2 params_before exclude_params
  local -A values_before

  # Reset so theme is loaded into a clean slate
  _omz_reset_theme

  # Set up tracking and debugging
  local chpwd_fcns_0 precmd_fcns_0 preexec_fcns_0 chpwd_0 precmd_0 preexec_0
  local params_after params_added param ignore_params
  chpwd_0=$(which chpwd)
  precmd_0=$(which precmd)
  preexec_0=$(which preexec)
  chpwd_fcns_0=($chpwd_functions)
  precmd_fcns_0=($precmd_functions)
  preexec_fcns_0=($preexec_functions)
  if [[ $ZSH_THEME_DEBUG == true ]]; then
    params_before=($(set +))
  fi
  for param ($params_before); do
    values_before[$param]=${(P)param}
  done

  # Actually load the theme, using an indirection function
  _omz_source_theme_file $file

  # Debugging stuff
  if [[ $ZSH_THEME_DEBUG == true ]]; then
    params_after=($(set +))
    params_added=(${params_after:|params_before})
    ignore_params=(LINENO RANDOM _ parameters prompt values_before modules \
      params_added ignore_params params_before params_after params_changed \
      SECONDS TTYIDLE PS1 PS2 PS3 PS4 RPS1 RPS2)
    params_before=(${params_before:|ignore_params})
    local params_changed
    params_changed=()
    for param ($params_before); do
      if [[ ${(P)param} != ${values_before[$param]} ]]; then
        params_changed+=($param)
      fi
    done
  fi

  # Track changes to hooks
  _OMZ_THEME_CHPWD_FUNCTIONS=(${chpwd_functions:|chpwd_fcns_0})
  _OMZ_THEME_PRECMD_FUNCTIONS=(${precmd_functions:|precmd_fcns_0})
  _OMZ_THEME_PREEXEC_FUNCTIONS=(${preexec_functions:|preexec_fcns_0})

  # Post-loading debugging
  if [[ $ZSH_THEME_DEBUG == true ]]; then
    echo "Loaded theme $name from file $file"
    if [[ -n $params_added ]]; then
      printf '=== %s ===\n%s\n' "Theme added parameters:" ${(F)params_added}
    fi
    if [[ -n $params_changed ]]; then
      printf '=== %s ===\n%s\n' "Theme changed parameters:" ${(F)params_changed}
    fi
    if [[ -n "${_OMZ_THEME_CHPWD_FUNCTIONS}${_OMZ_THEME_PRECMD_FUNCTIONS}${_OMZ_THEME_PREEXEC_FUNCTIONS}" ]]; then
      printf '=== %s ===\n' "Theme added hooks:"
      if [[ -n $_OMZ_THEME_CHPWD_FUNCTIONS ]]; then
        echo "Theme added chpwd hooks: $_OMZ_THEME_CHPWD_FUNCTIONS"
      fi
      if [[ -n $_OMZ_THEME_PRECMD_FUNCTIONS ]]; then
        echo "Theme added precmd hooks: $_OMZ_THEME_PRECMD_FUNCTIONS"
      fi
      if [[ -n $_OMZ_THEME_PREEXEC_FUNCTIONS ]]; then
        echo "Theme added preexec hooks: $_OMZ_THEME_PREEXEC_FUNCTIONS"
      fi
    fi
    if [[ $(which chpwd) != $chpwd_0 ]]; then
      echo "WARNING: Theme changed chpwd()"
    fi
    if [[ $(which preexec) != $preexec_0 ]]; then
      echo "WARNING: Theme changed preexec()"
    fi
    if [[ $(which precmd) != $precmd_0 ]]; then
      echo "WARNING: Theme changed precmd()"
    fi
  fi
}

# Sources the given file
# The only reason this function exists is to provide a layer of
# indirection so that the theme file runs in its own function call stack frame
# and "local" statements in the theme definitions work as intended.
function _omz_source_theme_file() {
  source $1
}

# Resets all theme settings to their default state
# (To the extent that we know what themes do, that is.)
# This will reset all variables used by the core OMZ *_prompt_info functions.
# It will also remove any hook functions installed by the current theme, if it
# was loaded by the theme() function
function _omz_reset_theme() {
  # Prompts
  PROMPT="%n@%m:%~%# "
  PROMPT2='%_> '
  PROMPT3='?# '
  PROMPT4='+%N:%i> '
  unset RPROMPT RPROMPT2

  # This assumes that all ZSH_THEME_<aspect>_* variables are owned by
  # OMZ theming, and can be reset en masse
  # All the commented-out variables are there to serve as a list of things
  # that are used by theme support and could be given default values

  # git_prompt_info variables
  unset -m 'ZSH_THEME_GIT_PROMPT_*'
  ZSH_THEME_GIT_PROMPT_PREFIX="git:("   # Prefix at the very beginning of the prompt, before the branch name
  ZSH_THEME_GIT_PROMPT_SUFFIX=")"       # At the very end of the prompt
  #ZSH_THEME_GIT_PROMPT_PREFIX=
  #ZSH_THEME_GIT_PROMPT_SUFFIX=
  #ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX=
  #ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX=
  ZSH_THEME_GIT_PROMPT_DIRTY="*"              # Text to display if the branch is dirty
  ZSH_THEME_GIT_PROMPT_CLEAN=""               # Text to display if the branch is clean
  #ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=
  #ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=
  #ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE=
  #ZSH_THEME_GIT_PROMPT_AHEAD=
  #ZSH_THEME_GIT_PROMPT_BEHIND=
  #ZSH_THEME_GIT_PROMPT_SHA_BEFORE=
  #ZSH_THEME_GIT_PROMPT_SHA_AFTER=
  #ZSH_THEME_GIT_PROMPT_ADDED=
  #ZSH_THEME_GIT_PROMPT_MODIFIED=
  #ZSH_THEME_GIT_PROMPT_RENAMED=
  #ZSH_THEME_GIT_PROMPT_DELETED=
  #ZSH_THEME_GIT_PROMPT_STASHED=
  #ZSH_THEME_GIT_PROMPT_UNMERGED=
  #ZSH_THEME_GIT_PROMPT_DIVERGED=
  #ZSH_THEME_GIT_PROMPT_UNTRACKED=
  # nvm_prompt_info variables
  unset -m 'ZSH_THEME_NVM_PROMPT_*'
  #ZSH_THEME_NVM_PROMPT_PREFIX=
  #ZSH_THEME_NVM_PROMPT_SUFFIX=
  # rvm_prompt_info variables
  unset -m 'ZSH_THEME_RVM_PROMPT_*'
  #ZSH_THEME_RVM_PROMPT_PREFIX=
  #ZSH_THEME_RVM_PROMPT_SUFFIX=
  #ZSH_THEME_RVM_PROMPT_OPTIONS=
  # svn_prompt_info variables
  unset -m 'ZSH_THEME_SVN_PROMPT_*'
  #ZSH_THEME_SVN_PROMPT_CLEAN
  #ZSH_THEME_SVN_PROMPT_DIRTY
  #ZSH_THEME_SVN_PROMPT_PREFIX
  #ZSH_THEME_SVN_PROMPT_SUFFIX

  # Hook functions
  if [[ -n $_OMZ_THEME_CHPWD_FUNCTIONS ]]; then
    #echo Removing chpwd hooks: $_OMZ_THEME_CHPWD_FUNCTIONS
    chpwd_functions=(${chpwd_functions:|_OMZ_THEME_CHPWD_FUNCTIONS})
  fi
  if [[ -n $_OMZ_THEME_PRECMD_FUNCTIONS ]]; then
    #echo Removing precmd hooks: $_OMZ_THEME_PRECMD_FUNCTIONS
    precmd_functions=(${precmd_functions:|_OMZ_THEME_PRECMD_FUNCTIONS})
  fi
  if [[ -n $_OMZ_THEME_PREEXEC_FUNCTIONS ]]; then
    #echo Removing preexec hooks: $_OMZ_THEME_PREEXEC_FUNCTIONS
    preexec_functions=(${preexec_functions:|_OMZ_THEME_PREEXEC_FUNCTIONS})
  fi

}


# List available themes by name
#
# The list will always be in sorted order, so you can index in to it.
function lstheme() {
  local themes x theme_dir
  themes=()
  for theme_dir ($ZSH_CUSTOM $ZSH_CUSTOM/themes $ZSH/themes); do
    if [[ -d $theme_dir ]]; then
      themes+=($(_omz_lstheme_dir $theme_dir))
    fi
  done
  echo ${(F)themes} | sort | uniq
}

# List themes defined in a given dir
function _omz_lstheme_dir() {
  ls $1 | grep '.zsh-theme$' | sed 's,\.zsh-theme$,,'
}


