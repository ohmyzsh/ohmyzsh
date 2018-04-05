function tf_prompt_info() {
    # check if in terraform dir
    if [ -d .terraform ]; then
      workspace=$(terraform workspace show 2> /dev/null) || return
      echo "[${workspace}]"
    fi
}

if [ $commands[terraform] ]; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C terraform terraform
fi
