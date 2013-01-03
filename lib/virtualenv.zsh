# get the name of the virtualenv we are on
function virtualenv_prompt_info() {
    active_virtualenv=$(basename $VIRTUAL_ENV 2> /dev/null) || return
    [[ -n active_virtualenv ]] && echo "$ZSH_THEME_VIRTUALENV_PROMPT_PREFIX$active_virtualenv$ZSH_THEME_VIRTUALENV_PROMPT_SUFFIX"
}
