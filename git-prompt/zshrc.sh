# To install source this file from your .zshrc file

# Change this to reflect your installation directory
export __GIT_PROMPT_DIR=~/.oh-my-zsh/git-prompt
# Initialize colors.
autoload -U colors
colors

# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U add-zsh-hook

add-zsh-hook chpwd chpwd_update_git_vars
add-zsh-hook preexec preexec_update_git_vars
add-zsh-hook precmd precmd_update_git_vars

## Function definitions
function preexec_update_git_vars() {
    case "$2" in
        git*|'g '*|'cp '*|'mv '*|'rm '*|vim|'vim '*|fg|'fg '*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ -n "$ZSH_THEME_GIT_PROMPT_NOCACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

function chpwd_update_git_vars() {
    update_current_git_vars
}

function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

    local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
    _GIT_STATUS=`python ${gitstatus}`
    __CURRENT_GIT_STATUS=("${(@f)_GIT_STATUS}")
	GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
	GIT_REMOTE=$__CURRENT_GIT_STATUS[2]
	GIT_STAGED=$__CURRENT_GIT_STATUS[3]
	GIT_CONFLICTS=$__CURRENT_GIT_STATUS[4]
	GIT_CHANGED=$__CURRENT_GIT_STATUS[5]
	GIT_UNTRACKED=$__CURRENT_GIT_STATUS[6]
	GIT_CLEAN=$__CURRENT_GIT_STATUS[7]
}


git_super_status() {
	precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  STATUS="$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH"
	  if [ -n "$GIT_REMOTE" ]; then
          STATUS="$ZSH_THEME_GIT_PROMPT_SEPARATOR$STATUS"
		  STATUS="$ZSH_THEME_GIT_PROMPT_REMOTE$GIT_REMOTE$STATUS"
	  fi
	  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
	  if [ "$GIT_STAGED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED"
	  fi
	  if [ "$GIT_CONFLICTS" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS"
	  fi
	  if [ "$GIT_CHANGED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED"
	  fi
	  if [ "$GIT_UNTRACKED" -ne "0" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED$GIT_UNTRACKED"
	  fi
	  if [ "$GIT_CLEAN" -eq "1" ]; then
		  STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
	  fi
	  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}

# Default values for the appearance of the prompt. Configure at will.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$my_gray%}‹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$my_gray%}›%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SEPARATOR="%{$my_gray%}/"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_REMOTE="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}○"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg_bold[red]%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}*"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg_bold[red]%}×"
