setopt prompt_subst
autoload -U add-zsh-hook

function() {
    local namespace separator binary

    # Specify the separator between context and namespace
    zstyle -s ':zsh-kubectl-prompt:' separator separator
    if [[ -z "$separator" ]]; then
        zstyle ':zsh-kubectl-prompt:' separator '/'
    fi

    # Display the current namespace if `namespace` is true
    zstyle -s ':zsh-kubectl-prompt:' namespace namespace
    if [[ -z "$namespace" ]]; then
        zstyle ':zsh-kubectl-prompt:' namespace true
    fi

    # Specify the binary to get the information from kubeconfig (e.g. `oc`)
    zstyle -s ':zsh-kubectl-binary:' binary binary
    if [[ -z "$binary" ]]; then
        zstyle ':zsh-kubectl-prompt:' binary "kubectl"
    fi
}

add-zsh-hook precmd _zsh_kubectl_prompt_precmd
function _zsh_kubectl_prompt_precmd() {
    local kubeconfig config updated_at now context namespace ns separator modified_time_fmt binary

    zstyle -s ':zsh-kubectl-prompt:' binary binary
    if ! command -v "$binary" >/dev/null; then
      ZSH_KUBECTL_PROMPT="${binary} command not found"
      return 1
    fi

    kubeconfig="$HOME/.kube/config"
    if [[ -n "$KUBECONFIG" ]]; then
        kubeconfig="$KUBECONFIG"
    fi

    zstyle -s ':zsh-kubectl-prompt:' modified_time_fmt modified_time_fmt
    if [[ -z "$modified_time_fmt" ]]; then
      # Check the stat command because it has a different syntax between GNU coreutils and FreeBSD.
      if stat --help >/dev/null 2>&1; then
          modified_time_fmt='-c%y' # GNU coreutils
      else
          modified_time_fmt='-f%m' # FreeBSD
      fi
      zstyle ':zsh-kubectl-prompt:' modified_time_fmt $modified_time_fmt
    fi

    # KUBECONFIG environment variable can hold a list of kubeconfig files that is colon-delimited.
    # Therefore, if KUBECONFIG has been held multiple files, each files need to be checked.
    while read -d ":" config; do
        if ! now="${now}$(stat -L $modified_time_fmt "$config" 2>/dev/null)"; then
            ZSH_KUBECTL_PROMPT="$config doesn't exist"
            return 1
        fi
    done <<< "${kubeconfig}:"

    zstyle -s ':zsh-kubectl-prompt:' updated_at updated_at
    if [[ "$updated_at" == "$now" ]]; then
        return 0
    fi
    zstyle ':zsh-kubectl-prompt:' updated_at "$now"

    # Set environment variable if context is not set
    if ! context="$("$binary" config current-context 2>/dev/null)"; then
        ZSH_KUBECTL_PROMPT="current-context is not set"
        return 1
    fi

    ZSH_KUBECTL_USER="$("$binary" config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.user}")"
    ZSH_KUBECTL_CONTEXT="${context}"
    ns="$("$binary" config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}")"
    [[ -z "$ns" ]] && ns="default"
    ZSH_KUBECTL_NAMESPACE="${ns}"

    function ZSH_K8S() {
        local color="white"

        if [[ "$ZSH_KUBECTL_CONTEXT" =~ "vmw-dev" ]]; then
            color=blue
        fi
        if [[ "$ZSH_KUBECTL_CONTEXT" =~ "gcp-stg" ]]; then
            color=yellow
        fi
        if [[ "$ZSH_KUBECTL_CONTEXT" =~ "gcp-prd" ]]; then
            color=red
        fi
        echo "%{$fg[$color]%}$ZSH_KUBECTL_CONTEXT/$ZSH_KUBECTL_NAMESPACE%{$reset_color%}"
    }

    # Specify the entry before prompt (default empty)
    zstyle -s ':zsh-kubectl-prompt:' preprompt preprompt
    # Specify the entry after prompt (default empty)
    zstyle -s ':zsh-kubectl-prompt:' postprompt postprompt

    # Set environment variable without namespace
    zstyle -s ':zsh-kubectl-prompt:' namespace namespace
    if [[ "$namespace" != true ]]; then
        ZSH_KUBECTL_PROMPT="${preprompt}${context}${postprompt}"
        return 0
    fi

    zstyle -s ':zsh-kubectl-prompt:' separator separator
    ZSH_KUBECTL_PROMPT="${preprompt}${context}${separator}${ns}${postprompt}"

    return 0
}