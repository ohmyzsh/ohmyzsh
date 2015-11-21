ASYNC_PROC=0
function precmd() {
    function async() {
        # save to temp file
        printf "%s" "$(git_prompt_info)" > "${HOME}/.zsh_tmp_prompt"

        # signal parent
        kill -s USR1 $$
    }

    # do not clear RPROMPT, let it persist

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
    PROMPT="${PROMPT_START} $(cat ${HOME}/.zsh_tmp_prompt) ${PROMPT_END}"

    # reset proc number
    ASYNC_PROC=0

    # redisplay
    zle && zle reset-prompt
}

