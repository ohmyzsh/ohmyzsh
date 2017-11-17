function tf_prompt_info() {
    RESET="%{${reset_color}%}"

    # check if in terraform dir
    if [ -d .terraform ]; then
      workspace=$(terraform workspace show 2> /dev/null) || return
      TF_INFO="$RESET%{$fg_bold[blue]%}tf:(%{$fg_bold[magenta]%}$workspace%{$fg_bold[blue]%})$RESET "
      echo "$TF_INFO"
    fi
}
