#!/bin/zsh

# Kubernetes prompt helper for bash/zsh
# Displays current context and namespace

# Copyright 2017 Jon Mosco
#
#  Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Debug
[[ -n $DEBUG ]] && set -x

setopt PROMPT_SUBST
add-zsh-hook precmd _kube_ps1_load
zmodload zsh/stat

# Default values for the prompt
# Override these values in ~/.zshrc or ~/.bashrc
KUBE_PS1_DEFAULT="${KUBE_PS1_DEFAULT:=true}"
KUBE_PS1_PREFIX="("
KUBE_PS1_DEFAULT_LABEL="${KUBE_PS1_DEFAULT_LABEL:="⎈ "}"
KUBE_PS1_DEFAULT_LABEL_IMG="${KUBE_PS1_DEFAULT_LABEL_IMG:=false}"
KUBE_PS1_SEPERATOR="|"
KUBE_PS1_PLATFORM="${KUBE_PS1_PLATFORM:="kubectl"}"
KUBE_PS1_DIVIDER=":"
KUBE_PS1_SUFFIX=")"
KUBE_PS1_UNAME=$(uname)
KUBE_PS1_LAST_TIME=0

kube_ps1_label () {

  [[ "${KUBE_PS1_DEFAULT_LABEL_IMG}" == false ]] && return

  if [[ "${KUBE_PS1_DEFAULT_LABEL_IMG}" == true ]]; then
    local KUBE_LABEL="☸️ "
  fi

  KUBE_PS1_DEFAULT_LABEL="${KUBE_LABEL}"

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
  mtime=$(stat +mtime "${file}")

  [ "${mtime}" -gt "${check_time}" ]

}

_kube_ps1_load() {
  # kubectl will read the environment variable $KUBECONFIG
  # otherwise set it to ~/.kube/config
  KUBECONFIG="${KUBECONFIG:=$HOME/.kube/config}"

  for conf in $(_kube_ps1_split : "${KUBECONFIG}"); do
    # TODO: check existence of $conf
    if _kube_ps1_file_newer_than "${conf}" "${KUBE_PS1_LAST_TIME}"; then
      _kube_ps1_get_context_ns
      return
    fi
  done
}

_kube_ps1_get_context_ns() {

  # Set the command time
  KUBE_PS1_LAST_TIME=$(date +%s)

  if [[ "${KUBE_PS1_DEFAULT}" == true ]]; then
    local KUBE_BINARY="${KUBE_PS1_PLATFORM}"
  elif [[ "${KUBE_PS1_DEFAULT}" == false ]] && [[ "${KUBE_PS1_PLATFORM}" == "kubectl" ]];then
    local KUBE_BINARY="kubectl"
  elif [[ "${KUBE_PS1_PLATFORM}" == "oc" ]]; then
    local KUBE_BINARY="oc"
  fi

  KUBE_PS1_CONTEXT="$(${KUBE_BINARY} config current-context)"
  KUBE_PS1_NAMESPACE="$(${KUBE_BINARY} config view --minify --output 'jsonpath={..namespace}')"
  # Set namespace to default if it is not defined
  KUBE_PS1_NAMESPACE="${KUBE_PS1_NAMESPACE:-default}"

}

# source our symbol
kube_ps1_label

# Build our prompt
kube_ps1 () {
  local reset_color="%f"
  local blue="%F{blue}"
  local red="%F{red}"
  local cyan="%F{cyan}"

  KUBE_PS1="${reset_color}$KUBE_PS1_PREFIX"
  KUBE_PS1+="${blue}$KUBE_PS1_DEFAULT_LABEL"
  KUBE_PS1+="${reset_color}$KUBE_PS1_SEPERATOR"
  KUBE_PS1+="${red}$KUBE_PS1_CONTEXT${reset_color}"
  KUBE_PS1+="$KUBE_PS1_DIVIDER"
  KUBE_PS1+="${cyan}$KUBE_PS1_NAMESPACE${reset_color}"
  KUBE_PS1+="$KUBE_PS1_SUFFIX"

  echo "${KUBE_PS1}"

}
