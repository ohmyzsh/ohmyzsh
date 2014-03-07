# AVLUX theme, by Andrew vonderLuft, Nov. 2012
# based on gnzh, which is "based on bira", add svn support, show git status, color tweaks, 
# remove most special characters for broader terminal compatibility

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

# make some aliases for the colours: (coud use normal escap.seq's too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
# eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"
eval PR_USER='${PR_CYAN}%n${PR_NO_COLOR}'

# Check the UID
if [[ $UID -ge 10 ]]; then # normal user
  eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_GREEN%%%{$reset_color%}'
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_RED#%{$reset_color%}'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
  eval PR_HOST='${PR_MAGENTA}%M${PR_NO_COLOR}' #SSH
else
  eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$reset_color%})"
local user_host='${PR_USER}${PR_CYAN}@${PR_HOST}'
local current_dir='%{$PR_BOLD$PR_GREEN%}%~%{$reset_color%}'
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$fg[red]%}<$(rvm-prompt i v g s)>%{$reset_color%}'
elif which rbenv &> /dev/null; then
  rvm_ruby='%{$fg[red]%}<$(rbenv version | sed -e "s/ (set.*$//")>%{$reset_color%}'
else
  rvm_ruby='%{$fg[red]%}<$(ruby -v | sed -e "s/ (.*$//")>%{$reset_color%}'
fi
  
local git_branch='$(git_prompt_info)%{$reset_color%}'
local git_status='$(git_prompt_status)%{$reset_color%}'
local svn_info='$(svn_prompt_info)%{$reset_color%}'

#PROMPT="${user_host} ${current_dir} ${rvm_ruby} ${git_branch}$PR_PROMPT "
PROMPT="╭─${user_host} ${current_dir} ${rvm_ruby} ${svn_info}${git_branch}${git_status}
╰─>$PR_PROMPT "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}-%{$fg[red]%}x%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}-%{$fg[green]%}o%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[magenta]%}Δ%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}#%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?%{$reset_color%}"

ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg[yellow]%}svn:"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DIRTY="-%{$fg[red]%}x%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN="-%{$fg[green]%}o%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DIRTY_PWD="%{$fg[red]%}x%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN_PWD="%{$fg[green]%}o%{$reset_color%}"

