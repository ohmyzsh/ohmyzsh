# my.zsh-theme

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi

local return_code="%(?..%{$fg[red]%}%?%{$reset_color%}:)"

# color vars
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

local user_host='%{$terminfo[bold]$fg[$NCOLOR]%}%n@%m%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%}%~%{$reset_color%}'
local git_super_status='$(git_super_status)'

# See if we can use extended characters to look nicer.
typeset -A altchar
set -A altchar ${(s..)terminfo[acsc]}
PR_SET_CHARSET="%{$terminfo[enacs]%}"
PR_SHIFT_IN="%{$terminfo[smacs]%}"
PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
PR_HBAR=${altchar[q]:--}
PR_ULCORNER=${altchar[l]:--}
PR_LLCORNER=${altchar[m]:--}
PR_LRCORNER=${altchar[j]:--}
PR_URCORNER=${altchar[k]:--}

# primary prompt
PROMPT="%{$my_gray%}$PR_SHIFT_IN$PR_ULCORNER$PR_HBAR$PR_SHIFT_OUT\
${user_host} ${current_dir} ${git_super_status}
%{$my_gray%}$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT\
%{$my_gray%}%D{(%m/%d %H:%M)}%B$%b "

# right prompt
RPROMPT="${return_code}"'%{$my_gray%}%l%{$reset_color%}%'
