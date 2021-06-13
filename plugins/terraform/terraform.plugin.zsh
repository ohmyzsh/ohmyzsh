function tf_prompt_info() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [[ -d .terraform && -r .terraform/environment  ]]; then
      workspace=$(cat .terraform/environment) || return
      echo "[${workspace}]"
    fi
}

alias tf='terraform'
