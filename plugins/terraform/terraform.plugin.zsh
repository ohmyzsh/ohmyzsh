function tf_prompt_info() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [ -d .terraform ]; then
      workspace=$(terraform workspace show 2> /dev/null) || return
      echo "${ZSH_THEME_TF_PROMPT_PREFIX}${workspace}${ZSH_THEME_TF_PROMPT_SUFFIX}"
    fi
}
