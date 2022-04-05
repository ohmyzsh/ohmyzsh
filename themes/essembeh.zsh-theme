<<<<<<< HEAD
# Theme with full path names and hostname
# Handy if you work on different servers all the time;

local return_code="%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})"

function my_git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	[[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Colored prompt
ZSH_THEME_COLOR_USER="green" 
ZSH_THEME_COLOR_HOST="green" 
ZSH_THEME_COLOR_PWD="yellow" 
test -n "$SSH_CONNECTION" && ZSH_THEME_COLOR_USER="red" && ZSH_THEME_COLOR_HOST="red"
test `id -u` = 0 && ZSH_THEME_COLOR_USER="magenta" && ZSH_THEME_COLOR_HOST="magenta"
PROMPT='%{$fg_bold[$ZSH_THEME_COLOR_USER]%}%n@%{$fg_bold[$ZSH_THEME_COLOR_HOST]%}%M%{$reset_color%}:%{$fg_bold[$ZSH_THEME_COLOR_PWD]%}%~%{$reset_color%} $(my_git_prompt_info)%(!.#.$) '
RPS1="${return_code}"

=======
# My custom theme:
#   - single line
#   - quite simple by default: user@host:$PWD
#   - green for local shell as non root
#   - red for ssh shell as non root
#   - magenta for root sessions
#   - prefix with remote address for ssh shells
#   - prefix to detect docker containers or chroot
#   - git plugin to display current branch and status

# git plugin 
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"

<<<<<<< HEAD
=======
function zsh_essembeh_gitstatus {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	if [[ -n $GIT_STATUS ]]; then
		GIT_STATUS=" $GIT_STATUS"
	fi
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# by default, use green for user@host and no prefix
local ZSH_ESSEMBEH_COLOR="green"
local ZSH_ESSEMBEH_PREFIX=""
if [[ -n "$SSH_CONNECTION" ]]; then
	# display the source address if connected via ssh
	ZSH_ESSEMBEH_PREFIX="%{$fg[yellow]%}[$(echo $SSH_CONNECTION | awk '{print $1}')]%{$reset_color%} "
	# use red color to highlight a remote connection
	ZSH_ESSEMBEH_COLOR="red"
elif [[ -r /etc/debian_chroot ]]; then 
	# prefix prompt in case of chroot
	ZSH_ESSEMBEH_PREFIX="%{$fg[yellow]%}[chroot:$(cat /etc/debian_chroot)]%{$reset_color%} "
elif [[ -r /.dockerenv ]]; then
	# also prefix prompt inside a docker container
	ZSH_ESSEMBEH_PREFIX="%{$fg[yellow]%}[docker]%{$reset_color%} "
fi
if [[ $UID = 0 ]]; then
	# always use magenta for root sessions, even in ssh
	ZSH_ESSEMBEH_COLOR="magenta"
fi
PROMPT='${ZSH_ESSEMBEH_PREFIX}%{$fg[$ZSH_ESSEMBEH_COLOR]%}%n@%M%{$reset_color%}:%{%B$fg[yellow]%}%~%{$reset_color%b%} $(zsh_essembeh_gitstatus)%(!.#.$) '
RPROMPT="%(?..%{$fg[red]%}%?%{$reset_color%})"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
