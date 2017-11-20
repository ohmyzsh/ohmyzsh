# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: http://bbs.archlinux.org/viewtopic.php?pid=521888#p521888
source /home/emejia/utec/ide/zsh-git-prompt/zshrc.sh
GIT_PROMPT_EXECUTABLE="haskell"

function hg_prompt_info {
    hg prompt --angle-brackets "\
<hg:%{$fg[magenta]%}<branch>%{$reset_color%}><:%{$fg[magenta]%}<bookmark>%{$reset_color%}>\
</%{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[red]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✈"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

function mygit() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(git_prompt_short_sha)$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX "
  fi
}

COLOR_ROOT="%{$fg_bold[green]%}"

function getruta() {echo "%{$fg[cyan]%}[%~]%{$reset_color%}"}
function getrutalength() {echo "[%{$fg_bold[grey]%}%30>...>%~%>>]%{$reset_color%}"}
function getusername(){echo "%{$fg[green]%}%n%b%{$fg[yellow]%}@%{$fg[magenta]%}%m%{$reset_color%}"}
function gettime(){echo "%b%{$fg[yellow]%}%D{"%H:%M:%S"}%b%{$reset_color%}"}
function dirpwd() {echo "%{$fg_bold[cyan]%}%1~%{$reset_color%}"}
# alternate prompt with git & hg
PROMPT=$'
$COLOR_ROOT┌─< $(dirpwd)  $(getruta) 
$COLOR_ROOT|   $(gettime)
$COLOR_ROOT└─>%{$reset_color%} $(git_super_status)$ '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '

RPROMPT='$(getusername)'