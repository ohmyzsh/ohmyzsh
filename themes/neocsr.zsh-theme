# Based on steeef's and nebirhos' theme.
# Example:
#    user current_directory [rvm][git]
#    ♣                                 current_directory

# Use extended color pallete if available
# Linux (Gnome Terminal): export TERM="xterm-256color"
# Mac OS X (iTerm2): Preferences > Profiles > Terminal > Report Terminal Type
#                    xterm-256color
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
else
    turquoise="$fg[cyan]"
    orange="$fg[yellow]"
    purple="$fg[magenta]"
    hotpink="$fg[red]"
    limegreen="$fg[green]"
fi

# Get the current ruby version in use with RVM:
if [ -e ~/.rvm/bin/rvm-prompt ]; then
    RUBY_PROMPT_="%{$fg_bold[white]%}[%{$orange%}\$(~/.rvm/bin/rvm-prompt s i v g)%{$fg_bold[white]%}]%{$reset_color%}"
else
  if which rbenv &> /dev/null; then
    RUBY_PROMPT_="%{$fg_bold[white]%}[%{$orange%}\$(rbenv version | sed -e 's/ (set.*$//')%{$fg_bold[white]%}]%{$reset_color%}"
  fi
fi

# Promp
USR_DIR_PROMPT_="%{$hotpink%}%n: %{$turquoise%}%c "
GIT_PROMPT_="%{$fg_bold[white]%}\$(git_prompt_info)%{$fg_bold[white]%} % %{$reset_color%}"
ICON_PROMPT="
%{$fg_bold[red]%} ♣ %{$reset_color%}"
PROMPT="$USR_DIR_PROMPT_$RUBY_PROMPT_$GIT_PROMPT_$ICON_PROMPT"

# Right Promp
RPROMPT="%{$fg[magenta]%}%c%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$limegreen%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✹%{$fg[white]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%}]"
