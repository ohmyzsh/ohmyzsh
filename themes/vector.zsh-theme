#PROMPT=$'%{$fg[yellow]%}%m %{$reset_color%}%F{39}[%~]%f%{$reset_color%} %{$fg[magenta]%}$(git_super_status) $(git_remote_status)%{$fg[magenta]%}\'
PROMPT=$'%{$fg[yellow]%}%m %{$reset_color%}%{$fg[cyan]%}[%~]%{$reset_color%} %{$fg[magenta]%}$(git_super_status) $(git_remote_status)%{$fg[magenta]%}\
%(?.%F{green}.%F{red})%D{%H:%M}%{$reset_color%}%{$fg[white]%} =>%{$reset_color%} '
setopt prompt_subst
setopt transient_rprompt
typeset -g ZLE_RPROMPT_INDENT=1
PROMPT_EOL_MARK=""
# Theming variables for primary prompt
#ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}["
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[magenta]%}]"
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
RPROMPT='${PROMPT_RIGHT}'
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[blue]%}%{⚑%G%}"
#ZSH_THEME_GIT_PROMPT_STASHED="📌"
ZSH_THEME_GIT_PROMPT_BRANCH="%{%{$reset_color%}$fg[magenta]%}"

ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED=true
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX="%{$fg[magenta]%}("
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX="%{$fg[magenta]%})%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[yellow]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}%{✗%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"

# Additional git prompt indicators for heavier git workflows
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}%{?%G%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}↑"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}↓"
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%}↕"

# Show last command duration on the right prompt when >= 2s (safe hooks)
typeset -g _CMD_START=$EPOCHSECONDS
typeset -g _CMD_ACTIVE=0
autoload -Uz add-zsh-hook
_preexec() { _CMD_START=$EPOCHSECONDS; _CMD_ACTIVE=1 }
_precmd() {
  if (( _CMD_ACTIVE == 0 )); then
    PROMPT_RIGHT=""
    return
  fi
  local d=$(( EPOCHSECONDS - _CMD_START ))
  # Hide right prompt on narrow widths to avoid overlap/wrap
  local minw=80
  if (( COLUMNS < minw )); then PROMPT_RIGHT=""; return; fi
  if (( d >= 2 )); then
    # Use prompt-native color escapes to avoid literal $fg[] output
    PROMPT_RIGHT="%F{yellow}dur:${d}s%f"
  else
    PROMPT_RIGHT=""
  fi
  _CMD_ACTIVE=0
}
add-zsh-hook preexec _vijay_preexec
add-zsh-hook precmd _vijay_precmd

# Force prompt redraw on terminal/tmux pane resize
TRAPWINCH() {
  emulate -L zsh
  if (( $+ZLE )); then
    zle reset-prompt
  fi
}

# More symbols to choose from:
# # ☀ ✹ ☄ ♆ ♀ ♁ ♐ ♇ ♈ ♉ ♚ ♛ ♜ ♝ ♞ ♟ ♠ ♣           ♺ ♻ ♼ ☰ ☱ ☲ ☳ ☴ ☵ ☶ ☷
# # ✡ ✔ ✖ ✚ ✱ ✤ ✦ ❤ ➜ ➟ ➼ ✂ ✎ ✐ ⨀ ⨁ ⨂ ⨍ ⨎ ⨏ ⨷ ⩚ ⩛ ⩡ ⩱ ⩲ ⩵  ⩶ ⨠
# #                   〒 ǀ ǁ ǂ ĭ Ť Ŧ
# %F{color_code}My_Text%f
#for COLOR in {0..255}
#do
#     for STYLE in "38;5"
#     do
#             TAG="\033[${STYLE};${COLOR}m"
#             STR="${STYLE};${COLOR}"
#             echo -ne "${TAG}${STR}${NONE}  "
#     done
#     echo
#done
# it also shows you the code for each color in the form 38;5;x
# where x is the code for one of the 256 available colors.
# Also, note that changing the "38;5" to "48;5" will show
# you the background color equivalent. You can then use any colors
# you like to make up the prompt as previously mentioned.
