#------activate/deactivate automatically--------------
if [[ ! $DISABLE_NODEENV_CD -eq 1 ]]; then
    # Automatically activate Git projects's virtual environments based on the
    # directory name of the project. Virtual environment name can be overridden
    # by placing a .nodeenv file in the project root with a virtualenv name in it
    function nodeenv_cwd {
        if [ ! $NODEENV_CWD ]; then
            NODEENV_CWD=1
            # Check if this is a Git repo
            NODEENV_PROJECT_ROOT=`git rev-parse --show-toplevel 2> /dev/null`
            if (( $? != 0 )); then
                NODEENV_PROJECT_ROOT="."
            fi
            # Check for virtualenv name override
            if [[ -f "$NODEENV_PROJECT_ROOT/.nodeenv/bin/activate" ]];then
                NODEENV_NAME="$NODEENV_PROJECT_ROOT/.nodeenv"
            else
                NODEENV_NAME=""
            fi
            if [[ $NODEENV_NAME != "" ]]; then
                source $NODEENV_NAME/bin/activate && export CD_NODEENV="$NODEENV_NAME"
            elif [ $CD_NODEENV ]; then
                # We've just left the repo, deactivate the environment
                # Note: this only happens if the virtualenv was activated automatically
                deactivate_node && unset CD_NODEENV
            fi
            unset NODEENV_PROJECT_ROOT
            unset NODEENV_CWD
        fi
    }

    # Append workon_cwd to the chpwd_functions array, so it will be called on cd
    # http://zsh.sourceforge.net/Doc/Release/Functions.html
    # TODO: replace with 'add-zsh-hook chpwd workon_cwd' when oh-my-zsh min version is raised above 4.3.4
    if (( ${+chpwd_functions} )); then
        if (( $chpwd_functions[(I)nodeenv_cwd] == 0 )); then
            set -A chpwd_functions $chpwd_functions nodeenv_cwd
        fi
    else
        set -A chpwd_functions nodeenv_cwd
    fi
fi

#---------prompt-------------------
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
