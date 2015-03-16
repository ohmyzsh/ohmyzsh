#color{{{ 
autoload colors 
colors 
  
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='%{$fg[${(L)color}]%}'
(( count = $count + 1 )) 
done
FINISH="%{$terminfo[sgr0]%}"
#}}} 
  
#命令提示符 
RPROMPT=$(echo "$RED%D %T$FINISH") 
PROMPT=$(echo "$CYAN%n@$YELLOW%M:$GREEN%/$_YELLOW>$FINISH ") 
  
#PROMPT=$(echo "$BLUE%M$GREEN%/ 
#$CYAN%n@$BLUE%M:$GREEN%/$_YELLOW>>>$FINISH ") 
#标题栏、任务栏样式{{{ 
case $TERM in (*xterm*|*rxvt*|(dt|k|E)term) 
precmd () { print -Pn "\e]0;%n@%M//%/\a" } 
preexec () { print -Pn "\e]0;%n@%M//%/\ $1\a" } 
;; 
esac 
#}}} 
  
#编辑器 
export EDITOR=vim 
#输入法 
export XMODIFIERS="@im=ibus"
export QT_MODULE=ibus 
export GTK_MODULE=ibus 
#关于历史纪录的配置 {{{ 
#历史纪录条目数量 
export HISTSIZE=10000 
#注销后保存的历史纪录条目数量 
export SAVEHIST=10000 
#历史纪录文件 
export HISTFILE=~/.zhistory 
#以附加的方式写入历史纪录 
setopt INC_APPEND_HISTORY 
#如果连续输入的命令相同，历史纪录中只保留一个 
setopt HIST_IGNORE_DUPS 
#为历史纪录中的命令添加时间戳 
setopt EXTENDED_HISTORY       
  
#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径 
setopt AUTO_PUSHD 
#相同的历史路径只保留一个 
setopt PUSHD_IGNORE_DUPS 
  
#在命令前添加空格，不将此命令添加到纪录文件中 
#setopt HIST_IGNORE_SPACE 
#}}} 
  
#每个目录使用独立的历史纪录{{{ 
cd() { 
builtin cd "$@"                             # do actual cd 
fc -W                                       # write current history  file 
local HISTDIR="$HOME/.zsh_history$PWD"      # use nested folders for history 
if  [ ! -d "$HISTDIR" ] ; then          # create folder if needed 
mkdir -p "$HISTDIR"
fi
export HISTFILE="$HISTDIR/zhistory"     # set new history file 
touch $HISTFILE 
local ohistsize=$HISTSIZE 
HISTSIZE=0                              # Discard previous dir's history 
HISTSIZE=$ohistsize                     # Prepare for new dir's history 
fc -R                                       #read from current histfile 
} 
mkdir -p $HOME/.zsh_history$PWD 
export HISTFILE="$HOME/.zsh_history$PWD/zhistory"
  
function allhistory { cat $(find $HOME/.zsh_history -name zhistory) } 
function convhistory { 
sort $1 | uniq | 
sed 's/^:\([ 0-9]*\):[0-9]*;\(.*\)/\1::::::\2/' | 
awk -F"::::::" '{ $1=strftime("%Y-%m-%d %T",$1) "|"; print }'
} 
#使用 histall 命令查看全部历史纪录 
function histall { convhistory =(allhistory) | 
sed '/^.\{20\} *cd/i\\' } 
#使用 hist 查看当前目录历史纪录 
function hist { convhistory $HISTFILE } 
  
#全部历史纪录 top50 
function top50 { allhistory | awk -F':[ 0-9]*:[0-9]*;' '{ $1="" ; print }' | sed 's/ /\n/g' | sed '/^$/d' | sort | uniq -c | sort -nr | head -n 50 } 
  
#}}} 
  
#杂项 {{{ 
#允许在交互模式中使用注释  例如： 
#cmd #这是注释 
setopt INTERACTIVE_COMMENTS       
  
#启用自动 cd，输入目录名回车进入目录 
#稍微有点混乱，不如 cd 补全实用 
setopt AUTO_CD 
  
#扩展路径 
#/v/c/p/p => /var/cache/pacman/pkg 
setopt complete_in_word 
  
#禁用 core dumps 
#limit coredumpsize 0 
  
#Emacs风格 键绑定 
bindkey -e 
#bindkey -v 
#设置 [DEL]键 为向后删除 
#bindkey "\e[3~" delete-char 
  
#以下字符视为单词的一部分 
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}} 
  
#自动补全功能 {{{ 
setopt AUTO_LIST 
setopt AUTO_MENU 
#开启此选项，补全时会直接选中菜单项 
#setopt MENU_COMPLETE 
  
autoload -U compinit 
compinit 
  
#自动补全缓存 
#zstyle ':completion::complete:*' use-cache on 
#zstyle ':completion::complete:*' cache-path .zcache 
#zstyle ':completion:*:cd:*' ignore-parents parent pwd 
  
#自动补全选项 
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always 
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
  
zstyle ':completion:*:match:*' original only 
zstyle ':completion::prefix-1:*' completer _complete 
zstyle ':completion:predict:*' completer _complete 
zstyle ':completion:incremental:*' completer _complete _correct 
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate 
  
