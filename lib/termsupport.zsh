# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen, iterm, and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
# Limited support for Apple Terminal (Terminal can't set window and tab separately)
function title {
  [[ "$EMACS" == *term* ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  if [[ "$TERM" == screen* ]]; then
    print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
  elif [[ "$TERM" == xterm* ]] || [[ "$TERM" == rxvt* ]] || [[ "$TERM" == ansi ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    print -Pn "\e]2;$2:q\a" #set window name
    print -Pn "\e]1;$1:q\a" #set icon (=tab) name
  fi
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

# Runs before showing the prompt
function omz_termsupport_precmd {
  if [[ $DISABLE_AUTO_TITLE == true ]]; then
    return
  fi

  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

# Runs before executing the command
function omz_termsupport_preexec {
  if [[ $DISABLE_AUTO_TITLE == true ]]; then
    return
  fi

  emulate -L zsh
  setopt extended_glob

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=${1[(wr)^(*=*|sudo|ssh|rake|-*)]:gs/%/%%}
  local LINE="${2:gs/%/%%}"

  title '$CMD' '%100>...>$LINE%<<'
}

precmd_functions+=(omz_termsupport_precmd)
preexec_functions+=(omz_termsupport_preexec)


# Keep Apple Terminal.app's current working directory updated
# Based on this answer: http://superuser.com/a/315029
# With extra fixes to handle multibyte chars and non-UTF-8 locales

if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then

  # URL-encodes a string
  # Outputs the encoded string on stdout
  # Returns nonzero if encoding failed
  function _omz_urlencode() {
    local str=$1
    local url_str=""

    # URLs must use UTF-8 encoding; convert if required
    local encoding=${LC_CTYPE/*./}
    if [[ -n $encoding && $encoding != UTF-8 && $encoding != utf8 ]]; then
      str=$(echo $str | iconv -f $encoding -t UTF-8)
      if [[ $? != 0 ]]; then
        echo "Error converting string from $encoding to UTF-8" >&2
        return 1
      fi
    fi

    # Use LC_CTYPE=C to process text byte-by-byte
    local i ch hexch LC_CTYPE=C
    for ((i = 1; i <= ${#str}; ++i)); do
      ch="$str[i]"
      if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
        url_str+="$ch"
      else
        hexch=$(printf "%02X" "'$ch")
        url_str+="%$hexch"
      fi
    done
    echo $url_str
  }

  # Emits the control sequence to notify Terminal.app of the cwd
  function update_terminalapp_cwd() {
    # Identify the directory using a "file:" scheme URL, including
    # the host name to disambiguate local vs. remote paths.

    # Percent-encode the pathname.
    local URL_PATH=$(_omz_urlencode $PWD)
    [[ $? != 0 ]] && return 1
    local PWD_URL="file://$HOST$URL_PATH"
    # Undocumented Terminal.app-specific control sequence
    printf '\e]7;%s\a' $PWD_URL
  }

  # Use a precmd hook instead of a chpwd hook to avoid contaminating output
  precmd_functions+=(update_terminalapp_cwd)
  # Run once to get initial cwd set
  update_terminalapp_cwd
fi
