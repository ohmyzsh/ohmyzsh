# trapd00r.zsh-theme
#
# This theme needs a terminal supporting 256 colors as well as unicode. It also
# needs the script that splits up the current path and makes it fancy as located
# here: https://github.com/trapd00r/utils/blob/master/zsh_path
#
# By default it spans over two lines like so:
#
# scp1@shiva:pts/9-> /home » scp1 (0)
# >
#
# that's  user@host:pts/-> splitted path (return status)
#
# If the current directory is a git repository, we span 3 lines;
#
# git❨ master ❩ DIRTY
# scp1@shiva:pts/4-> /home » scp1 » dev » utils (0)
# >

autoload -U add-zsh-hook
autoload -Uz vcs_info

local c0=$( printf "\e[m")
local c1=$( printf "\e[38;5;245m")
local c2=$( printf "\e[38;5;250m")
local c3=$( printf "\e[38;5;242m")
local c4=$( printf "\e[38;5;197m")
local c5=$( printf "\e[38;5;225m")
local c6=$( printf "\e[38;5;240m")
local c7=$( printf "\e[38;5;242m")
local c8=$( printf "\e[38;5;244m")
local c9=$( printf "\e[38;5;162m")
local c10=$(printf "\e[1m")
local c11=$(printf "\e[38;5;208m\e[1m")
local c12=$(printf "\e[38;5;142m\e[1m")
local c13=$(printf "\e[38;5;196m\e[1m")


# We dont want to use the extended colorset in the TTY / VC.
if [ "$TERM" = "linux" ]; then
    c1=$( printf "\e[34;1m")
    c2=$( printf "\e[35m")
    c3=$( printf "\e[31m")
    c4=$( printf "\e[31;1m")
    c5=$( printf "\e[32m")
    c6=$( printf "\e[32;1m")
    c7=$( printf "\e[33m")
    c8=$( printf "\e[33;1m")
    c9=$( printf "\e[34m")

    c11=$(printf "\e[35;1m")
    c12=$(printf "\e[36m")
    c13=$(printf "\e[31;1m")
fi

zstyle ':vcs_info:*' actionformats \
    '%{$c8%}(%f%s)%{$c7%}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '

zstyle ':vcs_info:*' formats \
    "%{$c8%}%s%%{$c7%}❨ %{$c9%}%{$c11%}%b%{$c7%} ❩%{$reset_color%}%f "

zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

add-zsh-hook precmd prompt_jnrowe_precmd

prompt_jnrowe_precmd () {
  vcs_info
  if [ "${vcs_info_msg_0_}" = "" ]; then
    dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%} %{$c0%}(%{$c5%}%?%{$c0%})"
    PROMPT='%{$fg_bold[green]%}%p%{$reset_color%}${vcs_info_msg_0_}${dir_status} ${ret_status}%{$reset_color%}
> '

# modified, to be commited
  elif [[ $(git diff --cached --name-status 2>/dev/null ) != "" ]]; then
    dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%} %{$c0%}(%{$c5%}%?%{$c0%})"
    PROMPT='${vcs_info_msg_0_}%{$30%} %{$bg_bold[red]%}%{$fg_bold[cyan]%}C%{$fg_bold[black]%}OMMIT%{$reset_color%}
%{$fg_bold[green]%}%p%{$reset_color%}${dir_status}%{$reset_color%}
> '

  elif [[ $(git diff --name-status 2>/dev/null ) != "" ]]; then
    dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%} %{$c0%}(%{$c5%}%?%{$c0%})"
    PROMPT='${vcs_info_msg_0_}%{$bg_bold[red]%}%{$fg_bold[blue]%}D%{$fg_bold[black]%}IRTY%{$reset_color%}
%{$fg_bold[green]%}%p%{$reset_color%}${dir_status}%{$reset_color%}
%{$c13%}>%{$c0%} '
  else
    dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%} %{$c0%}(%{$c5%}%?%{$c0%})"
    PROMPT='${vcs_info_msg_0_}
%{$fg_bold[green]%}%p%{$reset_color%}${dir_status}%{$reset_color%}
> '
fi
}

#  vim: set ft=zsh sw=2 et tw=0:
