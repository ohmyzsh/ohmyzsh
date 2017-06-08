################################################
#                                              #
#              omilun.zsh-theme                #
# Git: https://github.com/omilun/oh-my-zsh.git # 
#                                              #
################################################

# chack users to do some behavior.
# maybe you are yousing oh my zsh on rootuser and like to switch to anotherone.
if [ $UID -eq 0 ]; then ACOLOR="$FG[203]" BCOLOR="$FG[011]";echo "be careful if you are beginner!! you are on SuperUser now."; else ACOLOR="$FG[011]" BCOLOR="$FG[203]"; fi

# prompt's look.
local ret_status="%(?:%{$ACOLOR%}❰%{$fg_bold[green]%}✔%{$ACOLOR%}❱:%{$BCOLOR%}❰%{$FG[203]%}✘✘%{$FG[011]%}%?%{$FG[203]%}✘✘%{$BCOLOR%}❱)"

# primary prompt
PROMPT='%{$BCOLOR%}%~/\
$(git_prompt_info) \
${ret_status}%{$reset_color%} '

# right prompt
RPROMPT='%{$ACOLOR%}[%*]%{$reset_color%}'

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[044](branch:"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[214]✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[044])%{$reset_color%}"
