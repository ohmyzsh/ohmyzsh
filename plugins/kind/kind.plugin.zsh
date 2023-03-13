#!/bin/env bash

# Autocompletion for Kind.

## look for kind
__kind=kind
# shellcheck disable=SC2154
if (( ! $+commands[kind] )); then
    # shellcheck disable=SC2154
    (( ! $+commands[go] )) || unset __kind && return 1

    __kind="$(go env GOPATH)/bin/kind"
    [ -x "$__kind" ] && unset __kind && return 1
fi

## update and source completions file
__KIND_COMPLETION_FILE="${ZSH_CACHE_DIR}/kind_completion_$($__kind version | cut -d' ' -f2)"
for f in "${ZSH_CACHE_DIR}/kind_completion_"* ; do
    [ -f "$f" ] && [ "$f" != "$__KIND_COMPLETION_FILE" ] && rm -f "$f"
done

if [[ ! -f "$__KIND_COMPLETION_FILE" ]]; then
    "$__kind" completion zsh >! "$__KIND_COMPLETION_FILE"
    echo "compdef _kind kind" >> "$__KIND_COMPLETION_FILE"
fi

unset __kind

# shellcheck disable=SC1090
source "$__KIND_COMPLETION_FILE" || return 1

## register aliases
alias ckcc="kind create cluster"
alias ckccn="kind create cluster --name"
alias ckgc="kind get clusters"
alias ckdc="kind delete cluster"
alias ckdcn="kind delete cluster --name"
alias ckdca="kind delete clusters -A"
alias ckgk="kind get kubeconfig"

