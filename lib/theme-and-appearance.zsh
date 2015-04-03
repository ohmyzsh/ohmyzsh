# Configure and enable ls colors

autoload -U colors && colors

export LSCOLORS="Gxfxcxdxbxegedabagacad"

# TODO organise this chaotic logic

if [[ $DISABLE_LS_COLORS != "true" ]]; then
  # Find the option for using colors in ls, depending on the version: Linux or BSD
  if [[ "$OSTYPE" == netbsd* ]]; then
    # On NetBSD, test if "gls" (GNU ls) is installed (this one supports colors);
    # otherwise, leave ls as is, because NetBSD's ls doesn't support -G
    gls --color -d . &>/dev/null && alias ls='gls --color=tty'
  elif [[ "$OSTYPE" == openbsd* ]]; then
    # On OpenBSD, "gls" (ls from GNU coreutils) and "colorls" (ls from base,
    # with color and multibyte support) are available from ports.  "colorls"
    # will be installed on purpose and can't be pulled in by installing
    # coreutils, so prefer it to "gls".
    gls --color -d . &>/dev/null && alias ls='gls --color=tty'
    colorls -G -d . &>/dev/null && alias ls='colorls -G'
  elif [[ "$OSTYPE" == darwin* ]]; then
    # this is a good alias, it works by default just using $LSCOLORS
    ls -G . &>/dev/null && alias ls='ls -G'

    # only use coreutils ls if there is a dircolors customization present ($LS_COLORS or .dircolors file)
    # otherwise, gls will use the default color scheme which is ugly af
    [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && gls --color -d . &>/dev/null && alias ls='gls --color=tty'
  else
    # For GNU ls, we use the default ls color theme. They can later be overwritten by themes.
    if [[ -z "$LS_COLORS" ]]; then
      (( $+commands[dircolors] )) && eval "$(dircolors -b)"
    fi

    ls --color -d . &>/dev/null && alias ls='ls --color=tty' || { ls -G . &>/dev/null && alias ls='ls -G' }

    # Take advantage of $LS_COLORS for completion as well.
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
  fi
fi

if [[ -n $WINDOW ]]; then
    SCREEN_NO="%B$WINDOW%b "
else
    SCREEN_NO=""
fi

# Theme and appearance
#
# Support for OMZ theming.
#
# This provides two public (user-facing) functions, theme() and lstheme(), for working
# with themes interactively.

# OMZ themes use promptsubst, so make sure it's on
setopt prompt_subst

# Set to true to enable debugging output for theme functions
# Note that this can cause unstable behavior, especially with these themes:
# agnoster dstufft
ZSH_THEME_DEBUG=${ZSH_THEME_DEBUG:-false}
# These themes are known to interact badly with our debugging support
_OMZ_DEBUG_BLACKLISTED_THEMES=(agnoster dstufft dogenpunk fino fino-time half-life \
  kolo peepcode smt steeef suvash zhann)


# Loads a theme
# 
# Usage:
#   theme <name>   - load named theme
#   theme random   - load a random theme
#   theme <n>      - load a theme by index (where <n> is an integer)
#   theme next     - load the next theme in the list of defined themes
#   theme off      - unload theme and return to zsh appearance defaults
#
# If no argument is given, `theme random` is the default behavior.
#
# Return value:
#   0 on success
#   Nonzero on failure, such as requested theme not being found or theme index
#      out of range.
#
# The "random" and "next" forms will skip over themes in the ZSH_BLACKLISTED_THEMES 
# variable.
#
# As a consequence of this argument syntax, themes may not be named "random", "next", 
# or an integer number.
function theme() {
  local themes n_themes random_theme blacklist
  if [[ -z $1 || $1 == "random" ]]; then
    # Special case: random theme
    blacklist=($(_omz_theme_blacklist))
    themes=($(lstheme))
    #themes=(${themes:|blacklist})
    _omz_array_setdiff themes themes blacklist
    n_themes=${#themes[@]}
    ((n=(RANDOM%n_themes)+1))
    random_theme=${themes[$n]}
    echo "[oh-my-zsh] Loading random theme '$random_theme'..."
    theme $random_theme
  elif [[ $1 == "next" ]]; then
    # Auto-advance to next theme
    _omz_theme_n next
  elif [[ $1 =~ '^[0-9]+$' ]]; then
    # Select theme by index
    _omz_theme_n $1
  elif [[ $1 == "off" ]]; then
    # Turn theming off
    _omz_unload_theme
  else
    # Main case: load named theme
    _omz_load_theme $1
  fi
}

# List available themes by name
#
# The list will always be in sorted order, so you can index in to it.
# Themes in the "blacklist" are still included in lstheme, because they're
# still eligible for direct reference by explicit name or index, and that
# keeps the order stable.
function lstheme() {
  local themes x theme_dir
  themes=()
  for theme_dir ($ZSH_CUSTOM $ZSH_CUSTOM/themes $ZSH/themes); do
    if [[ -d $theme_dir ]]; then
      themes+=($(_omz_lstheme_dir $theme_dir))
    fi
  done
  themes=(${(ou)themes})
  echo ${(F)themes}
}



function _omz_load_theme() {
  local name=$1
  local theme_dir found
  found=false
  for theme_dir ($ZSH_CUSTOM $ZSH_CUSTOM/themes $ZSH/themes); do
    if [[ -f "$theme_dir/$name.zsh-theme" ]]; then
      found=true
      _omz_load_theme_from_file $name "$theme_dir/$name.zsh-theme"
      break
    fi
  done
  if [[ $found == false ]]; then
    echo "[oh-my-zsh] Theme not found: '$name'"
    return 1
  fi
}

# Loads a theme by index
#
# _omz_theme_n <n>  - loads theme at given index
# _omz_theme_n next - loads the next theme from the list of defined themes
#
# Loads a theme selected by index into list of defined themes, instead of by
# name. This is to make it easy to cycle through all the themes for debugging
# or browsing purposes.
#
# If called without an argument, it just advances to the next theme in the list
# after the currently loaded theme.
#
# `_omz_theme_n next` will ignore themes in the ZSH_BLACKLISTED_THEMES parameter.
function _omz_theme_n() {
  # Numeric index argument: select theme by index 
  local themes n name n_themes blacklist
  themes=($(lstheme))
  n_themes=${#themes[@]}
  if [[ -z $1  || $1 == "next" ]]; then
    # Auto-advance to next theme
    # Find index of currently loaded theme
    local last_n=${themes[(i)$ZSH_THEME]}
    (( n = (last_n % n_themes) + 1 ))
    # Advance past blacklisted themes. Do it this way instead of removing blacklist
    # from themes list to keep indexes stable
    blacklist=($(_omz_theme_blacklist))
    while [[ ${blacklist[(i)${themes[n]}]} -le ${#blacklist} ]]; do
      if [[ $ZSH_THEME_DEBUG == 'true' ]]; then
        echo "[oh-my-zsh]: Skipping blacklisted theme ${themes[n]}"
      fi
      (( n = n % n_themes + 1 ))
    done
  else
    n=$1
    if [[ $n -gt $n_themes ]]; then
      printf "[oh-my-zsh]: Theme index %s is out of range (max is %s)\n" $n $n_themes
      return 1
    fi
  fi
  name=${themes[$n]}
  echo "Loading theme #$n/$n_themes: '$name'"
  theme $name
}

# Computes the set difference between two arrays using only ZSH 4.x features
#
#   _omz_array_setdiff(c, a, b)
#
# Determines all the items in $a that are not in $b, and outputs them.
# This is the same functionality as ZSH 5.x's "c=(${a:|b})" expansion operation,
# but is re-implemented here for compatibility with ZSH 4.x.
#
# This operates by "reference", so caller should pass in names of the input
# parameters, not their values.
#
# Implementation note: the input variables may not be named "_omz_asd_a", "_omz_asd_b", 
# or "_omz_asd_out_name", due to dynamic scoping conflicts. And you cannot use the 
# numeric parameters ($1, $2, etc) as inputs.
#
# Example:
#
#   a=(foo bar baz)
#   b=(bar qux)
#   _omz_array_setdiff c a b
#
# After the function call, $c will contain (foo baz).
#
function _omz_array_setdiff() {
  local _omz_asd_a _omz_asd_b _omz_asd_out_name
  _omz_asd_out_name=$1
  _omz_asd_a=(${(P)2})
  _omz_asd_b=(${(P)3})
  local my_out item
  my_out=()
  for item (${_omz_asd_a}); do
    if [[ ${_omz_asd_b[(i)$item]} -gt ${#_omz_asd_b} ]]; then
      my_out+=($item)
    fi
  done
  set -A $_omz_asd_out_name $my_out
}


# Variables to track hook functions installed by themes
_OMZ_THEME_CHPWD_FUNCTIONS=()
_OMZ_THEME_PRECMD_FUNCTIONS=()
_OMZ_THEME_PREEXEC_FUNCTIONS=()

# Outputs the effective theme blacklist
function _omz_theme_blacklist() {
  local blacklist=$ZSH_BLACKLISTED_THEMES
  if [[ $ZSH_THEME_DEBUG == true ]]; then
    blacklist+=($_OMZ_DEBUG_BLACKLISTED_THEMES)
  fi
  echo ${(F)blacklist}
}

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
    #params_added=(${params_after:|params_before})
    _omz_array_setdiff params_added params_after params_before
    ignore_params=(LINENO RANDOM _ parameters prompt values_before modules \
      params_added ignore_params params_before params_after params_changed \
      SECONDS TTYIDLE PS1 PS2 PS3 PS4 RPS1 RPS2)
    #params_before=(${params_before:|ignore_params})
    _omz_array_setdiff params_before params_before ignore_params
    local params_changed
    params_changed=()
    for param ($params_before); do
      if [[ "${(P)param}" != "${values_before[$param]}" ]]; then
        params_changed+=($param)
      fi
    done
  fi

  # Record which theme was loaded
  ZSH_THEME=$name

  # Track changes to hooks
  #_OMZ_THEME_CHPWD_FUNCTIONS=(${chpwd_functions:|chpwd_fcns_0})
  _omz_array_setdiff _OMZ_THEME_CHPWD_FUNCTIONS chpwd_functions chpwd_fcns_0
  #_OMZ_THEME_PRECMD_FUNCTIONS=(${precmd_functions:|precmd_fcns_0})
  _omz_array_setdiff _OMZ_THEME_PRECMD_FUNCTIONS precmd_functions precmd_fcns_0
  #_OMZ_THEME_PREEXEC_FUNCTIONS=(${preexec_functions:|preexec_fcns_0})
  _omz_array_setdiff _OMZ_THEME_PREEXEC_FUNCTIONS preexec_functions preexec_fcns_0

  # Post-loading debugging
  if [[ $ZSH_THEME_DEBUG == true ]]; then
    echo "Loaded theme '$name' from file $file"
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

# Unloads the OMZ theme from this session, by unsetting theme-related
# parameters, removing installed hook functions, and restoring prompt parameters
# to their default ZSH values
function _omz_unload_theme() {
  # Unload hook functions
  if [[ -n $_OMZ_THEME_CHPWD_FUNCTIONS ]]; then
    #echo Removing chpwd hooks: $_OMZ_THEME_CHPWD_FUNCTIONS
    _omz_array_setdiff chpwd_functions chpwd_functions _OMZ_THEME_CHPWD_FUNCTIONS
  fi
  if [[ -n $_OMZ_THEME_PRECMD_FUNCTIONS ]]; then
    #echo Removing precmd hooks: $_OMZ_THEME_PRECMD_FUNCTIONS
    _omz_array_setdiff precmd_functions precmd_functions _OMZ_THEME_PRECMD_FUNCTIONS
  fi
  if [[ -n $_OMZ_THEME_PREEXEC_FUNCTIONS ]]; then
    #echo Removing preexec hooks: $_OMZ_THEME_PREEXEC_FUNCTIONS
    _omz_array_setdiff preexec_functions preexec_functions _OMZ_THEME_PREEXEC_FUNCTIONS
  fi

  # This assumes that all ZSH_THEME_<aspect>_* variables are owned by
  # OMZ theming, and can be reset en masse
  # All the commented-out variables are there to serve as a list of things
  # that are used by theme support and could be given default values

  unset -m 'ZSH_THEME_GIT_PROMPT_*'
  unset -m 'ZSH_THEME_NVM_PROMPT_*'
  unset -m 'ZSH_THEME_RVM_PROMPT_*'
  unset -m 'ZSH_THEME_SVN_PROMPT_*'

  # Reset prompts to default ZSH values (values found in ZSH reference manual)
  PROMPT='%m%# '
  PROMPT2='%_> '
  PROMPT3='?# '
  PROMPT4='+%N:%i> '
  SPROMPT="zsh: correct '%R' to '%r' [nyae]?"
  unset RPROMPT RPROMPT2

  unset ZSH_THEME
}

# Resets all theme settings to their OMZ default state
# (To the extent that we know what themes do, that is.)
# This will reset all variables used by the core OMZ *_prompt_info functions.
# It will also remove any hook functions installed by the current theme, if it
# was loaded by the theme() function
function _omz_reset_theme() {
  _omz_unload_theme
  _omz_apply_theme_defaults
}

# Adds OMZ default values that differ from ZSH defaults
function _omz_apply_theme_defaults() {
  # Prompts
  PROMPT="%n@%m:%~%# "

  # git_prompt_info variables
  ZSH_THEME_GIT_PROMPT_PREFIX="git:("   # Prefix at the very beginning of the prompt, before the branch name
  ZSH_THEME_GIT_PROMPT_SUFFIX=")"       # At the very end of the prompt
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
  #ZSH_THEME_NVM_PROMPT_PREFIX=
  #ZSH_THEME_NVM_PROMPT_SUFFIX=
  # rvm_prompt_info variables
  #ZSH_THEME_RVM_PROMPT_PREFIX=
  #ZSH_THEME_RVM_PROMPT_SUFFIX=
  #ZSH_THEME_RVM_PROMPT_OPTIONS=
  # svn_prompt_info variables
  #ZSH_THEME_SVN_PROMPT_CLEAN
  #ZSH_THEME_SVN_PROMPT_DIRTY
  #ZSH_THEME_SVN_PROMPT_PREFIX
  #ZSH_THEME_SVN_PROMPT_SUFFIX
}


# List themes defined in a given dir
function _omz_lstheme_dir() {
  ls $1 | grep '.zsh-theme$' | sed 's,\.zsh-theme$,,'
}

# Display a key to the current prompt's symbols
# Still experimental and for debugging use, so it has a "_" prefix, and its
# API may change at any time.
function _omz_theme_show_prompt_key {
  # Hardcode the variable definitions so ones that are not set are still
  # included in the key
  local var vars
  vars=(
    ZSH_THEME_GIT_PROMPT_PREFIX
    ZSH_THEME_GIT_PROMPT_SUFFIX
    ZSH_THEME_GIT_PROMPT_CLEAN
    ZSH_THEME_GIT_PROMPT_DIRTY
    ZSH_THEME_GIT_PROMPT_ADDED
    ZSH_THEME_GIT_PROMPT_MODIFIED
    ZSH_THEME_GIT_PROMPT_RENAMED
    ZSH_THEME_GIT_PROMPT_DELETED
    ZSH_THEME_GIT_PROMPT_STASHED
    ZSH_THEME_GIT_PROMPT_UNMERGED
    ZSH_THEME_GIT_PROMPT_DIVERGED
    ZSH_THEME_GIT_PROMPT_UNTRACKED
    ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX
    ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX
    ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE
    ZSH_THEME_GIT_PROMPT_AHEAD
    ZSH_THEME_GIT_PROMPT_BEHIND
    ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE
    ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE
    ZSH_THEME_GIT_PROMPT_SHA_BEFORE
    ZSH_THEME_GIT_PROMPT_SHA_AFTER
    ZSH_THEME_NVM_PROMPT_PREFIX
    ZSH_THEME_NVM_PROMPT_SUFFIX
    ZSH_THEME_RVM_PROMPT_PREFIX
    ZSH_THEME_RVM_PROMPT_SUFFIX
    ZSH_THEME_RVM_PROMPT_OPTIONS
    ZSH_THEME_SVN_PROMPT_CLEAN
    ZSH_THEME_SVN_PROMPT_DIRTY
    ZSH_THEME_SVN_PROMPT_PREFIX
    ZSH_THEME_SVN_PROMPT_SUFFIX
  )
  for var ($vars); do
    printf '%s=' $var
    print -P -n ${(P)var}
    printf '%s\n' $reset_color
  done
}

# Set to true to enable debugging output for theme functions
# Note that this can cause unstable behavior, especially with these themes:
# agnoster dstufft
ZSH_THEME_DEBUG=${ZSH_THEME_DEBUG:-false}
# These themes are known to interact badly with our debugging support
_OMZ_DEBUG_BLACKLISTED_THEMES=(agnoster dstufft dogenpunk fino fino-time half-life \
  kolo peepcode smt steeef suvash zhann)

# Configure and enable ls colors
autoload -U colors && colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
if [[ $DISABLE_LS_COLORS != "true" ]]; then
  # Find the option for using colors in ls, depending on the version: Linux or BSD
  if [[ "$(uname -s)" == "NetBSD" ]]; then
    # On NetBSD, test if "gls" (GNU ls) is installed (this one supports colors);
    # otherwise, leave ls as is, because NetBSD's ls doesn't support -G
    gls --color -d . &>/dev/null 2>&1 && alias ls='gls --color=tty'
  elif [[ "$(uname -s)" == "OpenBSD" ]]; then
    # On OpenBSD, test if "colorls" is installed (this one supports colors);
    # otherwise, leave ls as is, because OpenBSD's ls doesn't support -G
    colorls -G -d . &>/dev/null 2>&1 && alias ls='colorls -G'
  else
    ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
  fi
fi

if [[ -n $WINDOW ]]; then
    SCREEN_NO="%B$WINDOW%b "
else
    SCREEN_NO=""
fi

# OMZ themes use promptsubst, so make sure it's on
setopt prompt_subst

# Apply theming defaults, regardless of whether a specific theme is loaded
_omz_apply_theme_defaults
