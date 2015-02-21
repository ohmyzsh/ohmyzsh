if [ -n "${ANACONDA_BASE+x}" ]; then
  if [[ ! $DISABLE_ANACONDA_CD -eq 1 ]]; then
    # Automatically activate Git projects's Anaconda Python environment based on the
    # directory name of the project. Anaconda environment name can be overridden
    # by placing a .aenv file in the project root with an environment name or full path in it
    function anaconda_cwd {
        if [ ! $ANACONDA_CWD ]; then
            ANACONDA_CWD=1
            # Check if this is a Git repo
            PROJECT_ROOT=`git rev-parse --show-toplevel 2> /dev/null`
            if (( $? != 0 )); then
                PROJECT_ROOT="."
            fi
            # Check for environment name override
            if [[ -f "$PROJECT_ROOT/.aenv" ]]; then
                AENV_HINT=`cat "$PROJECT_ROOT/.aenv"`
		if [[ -d "$ANACONDA_BASE/envs/$AENV_HINT" ]]; then
                   AENV_NAME=$AENV_HINT
		   AENV_PATH="$ANACONDA_BASE/envs/$AENV_HINT"
		elif [[ -d "$AENV_HINT" ]]; then
                   AENV_NAME=$AENV_HINT
		   AENV_PATH=`readlink -f $AENV_HINT`
		fi
            elif [[ "$PROJECT_ROOT" != "." && -d "$ANACONDA_BASE/envs/`basename \"$PROJECT_ROOT\"`" ]]; then
		AENV_PATH="$ANACONDA_BASE/envs/`basename \"$PROJECT_ROOT\"`"
                AENV_NAME=$AENV_PATH
            else
                AENV_NAME=""
            fi
            if [[ "$AENV_NAME" != "" ]]; then
                # Activate the environment only if it is not already active
                if [[ `readlink -f "$CONDA_DEFAULT_ENV"` != "$AENV_PATH" ]]; then
		    ANACONDA_SAVE_PROMPT=$PROMPT
                    source $AENV_PATH/bin/activate "$AENV_NAME" && export CD_ANACONDA_ENV="$AENV_PATH"
		    PROMPT=$ANACONDA_SAVE_PROMPT
		    # TODO: test with named Anaconda environments
		    # TODO: work-around conda deactivate bug regarding paths
		    # TODO: overload builtin 'cd' function
		    # see http://virtualenvwrapper.readthedocs.org/en/latest/tips.html#changing-the-default-behavior-of-cd
		    # currently not working in ZSH ...
                    ## cd () {
                    ##     if (( $# == 0 ))
                    ##     then
                    ##         builtin cd $VIRTUAL_ENV
                    ##     else
                    ##         builtin cd "$@"
                    ##     fi
                    ## }
		    # see http://virtualenvwrapper.readthedocs.org/en/latest/tips.html#updating-cached-path-entries
		    rehash
                fi
            elif [ $CD_ANACONDA_ENV ]; then
                # We've just left the repo, deactivate the environment
                # Note: this only happens if the virtualenv was activated automatically
                source $AENV_PATH/bin/deactivate && unset CD_ANACONDA_ENV
		PROMPT=$ANACONDA_SAVE_PROMPT
		# see http://virtualenvwrapper.readthedocs.org/en/latest/tips.html#updating-cached-path-entries
		rehash
            fi
            unset PROJECT_ROOT
            unset ANACONDA_CWD
            unset AENV_BASE
        fi
    }

    # Append anaconda_cwd to the chpwd_functions array, so it will be called on cd
    # http://zsh.sourceforge.net/Doc/Release/Functions.html
    # TODO: replace with 'add-zsh-hook chpwd anaconda_cwd' when oh-my-zsh min version is raised above 4.3.4
    if (( ${+chpwd_functions} )); then
        if (( $chpwd_functions[(I)anaconda_cwd] == 0 )); then
            set -A chpwd_functions $chpwd_functions anaconda_cwd
        fi
    else
        set -A chpwd_functions anaconda_cwd
    fi
  fi
else
  print "zsh anaconda plugin: Cannot find Anaconda installation. Please set the environment variable \`ANACONDA_BASE\`."
fi
