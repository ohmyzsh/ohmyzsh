# Sets color variable such as $fg, $bg, $color and $reset_color
autoload -U colors && colors

# Expand variables and commands in PROMPT variables
setopt prompt_subst

# Prompt function theming defaults
ZSH_THEME_GIT_PROMPT_PREFIX="git:("   # Beginning of the git prompt, before the branch name
ZSH_THEME_GIT_PROMPT_SUFFIX=")"       # End of the git prompt
ZSH_THEME_GIT_PROMPT_DIRTY="*"        # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""         # Text to display if the branch is clean
ZSH_THEME_RUBY_PROMPT_PREFIX="("
ZSH_THEME_RUBY_PROMPT_SUFFIX=")"


# The command probes below fork a process each, and their result doesn't change
# from one shell to the next, so they're cached for a day (like lib/grep.zsh).
typeset -A __omz_probes
__omz_probe_cache="$ZSH_CACHE_DIR/appearance-probes"
__omz_probe_cached=("$__omz_probe_cache"(Nm-1))
[[ -z "$__omz_probe_cached" ]] || source "$__omz_probe_cache"

function __omz_test_cmd_args {
  # Usage: __omz_test_cmd_args cmd args...
  # e.g. __omz_test_cmd_args gls --color
  # Runs `cmd args... /dev/null` and remembers whether it succeeded
  local key="$*"
  if (( ! ${+__omz_probes[$key]} )); then
    command "$@" /dev/null &>/dev/null
    __omz_probes[$key]=$?
    if [[ -w "$ZSH_CACHE_DIR" ]]; then
      print -r -- "__omz_probes=(" "${(@qqkv)__omz_probes}" ")" >| "$__omz_probe_cache"
    fi
  fi
  return $__omz_probes[$key]
}

# Use diff --color if available
if __omz_test_cmd_args diff --color /dev/null; then
  function diff {
    command diff --color "$@"
  }
fi

# Set up ls coloring. Done in a function so the early return below still
# reaches the cleanup at the end of this file.
() {
  # Don't set ls coloring if disabled
  [[ "$DISABLE_LS_COLORS" != true ]] || return 0

  # Default coloring for BSD-based ls
  export LSCOLORS="Gxfxcxdxbxegedabagacad"

  # Default coloring for GNU-based ls
  if [[ -z "$LS_COLORS" ]]; then
    # Define LS_COLORS via dircolors if available. Otherwise, set a default
    # equivalent to LSCOLORS (generated via https://geoff.greer.fm/lscolors)
    if (( $+commands[dircolors] )); then
      [[ -f "$HOME/.dircolors" ]] \
        && source <(dircolors -b "$HOME/.dircolors") \
        || source <(dircolors -b)
    else
      export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
    fi
  fi

  # Find the option for using colors in ls, depending on the version
  case "$OSTYPE" in
    netbsd*)
      # On NetBSD, test if `gls` (GNU ls) is installed (this one supports colors);
      # otherwise, leave ls as is, because NetBSD's ls doesn't support -G
      __omz_test_cmd_args gls --color && alias ls='gls --color=tty'
      ;;
    openbsd*)
      # On OpenBSD, `gls` (ls from GNU coreutils) and `colorls` (ls from base,
      # with color and multibyte support) are available from ports.
      # `colorls` will be installed on purpose and can't be pulled in by installing
      # coreutils (which might be installed for ), so prefer it to `gls`.
      __omz_test_cmd_args gls --color && alias ls='gls --color=tty'
      __omz_test_cmd_args colorls -G && alias ls='colorls -G'
      ;;
    (darwin|freebsd)*)
      # This alias works by default just using $LSCOLORS
      __omz_test_cmd_args ls -G && alias ls='ls -G'
      # Only use GNU ls if installed and there are user defaults for $LS_COLORS,
      # as the default coloring scheme is not very pretty
      zstyle -t ':omz:lib:theme-and-appearance' gnu-ls \
        && __omz_test_cmd_args gls --color \
        && alias ls='gls --color=tty'
      ;;
    *)
      if __omz_test_cmd_args ls --color; then
        alias ls='ls --color=tty'
      elif __omz_test_cmd_args ls -G; then
        alias ls='ls -G'
      fi
      ;;
  esac
}

unfunction __omz_test_cmd_args
unset __omz_probes __omz_probe_cache __omz_probe_cached
