# mnebus.zsh-theme, based on smt.zsh-theme, based on dogenpunk

local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="|"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="➤ %{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

function current_time() {
    echo $(date "+%H:%M %Z")
}

function my_zone_times() {
    zones="America/Los_Angeles, Asia/Calcutta, Asia/Shanghai, GMT"

    # trim any whitespace
    zones="$(echo -e "${zones}" | tr -d '[:space:]')"

    local IFS=","
    local output=""
    zoneArray=($(echo ${zones}))

    for zone in ${(Oa)zoneArray}; do
      output="$(TZ="${zone}" date "+%H %Z"), ${output}"
    done

    echo ${output[1,-3]}

}

PROMPT='
%{$fg[blue]%}%m%{$reset_color%} 福 %{$fg[cyan]%}%~ %{$reset_color%}$(git_prompt_short_sha)$(git_prompt_info)
$ '

RPROMPT='${return_status}$(current_time) ($(my_zone_times)) $(git_prompt_status)%{$reset_color%}'

