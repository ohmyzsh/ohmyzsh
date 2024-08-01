typeset -g -A kubectx_mapping

function kubectx_prompt_info() {
  (( $+commands[kubectl] )) || return

  local current_ctx=$(kubectl config current-context 2> /dev/null)

  [[ -n "$current_ctx" ]] || return

  # Use value in associative array if it exists, otherwise fall back to the context name
  #
  # Note: we need to escape the % character in the prompt string when coming directly from
  # the context name, as it could contain a % character.
  echo "${kubectx_mapping[$current_ctx]:-${current_ctx:gs/%/%%}}"
}
