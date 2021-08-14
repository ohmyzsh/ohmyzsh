typeset -A kubectx_mapping

function kubectx_prompt_info() {
  if [ $commands[kubectl] ]; then
    local current_ctx=`kubectl config current-context`

    #if associative array declared
    if [[ -n $kubectx_mapping ]]; then
      echo "${kubectx_mapping[$current_ctx]}"
    else
      echo $current_ctx
    fi
  fi
}
