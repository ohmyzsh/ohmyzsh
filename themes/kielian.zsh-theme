# modified xiong-chiamiov-plus.zsh-theme
# initial readme: 
#     user, host, full path, and time/date
#     entry in a nice long thread on the Arch Linux forums:
#      http://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
#     on two lines for easier vgrepping
#
# added: 
# 1.  git_prompt-status using 漢字 (kanji)
# 2.  modded colorscheme (green theme)

PROMPT=$'%{\e[1;38m%}%B┌─[%b%{\e[0m%}%{\e[1;32m%}%n%{\e[1;30m%}@%{\e[1m%}%{\e[0;36m%}%m%{\e[0m%}%{\e[1;38m%}]%b%{\e[0m%} - %b%{\e[1;38m%}%B[%b%{\e[1;37m%}%~%{\e[0m%}%{\e[1;38m%}%B]%b%{\e[0m%} - %{\e[1;38m%}%B[%b%{\e[0;33m%}'%D{"%a %b %d, %I:%M"}%b$'%{\e[1;38m%}%B]%b%{\e[0m%}
%{\e[1;38m%}%B└─%B[%{\e[1;33m%}$%{\e[0;38m%}%B]%{\e[1;30m%}<%{\e[0;30m%}%B$(git_prompt_info)$(git_prompt_status)%{\e[1;30m%}>%{\e[0m%}%b '
PS2=$' \e[1;38m%}%B>%{\e[0m%}%b '

ZSH_THEME_GIT_PROMPT_ADDED="%{\e[0;34m%} 且"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{\e[1;34m%} 変"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} 不"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} 名"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} 分"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%} 迷"
