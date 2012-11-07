# hybrid of wezm+ and gnzh (which is "based on bira") themes

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

# make some aliases for the colours: (coud use normal escap.seq's too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
  eval PR_HOST='${PR_YELLOW}%M${PR_NO_COLOR}' #SSH - remote
else
  eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH - local
fi

PR_USER='${PR_CYAN}%n${PR_NO_COLOR}'

# See if we are root or not
if [[ $UID -ge 10 ]]; then # normal user
  eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_YELLOW%%$PR_NO_COLOR'
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_RED#$PR_NO_COLOR'
fi

# Current Ruby
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$PR_RED%}‹$(rvm-prompt i v g s)›%{$PR_NO_COLOR%}'
elif which rbenv &> /dev/null; then
  rvm_ruby='%{$PR_RED%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$PR_NO_COLOR%}'
fi

local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'
local current_dir='%{$PR_GREEN%}%~%{$PR_NO_COLOR%}'
local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

PROMPT="$PR_USER@$PR_HOST${rvm_ruby}$git_branch $PR_PROMPT "
RPROMPT="$current_dir"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
