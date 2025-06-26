if ! (( $+commands[tmux] )); then
  print "zsh tmux plugin: tmux not found. Please install tmux before using this plugin." >&2
  return 1
fi

# CONFIGURATION VARIABLES
# Automatically start tmux
: ${ZSH_TMUX_AUTOSTART:=false}
# Only autostart once. If set to false, tmux will attempt to
# autostart every time your zsh configs are reloaded.
: ${ZSH_TMUX_AUTOSTART_ONCE:=true}
# Automatically connect to a previous session if it exists
: ${ZSH_TMUX_AUTOCONNECT:=true}
# Automatically close the terminal when tmux exits
: ${ZSH_TMUX_AUTOQUIT:=$ZSH_TMUX_AUTOSTART}
# Automatically name the new session based on the basename of PWD
: ${ZSH_TMUX_AUTONAME_SESSION:=false}
# Automatically pick up tmux environments
: ${ZSH_TMUX_AUTOREFRESH:=false}
# Set term to screen or screen-256color based on current terminal support
: ${ZSH_TMUX_DETACHED:=false}
# Set detached mode
: ${ZSH_TMUX_FIXTERM:=true}
# Set '-CC' option for iTerm2 tmux integration
: ${ZSH_TMUX_ITERM2:=false}
# The TERM to use for non-256 color terminals.
# Tmux states this should be tmux|screen, but you may need to change it on
# systems without the proper terminfo
if [[ -e /usr/share/terminfo/t/tmux ]]; then
  : ${ZSH_TMUX_FIXTERM_WITHOUT_256COLOR:=tmux}
else
  : ${ZSH_TMUX_FIXTERM_WITHOUT_256COLOR:=screen}
fi
# The TERM to use for 256 color terminals.
# Tmux states this should be (tmux|screen)-256color, but you may need to change it on
# systems without the proper terminfo
if [[ -e /usr/share/terminfo/t/tmux-256color ]]; then
  : ${ZSH_TMUX_FIXTERM_WITH_256COLOR:=tmux-256color}
else
  : ${ZSH_TMUX_FIXTERM_WITH_256COLOR:=screen-256color}
fi
# Set the configuration path
if [[ -e $HOME/.tmux.conf ]]; then
  : ${ZSH_TMUX_CONFIG:=$HOME/.tmux.conf}
