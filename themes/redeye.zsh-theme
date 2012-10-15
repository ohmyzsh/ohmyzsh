#
# redeye oh-my-zsh theme
# 
# version 1.0
# author: Greg Hedlund <ghedlund@mun.ca>
#
# Based on 'Phil's zsh prompt'
#

function redeye_precmd {

    local TERMWIDTH
    (( TERMWIDTH = $COLUMNS - 1 ))


    ###
    # Truncate the path if it's too long.
    
    PR_FILLBAR=""
    PR_PWDLEN=""
        
    local promptsize=${#${(%):-[%n@%m:%l][]--}}
    local pwdsize=${#${(%):-%~}}

    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
	    ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
		PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi

if [[ $? -eq 0 ]]; then
    PR_RETCHAR="${PR_BOLD}${PR_GREEN}:%)${PR_NO_COLOR}"
else
    PR_RETCHAR="${PR_BOLD}${PR_YELLOW}:%(${PR_NO_COLOR}"
fi

}
add-zsh-hook precmd redeye_precmd


# prompt components
#PR_ULCORNER="╭"
#PR_BLCORNER="╰"
#PR_URCORNER="╮"
#PR_BRCORNER="╯"

typeset -A altchar
set -A altchar ${(s..)terminfo[acsc]}
PR_SET_CHARSET="%{$terminfo[enacs]%}"
PR_SHIFT_IN="%{$terminfo[smacs]%}"
PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
PR_ULCORNER=${altchar[l]:--}
PR_BLCORNER=${altchar[m]:--}
PR_BRCORNER=${altchar[j]:--}
PR_URCORNER=${altchar[k]:--}
PR_HBAR=${altchar[q]:--}
PR_LBRACE="["
PR_RBRACE="]"

if [[ `uname` = "Darwin" ]]; then
	PR_PROMPTCHAR=""
else
	PR_PROMPTCHAR="$"
fi

PR_GIT_DIRTY=${altchar[g]:--}

# setup color aliases
autoload -U colors zsh/terminfo
colors
setopt prompt_subst

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# user info
if [[ $UID -eq 0 ]]; then # root
    eval PR_USER="${PR_BOLD}${PR_RED}%n${PR_NO_COLOR}"
else
    eval PR_USER="${PR_BOLD}${PR_WHITE}%n${PR_NO_COLOR}"
fi

# host info
if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    eval PR_HOST='${PR_YELLOW}%m${PR_NO_COLOR}${PR_GREEN}:%l${PR_NO_COLOR}'
else
    eval PR_HOST='${PR_BOLD}${PR_WHITE}%m${PR_NO_COLOR}${PR_GREEN}:%l${PR_NO_COLOR}'
fi



# git prompt components
ZSH_THEME_GIT_PROMPT_PREFIX="${PR_RED}${PR_SHIFT_IN}${PR_HBAR}${PR_LBRACE}${PR_SHIFT_OUT}${PR_NO_COLOR}${PR_BOLD}${PR_WHITE}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${PR_NO_COLOR}${PR_RED}${PR_SHIFT_IN}${PR_RBRACE}${PR_SHIFT_OUT}${PR_NO_COLOR}"
ZSH_THEME_GIT_PROMPT_DIRTY="${PR_NO_COLOR}${PR_BOLD}${PR_YELLOW}${PR_SHIFT_IN}${PR_GIT_DIRTY}${PR_SHIFT_OUT}${PR_NO_COLOR}"

PR_PROMPT="${PR_NO_COLOR}${PR_RED}${PR_SHIFT_IN}${PR_BLCORNER}${PR_HBAR}${PR_PROMPTCHAR}${PR_SHIFT_OUT}${PR_NO_COLOR} "

local return_code="%(?..${PR_NO_COLOR}${PR_RED}${PR_SHIFT_IN}${PR_LBRACE}${PR_SHIFT_OUT}${PR_BOLD}${PR_YELLOW}%?${PR_NO_COLOR}${PR_RED}${PR_SHIFT_IN}${PR_RBRACE}${PR_SHIFT_OUT})"

 
# setup prompt
PROMPT='${PR_SET_CHARSET}${PR_RED}${PR_SHIFT_IN}${PR_ULCORNER}${PR_LBRACE}${PR_SHIFT_OUT}${PR_NO_COLOR}${PR_USER}${PR_NO_COLOR}${PR_GREEN}@${PR_HOST}${PR_NO_COLOR}${PR_RED}${PR_SHIFT_IN}${PR_RBRACE}${(e)PR_FILLBAR}${PR_LBRACE}${PR_SHIFT_OUT}${PR_NO_COLOR}${PR_BOLD}${PR_WHITE}%$PR_PWDLEN<…<%~%<<${PR_NO_COLOR}${PR_RED}${PR_SHIFT_IN}${PR_RBRACE}${PR_URCORNER}${PR_SHIFT_OUT}
${PR_PROMPT}'

RPROMPT=' ${return_code}$(git_prompt_info)${PR_NO_COLOR}${PR_RED}${PR_SHIFT_IN}${PR_BRCORNER}${PR_SHIFT_OUT}${PR_NO_COLOR}'	

PS2='${PR_NO_COLOR}${PR_RED}${PR_SHIFT_IN}${PR_BLCORNER}${PR_LBRACE}${PR_SHIFT_OUT}${PR_WHITE}%_${PR_RED}${PR_SHIFT_IN}${PR_RBRACE}${PR_HBAR}${PR_PROMPTCHAR}${PR_SHIFT_OUT}${PR_NO_COLOR} '

