# Asynchronous prompt heavily based on Anish Athalye's [0]
# [0[ https://www.anishathalye.com/2015/02/07/an-asynchronous-shell-prompt/
#
# To use in your theme, define an `rprompt` function that echoes whatever you
# want to have on the right-hand-side prompt.
#
setopt prompt_subst # enable command substition in prompt

local _RPROMPT_FILE=$(umask 7077; mktemp /tmp/zsh_async_prompt.$$.XXXXXX)

ASYNC_PROC=0
function precmd() {
    function async() {

        # save to temp file
	printf "%s" "$(rprompt)" > "${_RPROMPT_FILE}"

        # signal parent
        kill -s USR1 $$
    }

    # do not clear RPROMPT, let it persist
    RPROMPT="${ZSH_THEME_ASYNC_PROMPT_OLD_PREFIX}${RPROMPT}${ZSH_THEME_ASYNC_PROMPT_OLD_SUFFIX}"

    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    # start background computation
    async &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    # read from temp file
    RPROMPT="$(cat ${_RPROMPT_FILE})"

    # reset proc number
    ASYNC_PROC=0

    # redisplay
    zle && zle reset-prompt
}

function async_zshexit() {
	rm ${_RPROMPT_FILE}
}

autoload -U add-zsh-hook
add-zsh-hook zshexit async_zshexit
