# Based on steeef's and nebirhos' theme.
# Example:
#    user current_directory [rvm][git]
#    ♣                                 current_directory

# Use extended color pallete if available
# Linux (Gnome Terminal): export TERM="xterm-256color"
# Mac OS X (iTerm2): Preferences > Profiles > Terminal > Report Terminal Type
#                    xterm-256color
# More colors:
#    for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    white="%F{15}"
    red="%F{1}"
    turquoise="%F{81}"
    darkorange="%F{166}"
    orange="%F{214}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
else
    white="$fg[white]"
    red="$fg[red]"
    turquoise="$fg[cyan]"
    darkorange="$fg[red]"
    orange="$fg[yellow]"
    purple="$fg[magenta]"
    hotpink="$fg[red]"
    limegreen="$fg[green]"
fi

# Bold
boldwhite="$fg_bold[white]"
boldred="$fg_bold[red]"

# Get the current ruby version in use with RVM:
if [ -e ~/.rvm/bin/rvm-prompt ]; then
    RUBY_PROMPT_="%{$boldwhite%}[%{$darkorange%}\$(~/.rvm/bin/rvm-prompt s i v g)%{$boldwhite%}]%{$reset_color%}"
else
  if which rbenv &> /dev/null; then
    RUBY_PROMPT_="%{$boldwhite%}[%{$darkorange%}\$(rbenv version | sed -e 's/ (set.*$//')%{$boldwhite%}]%{$reset_color%}"
  fi
fi

# Promp
USR_DIR_PROMPT_="%{$hotpink%}%n: %{$turquoise%}%c "
GIT_PROMPT_="%{$boldwhite%}\$(git_prompt_info)%{$boldwhite%} % %{$reset_color%}"
ICON_PROMPT="
%{$red%} ♣ %{$reset_color%}"
PROMPT="$USR_DIR_PROMPT_$RUBY_PROMPT_$GIT_PROMPT_$ICON_PROMPT"

# Right Promp
RPROMPT="%{$purple%}%c%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$limegreen%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$red%}✹%{$boldwhite%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$boldwhite%}]"
