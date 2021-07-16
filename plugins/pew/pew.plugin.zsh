
if type pew > /dev/null; then
    # Use the completion already shipped by the python package
    shell_config_path=$(dirname $(pew shell_config))

    fpath+=$shell_config_path
    compinit
else
    echo "`pew` command seems to not exist. Check that it is available in your PATH"
fi
