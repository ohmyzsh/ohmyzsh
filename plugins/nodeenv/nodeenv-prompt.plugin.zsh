export NODE_VIRTUAL_ENV_DISABLE_PROMPT=1

ZSH_THEME_NODEENV_PROMPT_PREFIX="("
ZSH_THEME_NODEENV_PROMPT_SUFFIX=")"

function nodeenv_prompt_info() {
    if [ -n "$NODE_VIRTUAL_ENV" ]; then

        if [ "`basename "$NODE_VIRTUAL_ENV"`" = "__" ] ; then
            # special case for Aspen magic directories
            # see http://www.zetadev.com/software/aspen/
            local name="[`basename \`dirname "$NODE_VIRTUAL_ENV"\``]"
        else
            local name=`basename "$NODE_VIRTUAL_ENV"`
        fi
        echo "$ZSH_THEME_NODEENV_PROMPT_PREFIX$name$ZSH_THEME_NODEENV_PROMPT_SUFFIX"
    fi
}
