## Bazaar integration
## Just works with the GIT integration just add $(bzr_prompt_info) to the PROMPT
function bzr_prompt_info() {
	BZR_BRANCH=$(command bzr nick 2> /dev/null | grep -v "ERROR" | cut -d ":" -f2 | awk -F / '{print $1}')

	if [[ -n "$BZR_BRANCH" ]]; then
		echo "$ZSH_THEME_SCM_PROMPT_PREFIX$BZR_BRANCH$(parse_bzr_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
	fi
}

function parse_bzr_dirty() {
    BZR_STATUS=$(command bzr status 2> /dev/null | tail -n1)

    if [[ -n "$BZR_STATUS" ]]; then
        echo $ZSH_THEME_GIT_PROMPT_DIRTY
    else
        echo $ZSH_THEME_GIT_PROMPT_CLEAN
    fi
}
