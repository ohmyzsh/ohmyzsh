if [ "$USER" = "root" ]; then CARETCOLOR="red"; else CARETCOLOR="magenta"; fi

local return_code="%(?..%{$fg_bold[red]%}:( %?%{$reset_color%})"

PROMPT='
%{$fg_bold[cyan]%}%n%{$reset_color%}%{$fg[yellow]%}@%{$reset_color%}%{$fg_bold[blue]%}%M%{$reset_color%}:%{${fg_bold[green]}%}%~%{$reset_color%}$(git_prompt_info)
%{${fg[$CARETCOLOR]}%}%# %{${reset_color}%}'

RPS1='${return_code} %D - %*'"$RPS1"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}^%{$reset_color%}%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ±"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[red]%} ♥"

#以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>/\'
#}}}

#漂亮又实用的命令高亮界面 
setopt extended_glob 
 TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace') 
  
 recolor-cmd() { 
     region_highlight=() 
     colorize=true
     start_pos=0 
     for arg in ${(z)BUFFER}; do
         ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}})) 
         ((end_pos=$start_pos+${#arg})) 
         if $colorize; then
             colorize=false
             res=$(LC_ALL=C builtin type $arg 2>/dev/null) 
             case $res in
                 *'reserved word'*)   style="fg=magenta,bold";; 
                 *'alias for'*)       style="fg=cyan,bold";; 
                 *'shell builtin'*)   style="fg=yellow,bold";; 
                 *'shell function'*)  style='fg=green,bold';; 
                 *"$arg is"*) 
                     [[ $arg = 'sudo' ]] && style="fg=red,bold" || style="fg=blue,bold";; 
                 *)                   style='none,bold';; 
             esac 
             region_highlight+=("$start_pos $end_pos $style") 
         fi
         [[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
         start_pos=$end_pos 
     done
 } 
check-cmd-self-insert() { zle .self-insert && recolor-cmd } 
check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd } 
  
zle -N self-insert check-cmd-self-insert 
zle -N backward-delete-char check-cmd-backward-delete-char
