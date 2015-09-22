# Michele Bologna
#
# Implements a hg_prompt_info function that inspect the current mercurial repo
# (if any) and then outputs the status of the repo, in a similar way with
# git.zsh library.
#
# themes should customize:
# * ZSH_THEME_HG_PROMPT_UNTRACKED - symbol to show in prompt if untracked 
# files are present in the mercurial repo
# * ZSH_THEME_HG_PROMPT_ADDED - symbol to show in prompt if added files are
# present in the mercurial repo
# * ZSH_THEME_HG_PROMPT_MODIFIED - symbol to show in prompt if modified files
# are present in the mercurial repo

hg_prompt_info() 
{
	local STATUS=""
	if $(hg id >/dev/null 2>&1); then
		local BRANCH=$(hg branch 2>/dev/null)
		if `hg status | grep -q "^\?"`; then
			STATUS="$ZSH_THEME_HG_PROMPT_UNTRACKED"
		fi
		if `hg status | grep -q "^[A]"`; then
			STATUS="$ZSH_THEME_HG_PROMPT_ADDED$STATUS"
		fi
		if `hg status | grep -q "^[M]"`; then
			STATUS="$ZSH_THEME_HG_PROMPT_MODIFIED$STATUS"
		fi
		echo "$BRANCH$STATUS"
	fi
}