elif [[ -e ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf ]]; then
  : ${ZSH_TMUX_CONFIG:=${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf}
else
  : ${ZSH_TMUX_CONFIG:=$HOME/.tmux.conf}
fi
# Set -u option to support unicode
: ${ZSH_TMUX_UNICODE:=false}

# ALIASES
function _build_tmux_alias {
  setopt localoptions no_rc_expand_param
  eval "function $1 {
    if [[ -z \$1 ]] || [[ \${1:0:1} == '-' ]]; then
      tmux $2 \"\$@\"
    else
      tmux $2 $3 \"\$@\"
    fi
  }"

  local f s
  f="_omz_tmux_alias_${1}"
  s=(${(z)2})

  eval "function ${f}() {
    shift words;
    words=(tmux ${@:2} \$words);
    ((CURRENT+=${#s[@]}+1))
    _tmux
  }"

  compdef "$f" "$1"
}

alias tksv='tmux kill-server'
alias tl='tmux list-sessions'
alias tmuxconf='$EDITOR $ZSH_TMUX_CONFIG'

_build_tmux_alias "ta" "attach" "-t"
_build_tmux_alias "tad" "attach -d" "-t"
_build_tmux_alias "ts" "new-session" "-s"
_build_tmux_alias "tkss" "kill-session" "-t"

unfunction _build_tmux_alias

# Determine if the terminal supports 256 colors
if [[ $terminfo[colors] == 256 ]]; then
  export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITH_256COLOR
else
  export ZSH_TMUX_TERM=$ZSH_TMUX_FIXTERM_WITHOUT_256COLOR
fi

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Set the correct local config file to use.
if [[ "$ZSH_TMUX_ITERM2" == "false" && -e "$ZSH_TMUX_CONFIG" ]]; then
  export ZSH_TMUX_CONFIG
  export _ZSH_TMUX_FIXED_CONFIG="${0:h:a}/tmux.extra.conf"
else
  export _ZSH_TMUX_FIXED_CONFIG="${0:h:a}/tmux.only.conf"
fi

# Wrapper function for tmux.
function _zsh_tmux_plugin_run() {
  if [[ -n "$@" ]]; then
    command tmux "$@"
    return $?
  fi

  local -a tmux_cmd
  tmux_cmd=(command tmux)
  [[ "$ZSH_TMUX_ITERM2" == "true" ]] && tmux_cmd+=(-CC)
  [[ "$ZSH_TMUX_UNICODE" == "true" ]] && tmux_cmd+=(-u)

  local _detached=""
  [[ "$ZSH_TMUX_DETACHED" == "true" ]] && _detached="-d"

  local session_name
  if [[ "$ZSH_TMUX_AUTONAME_SESSION" == "true" ]]; then
    # Name the session after the basename of the current directory
    session_name=${PWD##*/}
    # If the current directory is the home directory, name it 'HOME'
    [[ "$PWD" == "$HOME" ]] && session_name="HOME"
    # If the current directory is the root directory, name it 'ROOT'
    [[ "$PWD" == "/" ]] && session_name="ROOT"
  else
      session_name="$ZSH_TMUX_DEFAULT_SESSION_NAME"
  fi

  # Try to connect to an existing session.
  if [[ -n "$session_name" ]]; then
    [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]] && $tmux_cmd attach $_detached -t "$session_name"
  else
    [[ "$ZSH_TMUX_AUTOCONNECT" == "true" ]] && $tmux_cmd attach $_detached
  fi

  # If failed, just run tmux, fixing the TERM variable if requested.
  if [[ $? -ne 0 ]]; then
    if [[ "$ZSH_TMUX_FIXTERM" == "true" ]]; then
      tmux_cmd+=(-f "$_ZSH_TMUX_FIXED_CONFIG")
    elif [[ -e "$ZSH_TMUX_CONFIG" ]]; then
      tmux_cmd+=(-f "$ZSH_TMUX_CONFIG")
    fi

    if [[ -n "$session_name" ]]; then
      $tmux_cmd new-session -s "$session_name"
    else
      $tmux_cmd new-session
    fi
  fi

  if [[ "$ZSH_TMUX_AUTOQUIT" == "true" ]]; then
    exit
  fi
}

# Refresh tmux environment variables.
function _zsh_tmux_plugin_preexec()
{
  local -a tmux_cmd
  tmux_cmd=(command tmux)

  eval $($tmux_cmd show-environment -s)
}

# Use the completions for tmux for our function
compdef _tmux _zsh_tmux_plugin_run
# Alias tmux to our wrapper function.
alias tmux=_zsh_tmux_plugin_run

function _tmux_directory_session() {
  # current directory without leading path
  local dir=${PWD##*/}
  # md5 hash for the full working directory path
  local md5=$(printf '%s' "$PWD" | md5sum | cut -d  ' ' -f 1)
  # human friendly unique session name for this directory
  local session_name="${dir}-${md5:0:6}"
  # create or attach to the session
  tmux new -As "$session_name"
}

alias tds=_tmux_directory_session

# Autostart if not already in tmux and enabled.
if [[ -z "$TMUX" && "$ZSH_TMUX_AUTOSTART" == "true" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" && -z "$INTELLIJ_ENVIRONMENT_READER" ]]; then
  # Actually don't autostart if we already did and multiple autostarts are disabled.
  if [[ "$ZSH_TMUX_AUTOSTART_ONCE" == "false" || "$ZSH_TMUX_AUTOSTARTED" != "true" ]]; then
    export ZSH_TMUX_AUTOSTARTED=true
    _zsh_tmux_plugin_run
  fi
fi

# Automatically refresh tmux environments if tmux is running.
if [[ -n "$TMUX" && "$ZSH_TMUX_AUTOREFRESH" == "true" ]] && tmux ls >/dev/null 2>/dev/null; then
  autoload -U add-zsh-hook
  add-zsh-hook preexec _zsh_tmux_plugin_preexec
fi
