function theme_precmd {
  PR_FILLBAR=""
  PR_PWDLEN=""

  local promptsize=${#${(%):--(%n@%M:)--(%l)-}}
  local pwdsize=${#${(%):-%~}}
  local gitbranchsize="${#${(%)$(git_prompt_info)}:-}"
  local rvmpromptsize="${#${(%)$(ruby_prompt_info):-}}"

  # Truncate the path if it's too long.
  if (( promptsize + pwdsize + rvmpromptsize + gitbranchsize > COLUMNS )); then
    (( PR_PWDLEN = COLUMNS - promptsize ))
  else
    PR_FILLBAR="\${(l.$(( COLUMNS - (promptsize + pwdsize + rvmpromptsize + gitbranchsize) ))..${PR_SPACE}.)}"
  fi
}

function theme_preexec {
  setopt local_options extended_glob
  if [[ "$TERM" == "screen" ]]; then
    local CMD=${1[(wr)^(*=*|sudo|-*)]}
    echo -n "\ek$CMD\e\\"
  fi

  if [[ "$TERM" == "xterm" ]]; then
    print -Pn "\e]0;$1\a"
  fi

  if [[ "$TERM" == "rxvt" ]]; then
    print -Pn "\e]0;$1\a"
  fi

}

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
add-zsh-hook preexec theme_preexec


# Set the prompt

# Need this so the prompt will work.
setopt prompt_subst

# See if we can use colors.
autoload zsh/terminfo
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY; do
  typeset -g PR_$color="%{$terminfo[bold]$fg[${(L)color}]%}"
  typeset -g PR_LIGHT_$color="%{$fg[${(L)color}]%}"
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

# Use extended characters to look nicer
PR_HBAR="-"
PR_ULCORNER="-"
PR_LLCORNER="-"
PR_LRCORNER="-"
PR_URCORNER="-"

# Modify Git prompt
ZSH_THEME_GIT_PROMPT_PREFIX=" ["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"

# Modify RVM prompt
ZSH_THEME_RUBY_PROMPT_PREFIX=" ["
ZSH_THEME_RUBY_PROMPT_SUFFIX="]"

# Decide if we need to set titlebar text.
case $TERM in
  xterm*|*rxvt*)
    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%M:%~ $(git_prompt_info) $(ruby_prompt_info) | ${COLUMNS}x${LINES} | %y\a%}'
    ;;
  screen)
    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
    ;;
  *)
    PR_TITLEBAR=""
    ;;
esac

# Decide whether to set a screen title
if [[ "$TERM" == "screen" ]]; then
  PR_STITLE=$'%{\ekzsh\e\\%}'
else
  PR_STITLE=""
fi

# Finally, the prompt.
PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_RED$PR_HBAR<\
$PR_BLUE%(!.$PR_RED%SROOT%s.%n)$PR_GREEN@$PR_BLUE%M:$PR_GREEN%$PR_PWDLEN<...<%~$PR_CYAN$(git_prompt_info)$(ruby_prompt_info)\
$PR_RED>$PR_HBAR${(e)PR_FILLBAR}\
$PR_RED$PR_HBAR<\
$PR_GREEN%l$PR_RED>$PR_HBAR\

$PR_RED$PR_HBAR<\
%(?..$PR_LIGHT_RED%?$PR_BLUE:)\
$PR_LIGHT_BLUE%(!.$PR_RED.$PR_WHITE)%#$PR_RED>$PR_HBAR\
$PR_NO_COLOUR '
