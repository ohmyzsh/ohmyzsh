typeset -g -A kubectx_mapping

function kubectx_prompt_info() {
  (( $+commands[kubectl] )) || return

  local current_ctx=$(kubectl config current-context 2> /dev/null)

  [[ -n "$current_ctx" ]] || return

  # use value in associative array if it exists
  # otherwise fall back to the context name
  echo "${kubectx_mapping[$current_ctx]:-${current_ctx:gs/%/%%}}"
}
