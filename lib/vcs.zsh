autoload -Uz vcs_info

VCS_BRANCH="%b%u%c"
VCS_ACTION="%a"

zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr	"${ZSH_THEME_VCS_PROMPT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr		"${ZSH_THEME_VCS_PROMPT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats	"${VCS_BRANCH}:${VCS_ACTION}"  ""
zstyle ':vcs_info:*:prompt:*' formats		"${VCS_BRANCH}"                ""
zstyle ':vcs_info:*:prompt:*' nvcsformats	""                             ""      

function vcs_info_prompt()
{
    vcs_info prompt
    case $vcs_info_msg_0_ in
    "")
	return
	;;
    *)
	echo "$ZSH_THEME_VCS_PROMPT_PREFIX${vcs_info_msg_0_}$ZSH_THEME_VCS_PROMPT_SUFFIX"
	;;
    esac
}
