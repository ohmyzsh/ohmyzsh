# Risto Theme

# Get the name of the git branch and show two states:
#    Working tree Dirty
#    Files added ready to be commited
function git_prompt_dirty_add() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  gitstat=$(git status 2>/dev/null | grep '\(# Untracked\|# Changes\|# Unmerged\|# Changed but not updated:\)')

  if [[ $(echo ${gitstat} | grep -c "^# Changes to be committed:$") > 0 ]]; then
    statchars="$ZSH_THEME_GIT_PROMPT_ADDED"
  fi

  if [[ $(echo ${gitstat} | grep -c "^\(# Untracked files:\|# Unmerged paths:\|# Changed but not updated:\)$") > 0 ]]; then
    statchars="$statchars$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$statchars$ZSH_THEME_GIT_PROMPT_SUFFIX"
}


if [[ $TERM != "xterm-256color" ]]
then
        PROMPT='%{$fg[green]%}%n@%m:%{$fg[blue]%}%2~ $(git_prompt_dirty_add)%{$reset_color%}%(!.#.%%) %{$reset_color%}'
        RPROMPT='%{$fg_bold[red]%}$(~/.rvm/bin/rvm-prompt 2> /dev/null)%{$reset_color%}%'
        ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
        ZSH_THEME_GIT_PROMPT_SUFFIX="$(git_prompt_info)%{$fg_bold[red]%}›%{$reset_color%}"
        ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}∗%{$reset_color%}"
        ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✓%{$reset_color%}"
else

        darkred=052
        red=008
        blue=025
        green=034
        yellow=142

        PROMPT='%{$FG[$green]%}%n@%m:%{$FG[$blue]%}%2~ $(git_prompt_dirty_add)%{$FX[reset]%}%(!.#.%%) %{$FX[reset]%}'
        RPROMPT='%{$FG[$darkred]%}$(~/.rvm/bin/rvm-prompt 2> /dev/null)%{$reset_color%}%'
        ZSH_THEME_GIT_PROMPT_PREFIX="$FG[$red]‹"
        ZSH_THEME_GIT_PROMPT_SUFFIX="$(git_prompt_info)$FG[$red]›%{$FX[reset]%}"
        ZSH_THEME_GIT_PROMPT_DIRTY="$FG[$yellow]∗"
        ZSH_THEME_GIT_PROMPT_ADDED="$FG[$green]✓"
        LSCOLORS="ExGxBxDxbxEgEdxbxgacba"
fi
