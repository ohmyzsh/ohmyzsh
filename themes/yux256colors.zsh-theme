# define all the 256 colors

if [ "$TERM" != "linux" ]; then

  if [ "$USER" = "root" ]; then
    USER_COLOR=$FG[196]
  else
    if [ `hostname` = $ZSH_THEME_SPECIAL_HOST ]; then
      USER_COLOR=$FG[220]
    else
      USER_COLOR=$FG[026]
    fi
  fi

  SPACER_COLOR=%F{059}
  HOSTNAME_COLOR=%F{214}
  PWD_COLOR=%F{129}
  SCREEN_SESSION_COLOR=%F{034}
  PR_RESET="%{${reset_color}%}"

  if [[ $WINDOW == "" ]]; then
    PROMPT_SCREEN_SESSION=''
  else
    PROMPT_SCREEN_SESSION="%{$SPACER_COLOR%}(%{$SCREEN_SESSION_COLOR%}$WINDOW%{$SPACER_COLOR%})"
  fi
fi

my_rvm_prompt() {
  rvm_prompt_bin="$HOME/.rvm/bin/rvm-prompt"
  if [ -x ${rvm_prompt_bin} ]; then
    ruby_version=$(${rvm_prompt_bin} v)
    gemset=$(${rvm_prompt_bin} g)
    zsh_rvm_prompt="%F{124}${ruby_version}%f%F{154}${gemset}%{$reset_color%}"
  else
    zsh_rvm_prompt=""
  fi
  echo $zsh_rvm_prompt
}

PROMPT="%{$SPACER_COLOR%}[%{$USER_COLOR%}%n$PROMPT_SCREEN_SESSION%{$SPACER_COLOR%}->%{$HOSTNAME_COLOR%}%m%{$SPACER_COLOR%}->%{$PWD_COLOR%}%~ %{$USER_COLOR%}%#%{$SPACER_COLOR%}]>%{$PR_RESET%} "
PS2="%{$USER_COLOR%}%#%{$SPACER_COLOR%}]>%{$PR_RESET%} "
RPROMPT='$(git_prompt_info)$(my_rvm_prompt)'

# git color config
ZSH_THEME_GIT_PROMPT_PREFIX="%F{154}±|%f%F{124}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}%B✘%b%F{154}|%f%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%F{154}|"

