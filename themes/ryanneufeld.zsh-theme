svn_prompt_status() {
        [ -d "./.svn" ] || return

        base_dir="."
        while [ -d "$base_dir/.svn" ]; do base_dir="$base_dir/.."; done
        base_dir=$(stat -F "$base_dir")

        rev=$(svn info ${base_dir} | awk '/^URL/ { sub(".*/","",$0); r=$0 } /^Revision/ { sub("[^0-9]*","",$0); print r"/"$0 }')
        echo "{" ${rev} "}"
}

rvm_prompt_status() {
	if [ -f "$(which rvm-prompt)"]; then
		if [ "" -ne "$(rvm-prompt i v g)" ]; then
			 echo "<"$(rvm-prompt i v g)">"
		fi
	fi
}

local user='%{$fg[magenta]%}%n@%{$fg[magenta]%}%m%{$reset_color%}'
local pwd='%{$fg[blue]%}%~%{$reset_color%}'
local rvm='%{$fg[green]%}$(rvm_prompt_status)%{$reset_color%}'
local svn='%{$fg[green]%}$(svn_prompt_status)%{$reset_color%}'
local return_code='%(?..%{$fg[red]%}%? ↵%{$reset_color%})'
local git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭ "

PROMPT="${user} ${pwd}$ "
RPROMPT="${return_code} ${git_branch} ${svn} ${rvm}"

