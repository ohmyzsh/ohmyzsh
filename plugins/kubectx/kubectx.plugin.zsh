typeset -g -A kubectx_mapping

function _omz_kubectx_prompt_info() {
  (( $+commands[kubectl] )) || return

  local current_ctx=$(kubectl config current-context 2> /dev/null)

  [[ -n "$current_ctx" ]] || return

  # Use value in associative array if it exists, otherwise fall back to the context name
  #
  # Note: we need to escape the % character in the prompt string when coming directly from
  # the context name, as it could contain a % character.
  echo "${kubectx_mapping[$current_ctx]:-${current_ctx:gs/%/%%}}"
}

function kubectx_prompt_info() {
  if (( ${+_OMZ_ASYNC_OUTPUT} )) \
    && [[ -n "${_OMZ_ASYNC_OUTPUT[_omz_kubectx_prompt_info]-}" ]]; then
    echo -n "${_OMZ_ASYNC_OUTPUT[_omz_kubectx_prompt_info]}"
  fi
}

local _style
if zstyle -t ':omz:alpha:plugins:kubectx' async-prompt \
  || { is-at-least 5.0.6 && zstyle -T ':omz:alpha:plugins:kubectx' async-prompt }; then
  function _defer_async_kubectx_register() {
    case "${PS1}:${PS2}:${PS3}:${PS4}:${RPROMPT-}:${RPS1-}:${RPS2-}:${RPS3-}:${RPS4-}" in
    *(\$\(kubectx_prompt_info\)|\`kubectx_prompt_info\`)*)
      _omz_register_handler _omz_kubectx_prompt_info
      ;;
    esac

    add-zsh-hook -d precmd _defer_async_kubectx_register
    unset -f _defer_async_kubectx_register
  }

  autoload -Uz add-zsh-hook
  precmd_functions=(_defer_async_kubectx_register $precmd_functions)
elif zstyle -s ':omz:alpha:plugins:kubectx' async-prompt _style && [[ $_style == "force" ]]; then
  _omz_register_handler _omz_kubectx_prompt_info
else
  function kubectx_prompt_info() {
    _omz_kubectx_prompt_info
  }
fi
