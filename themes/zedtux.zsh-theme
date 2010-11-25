#RVM settings
if [[ -s ~/.rvm/scripts/rvm ]] ; then 
	RPS1="%{$fg[yellow]%}rvm:%{$reset_color%}%{$fg[red]%}\$(~/.rvm/bin/rvm-prompt)%{$reset_color%} $EPS1"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}[git::"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

## Git integration
#Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
	local cb=$(current_branch)
	if [ -n "$cb" ]; then
		echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}

## Bazaar integration
parse_bzr_branch() {
	BZR_CB=`bzr nick 2> /dev/null | grep -v "ERROR" | cut -d ":" -f2 | awk -F / '{print "bzr::"$1}'`
	if [ -n "$BZR_CB" ]; then
		BZR_DIRTY=""
		[[ -n `bzr status` ]] && BZR_DIRTY="%{$fg[red]%}⚡%{$reset_color%}"
		echo "$ZSH_THEME_GIT_PROMPT_PREFIX$BZR_CB$BZR_DIRTY$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}

PROMPT='$(git_custom_status)$(parse_bzr_branch)%{$fg[red]%}%~% %{$reset_color%} %B$%b '