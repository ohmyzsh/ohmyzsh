eval '
    function envu() {
        if [ -z "$1" ]; then
            echo "Usage: envu [ENV_VARIABLE_NAME] [VALUE]"
            return
        fi

        if [ "$1" = "PATH" ]; then
            echo -e "$1+=\":$2\"" >> "$ENVU_PATH/envs"
        else
            echo -e "$1+=\"$2\"" >> "$ENVU_PATH/envs"
        fi
        source "$ENVU_PATH/envs"
    }
'
