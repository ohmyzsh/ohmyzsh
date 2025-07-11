# ~/.oh-my-zsh/custom/themes/axira.zsh-theme

autoload -U colors && colors

local BLUE="%F{33}"
local GREEN="%F{76}"
local RED="%F{196}"
local YELLOW="%F{226}"
local MAGENTA="%F{201}"
local CYAN="%F{51}"
local RESET="%f%k"

local PROMPT_CORNER="┌─"
local PROMPT_BOTTOM="└─"
local PROMPT_ARROW="➜"

get_ip() {
  local ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
  if [[ -z "$ip" ]]; then
    ip=$(ip -4 addr show eth0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
  fi
  [[ -z "$ip" ]] && ip="NoNet"
  echo "$ip"
}

get_ip_icon() {
  ip link show tun0 2>/dev/null | grep -q "state UP" && echo "🔒" || echo "🌐"
}

git_branch() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [[ -n "$branch" ]] && echo "%{$YELLOW%} $branch%{$RESET%}"
}

python_venv() {
  [[ -n "$VIRTUAL_ENV" ]] && echo "%{$MAGENTA%}[🐍 $(basename $VIRTUAL_ENV)]%{$RESET%}"
}

exit_status() {
  [[ $? -eq 0 ]] && echo "%{$GREEN%}✔%{$RESET%}" || echo "%{$RED%}✗%{$RESET%}"
}

PROMPT='
%{$CYAN%}${PROMPT_CORNER}[%{$BLUE%}%~%{$CYAN%}] [%{$CYAN%}$(get_ip_icon) %{$GREEN%}$(get_ip)%{$CYAN%}] $(python_venv) $(git_branch)
%{$CYAN%}${PROMPT_BOTTOM}${PROMPT_ARROW} %{$RESET%}'

RPROMPT='$(exit_status)'