#路径补全 
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'
  
#彩色补全菜单 
eval $(dircolors -b) 
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} 
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
  
#修正大小写 
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#错误校正 
zstyle ':completion:*' completer _complete _match _approximate 
zstyle ':completion:*:match:*' original only 
zstyle ':completion:*:approximate:*' max-errors 1 numeric 
  
#kill 命令补全 
compdef pkill=kill
compdef pkill=killall 
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always 
zstyle ':completion:*:processes' command 'ps -au$USER'
  
#补全类型提示分组 
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'
  
# cd ~ 补全顺序 
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}} 
  
##行编辑高亮模式 {{{ 
# Ctrl+@ 设置标记，标记和光标点之间为 region 
zle_highlight=(region:bg=magenta #选中区域 
special:bold      #特殊字符 
isearch:underline)#搜索时使用的关键字 
#}}} 
  
##空行(光标在行首)补全 "cd " {{{ 
user-complete(){ 
case $BUFFER in
"" )                       # 空行填入 "cd " 
BUFFER="cd "
zle end-of-line 
zle expand-or-complete 
;; 
"cd --" )                  # "cd --" 替换为 "cd +" 
BUFFER="cd +"
zle end-of-line 
zle expand-or-complete 
;; 
"cd +-" )                  # "cd +-" 替换为 "cd -" 
BUFFER="cd -"
zle end-of-line 
zle expand-or-complete 
;; 
* ) 
zle expand-or-complete 
;; 
esac 
} 
zle -N user-complete 
bindkey "\t" user-complete 
#}}} 
  
##在命令前插入 sudo {{{ 
#定义功能 
sudo-command-line() { 
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
zle end-of-line                 #光标移动到行末 
} 
zle -N sudo-command-line 
#定义快捷键为： [Esc] [Esc] 
bindkey "\e\e" sudo-command-line 
#}}} 
  
#命令别名 {{{ 
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls -F --color=auto'
alias ll='ls -al'
alias grep='grep --color=auto'
alias la='ls -a'
alias pacman='sudo pacman-color'
alias p='sudo pacman-color'
alias y='yaourt'
alias h='htop'
#git alias
alias g='git'
alias gb='git branch'
alias gst='git status'
alias gsh='git show'
alias gd='git diff'
alias gco='git checkout'
#adb alias
alias aks='adb kill-server'
alias ass='adb start-server'
alias ars='aks && ass'
alias alog='adb logcat -C'
#[Esc][h] man 当前命令时，显示简短说明 
alias run-help >&/dev/null && unalias run-help 
autoload run-help 
  
#历史命令 top10 
alias top10='print -l  ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
#}}} 
  
#路径别名 {{{ 
#进入相应的路径时只要 cd ~xxx 
#hash -d A="/media/ayu/dearest"
#hash -d H="/media/data/backup/ayu"
#hash -d E="/etc/"
#hash -d D="/home/ayumi/Documents"
hash -d weigou="/home/users/shiludeng/data/dev/app/ecom/weigou"
hash -d moviese="/home/users/shiludeng/data/dev/app/search/movie/user/se"
hash -d ub="/home/users/shiludeng/data/dev/public/ub"
hash -d example="/home/users/shiludeng/data/dev/com/tools/ubgen"
#}}} 
  
#{{{自定义补全 
#补全 ping 
zstyle ':completion:*:ping:*' hosts 192.168.1.{1,50,51,100,101} www.google.com 
  
#补全 ssh scp sftp 等 
#zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })' 
#}}} 
  
#{{{ F1 计算器 
arith-eval-echo() { 
LBUFFER="${LBUFFER}echo \$(( "
RBUFFER=" ))$RBUFFER"
} 
zle -N arith-eval-echo
bindkey "^[[11~" arith-eval-echo
#}}} 
  
####{{{ 
function timeconv { date -d @$1 +"%Y-%m-%d %T" } 
  
# }}} 
  
zmodload zsh/mathfunc
autoload -U zsh-mime-setup 
zsh-mime-setup 
setopt EXTENDED_GLOB 
#autoload -U promptinit 
#promptinit 
#prompt redhat 
  
setopt correctall 
autoload compinstall 
  
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
# Initialize colors.
autoload -U colors
colors
  
# Allow for functions in the prompt.
setopt PROMPT_SUBST
   
# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

# Set the prompt.
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='%{${fg[cyan]}%}┌%n@%{${fg[yellow]}%}%M:%{${fg[cyan]}%}%B%~%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}$(svn_prompt_info)%{${fg[default]}%}%{$fg[cyan]%}
└> %'

ZSH_PROMPT_BASE_COLOR="%{$fg_bold[blue]%}"
ZSH_THEME_REPO_NAME_COLOR="%{$fg_bold[yello]%}"
ZSH_THEME_REPO_NAME_COLOR="%{$fg_bold[yello]%}"
SVN_SHOW_BRANCH="true"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%} -git- %{$reset_color%}%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ?"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ±"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[red]%} ♥"

ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg_bold[magenta]%} -svn- %{$reset_color%}%{$fg_bold[yellow]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_UNTRACKED="%{$fg[cyan]%} ?"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg_bold[red]%} ±"
ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg_bold[red]%} ♥"
