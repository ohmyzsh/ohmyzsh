# trapd00r.zsh-theme
#
# This theme needs a terminal supporting 256 colors as well as unicode.
# In order to avoid external dependencies, it also has a zsh version of
# the previously used perl script https://github.com/trapd00r/utils/blob/master/zsh_path,
# which splits up the current path and makes it fancy.
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

local c0=$'\e[m'
local c1=$'\e[38;5;245m'
local c2=$'\e[38;5;250m'
local c3=$'\e[38;5;242m'
local c4=$'\e[38;5;197m'
local c5=$'\e[38;5;225m'
local c6=$'\e[38;5;240m'
local c7=$'\e[38;5;242m'
local c8=$'\e[38;5;244m'
local c9=$'\e[38;5;162m'
local c10=$'\e[1m'
local c11=$'\e[38;5;208m\e[1m'
local c12=$'\e[38;5;142m\e[1m'
local c13=$'\e[38;5;196m\e[1m'


zsh_path() {
  local colors
  colors=$(echoti colors)

  local -A yellow
  yellow=(
    1  '%F{228}'   2  '%F{222}'   3  '%F{192}'   4  '%F{186}'
    5  '%F{227}'   6  '%F{221}'   7  '%F{191}'   8  '%F{185}'
    9  '%F{226}'   10  '%F{220}'   11  '%F{190}'   12  '%F{184}'
    13  '%F{214}'   14  '%F{178}'  15  '%F{208}'   16  '%F{172}'
    17  '%F{202}'   18  '%F{166}'
  )

  local dir i=1
  for dir (${(s:/:)PWD}); do
    if [[ $i -eq 1 ]]; then
      if [[ $colors -ge 256 ]]; then
        print -Pn "%F{065}%B /%b"
      else
        print -Pn "\e[31;1m /"
      fi
    else
      if [[ $colors -ge 256 ]]; then
        print -Pn "${yellow[$i]:-%f} » "
      else
        print -Pn "%F{yellow} > "
      fi
    fi

    (( i++ ))

    if [[ $colors -ge 256 ]]; then
      print -Pn "%F{065}$dir"
    else
      print -Pn "%F{blue}$dir"
    fi
  done
  print -Pn "%f"
}


# We don't want to use the extended colorset in the TTY / VC.
if [ "$TERM" = linux ]; then
  c1=$'\e[34;1m'
  c2=$'\e[35m'
  c3=$'\e[31m'
  c4=$'\e[31;1m'
  c5=$'\e[32m'
  c6=$'\e[32;1m'
  c7=$'\e[33m'
  c8=$'\e[33;1m'
  c9=$'\e[34m'
  c11=$'\e[35;1m'
  c12=$'\e[36m'
  c13=$'\e[31;1m'
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
    PROMPT='${dir_status} ${ret_status}%{$reset_color%}
> '
  # modified, to be committed
  elif [[ $(git diff --cached --name-status 2>/dev/null ) != "" ]]; then
    dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%} %{$c0%}(%{$c5%}%?%{$c0%})"
    PROMPT='${vcs_info_msg_0_}%{$30%} %{$bg_bold[red]%}%{$fg_bold[cyan]%}C%{$fg_bold[black]%}OMMIT%{$reset_color%}
${dir_status}%{$reset_color%}
> '
  elif [[ $(git diff --name-status 2>/dev/null ) != "" ]]; then
    dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%} %{$c0%}(%{$c5%}%?%{$c0%})"
    PROMPT='${vcs_info_msg_0_}%{$bg_bold[red]%}%{$fg_bold[blue]%}D%{$fg_bold[black]%}IRTY%{$reset_color%}
${dir_status}%{$reset_color%}
%{$c13%}>%{$c0%} '
  else
    dir_status="%{$c1%}%n%{$c4%}@%{$c2%}%m%{$c0%}:%{$c3%}%l%{$c6%}->%{$(zsh_path)%} %{$c0%}(%{$c5%}%?%{$c0%})"
    PROMPT='${vcs_info_msg_0_}
${dir_status}%{$reset_color%}
> '
  fi
}
