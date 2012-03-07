# ZSH Theme - Preview: http://dl.dropbox.com/u/4109351/pics/gnzh-zsh-theme.png
# Based on gnzh theme, which is based on bira theme

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

# make some aliases for the colours: (could use normal escape sequences too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check the UID
if [[ $UID -ge 1000 ]]; then # normal user
	eval PR_USER='${PR_GREEN}%n${PR_NO_COLOR}'
	eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
	local PR_PROMPT='$PR_NO_COLOR➤ $PR_NO_COLOR'
elif [[ $UID -eq 0 ]]; then # root
	eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
	eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
	local PR_PROMPT='$PR_RED➤ $PR_NO_COLOR'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"	||	-n "$SSH2_CLIENT" ]]; then
	eval PR_HOST='${PR_YELLOW}%M${PR_NO_COLOR}' # SSH
else
	eval PR_HOST='${PR_GREEN}%M${PR_NO_COLOR}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"
local date='${PR_GREEN}%D{%Y.%m.%d} ${PR_NO_COLOR}'
local time='${PR_GREEN}%D{%T %Z} ${PR_NO_COLOR}'

local user_host='${PR_USER}${PR_CYAN}@${PR_HOST}'
local current_dir='%{$PR_BOLD$PR_BLUE%}%~%{$PR_NO_COLOR%}'

# Retrieve Ruby environment info, load RVM if found
local ruby_env=''
if ${HOME}/.rvm/bin/rvm-prompt &> /dev/null; then # detect local rvm installation
	ruby_env='%{$PR_RED%}‹$(${HOME}/.rvm/bin/rvm-prompt i v g s)›%{$PR_NO_COLOR%}'
elif which rvm-prompt &> /dev/null; then # detect system rvm installation
	ruby_env='%{$PR_RED%}‹$(rvm-prompt i v g s)›%{$PR_NO_COLOR%}'
elif which rbenv &> /dev/null; then # detect Simple Ruby Version management
	ruby_env='%{$PR_RED%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$PR_NO_COLOR%}'
fi

# Retrieve git info
local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'

PROMPT="╭─${user_host} ${current_dir} ${ruby_env} ${git_branch}
╰─$PR_PROMPT "
RPROMPT="${date}${time}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_YELLOW%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$PR_NO_COLOR%}"
