#!/bin/zsh

# Kubernetes prompt helper for bash/zsh
# ported to oh-my-zsh
# Displays current context and namespace

# Copyright 2018 Jon Mosco
#
#  Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Debug
[[ -n $DEBUG ]] && set -x

setopt PROMPT_SUBST
autoload -U add-zsh-hook
add-zsh-hook precmd _kube_ps1_update_cache
zmodload zsh/stat
zmodload zsh/datetime

# Default values for the prompt
# Override these values in ~/.zshrc
KUBE_PS1_BINARY="${KUBE_PS1_BINARY:-kubectl}"
KUBE_PS1_SYMBOL_ENABLE="${KUBE_PS1_SYMBOL_ENABLE:-true}"
KUBE_PS1_SYMBOL_DEFAULT="${KUBE_PS1_SYMBOL_DEFAULT:-\u2388 }"
KUBE_PS1_SYMBOL_USE_IMG="${KUBE_PS1_SYMBOL_USE_IMG:-false}"
KUBE_PS1_NS_ENABLE="${KUBE_PS1_NS_ENABLE:-true}"
KUBE_PS1_SEPARATOR="${KUBE_PS1_SEPARATOR-|}"
KUBE_PS1_DIVIDER="${KUBE_PS1_DIVIDER-:}"
KUBE_PS1_PREFIX="${KUBE_PS1_PREFIX-(}"
KUBE_PS1_SUFFIX="${KUBE_PS1_SUFFIX-)}"
KUBE_PS1_LAST_TIME=0
KUBE_PS1_ENABLED=true

KUBE_PS1_COLOR_SYMBOL="%F{blue}"
KUBE_PS1_COLOR_CONTEXT="%F{red}"
KUBE_PS1_COLOR_NS="%F{cyan}"

_kube_ps1_binary_check() {
  command -v "$1" >/dev/null
}

_kube_ps1_symbol() {
  [[ "${KUBE_PS1_SYMBOL_ENABLE}" == false ]] && return

  KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_DEFAULT}"
  KUBE_PS1_SYMBOL_IMG="\u2638 "

  if [[ "${KUBE_PS1_SYMBOL_USE_IMG}" == true ]]; then
    KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_IMG}"
  fi

  echo "${KUBE_PS1_SYMBOL}"
}

_kube_ps1_split() {
  type setopt >/dev/null 2>&1 && setopt SH_WORD_SPLIT
  local IFS=$1
  echo $2
}

_kube_ps1_file_newer_than() {
  local mtime
  local file=$1
  local check_time=$2

  zmodload -e "zsh/stat"
  if [[ "$?" -eq 0 ]]; then
    mtime=$(stat +mtime "${file}")
  elif stat -c "%s" /dev/null &> /dev/null; then
    # GNU stat
    mtime=$(stat -c %Y "${file}")
  else
    # BSD stat
    mtime=$(stat -f %m "$file")
  fi

  [[ "${mtime}" -gt "${check_time}" ]]
}

_kube_ps1_update_cache() {
  KUBECONFIG="${KUBECONFIG:=$HOME/.kube/config}"
  if ! _kube_ps1_binary_check "${KUBE_PS1_BINARY}"; then
    # No ability to fetch context/namespace; display N/A.
    KUBE_PS1_CONTEXT="BINARY-N/A"
    KUBE_PS1_NAMESPACE="N/A"
    return
  fi

  if [[ "${KUBECONFIG}" != "${KUBE_PS1_KUBECONFIG_CACHE}" ]]; then
    # User changed KUBECONFIG; unconditionally refetch.
    KUBE_PS1_KUBECONFIG_CACHE=${KUBECONFIG}
    _kube_ps1_get_context_ns
    return
  fi

  # kubectl will read the environment variable $KUBECONFIG
  # otherwise set it to ~/.kube/config
  local conf
  for conf in $(_kube_ps1_split : "${KUBECONFIG:-${HOME}/.kube/config}"); do
    [[ -r "${conf}" ]] || continue
    if _kube_ps1_file_newer_than "${conf}" "${KUBE_PS1_LAST_TIME}"; then
      _kube_ps1_get_context_ns
      return
    fi
  done
}

_kube_ps1_get_context_ns() {

  # Set the command time
  KUBE_PS1_LAST_TIME=$EPOCHSECONDS

  KUBE_PS1_CONTEXT="$(${KUBE_PS1_BINARY} config current-context 2>/dev/null)"
  if [[ -z "${KUBE_PS1_CONTEXT}" ]]; then
    KUBE_PS1_CONTEXT="N/A"
    KUBE_PS1_NAMESPACE="N/A"
    return
  elif [[ "${KUBE_PS1_NS_ENABLE}" == true ]]; then
    KUBE_PS1_NAMESPACE="$(${KUBE_PS1_BINARY} config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
    # Set namespace to 'default' if it is not defined
    KUBE_PS1_NAMESPACE="${KUBE_PS1_NAMESPACE:-default}"
  fi
}

# function to disable the prompt on the current shell
kubeon(){
  KUBE_PS1_ENABLED=true
}

# function to disable the prompt on the current shell
kubeoff(){
  KUBE_PS1_ENABLED=false
}

# Build our prompt
kube_ps1 () {
  local reset_color="%{$reset_color%}"
  [[ ${KUBE_PS1_ENABLED} != 'true' ]] && return

  KUBE_PS1="${reset_color}$KUBE_PS1_PREFIX"
  KUBE_PS1+="${KUBE_PS1_COLOR_SYMBOL}$(_kube_ps1_symbol)"
  KUBE_PS1+="${reset_color}$KUBE_PS1_SEPERATOR"
  KUBE_PS1+="${KUBE_PS1_COLOR_CONTEXT}$KUBE_PS1_CONTEXT${reset_color}"
  KUBE_PS1+="$KUBE_PS1_DIVIDER"
  KUBE_PS1+="${KUBE_PS1_COLOR_NS}$KUBE_PS1_NAMESPACE${reset_color}"
  KUBE_PS1+="$KUBE_PS1_SUFFIX"

  echo "${KUBE_PS1}"
}
