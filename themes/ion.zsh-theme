typeset -gF ohmyzsh_ion_starttime
# zsh bug or PEBKAC? The 1 refers to the float precision but zsh complains
# about an invalid integer base. See typeset_setbase in
# http://zsh.git.sourceforge.net/git/gitweb.cgi?p=zsh/zsh;a=blob;f=Src/builtin.c
typeset -gF1 ohmyzsh_ion_time 2>/dev/null

ohmyzsh_ion_preexec() {
  typeset -gF SECONDS
  ohmyzsh_ion_starttime="$SECONDS"
}

ohmyzsh_ion_precmd() {
  typeset -gF SECONDS
  ohmyzsh_ion_time="$(($SECONDS-$ohmyzsh_ion_starttime))"
}

autoload -U add-zsh-hook
add-zsh-hook preexec ohmyzsh_ion_preexec
add-zsh-hook precmd  ohmyzsh_ion_precmd

local color_error="$fg_bold[red]"
local color_info="$fg_bold[black]"
local color_user="$fg_bold[blue]"
local color_root="$fg_bold[red]"

local newline=$'\n'

local p_error="%(?..%{$color_error%}%?%{$reset_color%} )"
local p_fmt_a="%{$color_info%}"
local p_cmdtime="\${ohmyzsh_ion_time}s "
local p_time="%* "
local p_screen="\${STY:+screen }"
local p_tmux="\${TMUX:+tmux }"
local p_user="%n "
local p_host="%m "
local p_pwd="%~ "
local p_git="\$(git_prompt_info)"
local p_fmt_b="%{$reset_color%}$newline"
local p_prompt="%{%(#.$color_root.$color_user)%}%#%{$reset_color%} "

PROMPT="${p_error}${p_fmt_a}${p_cmdtime}${p_time}${p_screen}${p_tmux}${p_user}${p_host}${p_pwd}${p_git}${p_fmt_b}${p_prompt}"
