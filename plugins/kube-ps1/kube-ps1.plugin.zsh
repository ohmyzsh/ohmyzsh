#!/usr/bin/env bash

# Kubernetes prompt helper for bash/zsh
# Displays current context and namespace

# Copyright 2021 Jon Mosco
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

# Default values for the prompt
# Override these values in ~/.zshrc or ~/.bashrc
KUBE_PS1_BINARY="${KUBE_PS1_BINARY:-kubectl}"
KUBE_PS1_SYMBOL_ENABLE="${KUBE_PS1_SYMBOL_ENABLE:-true}"
KUBE_PS1_SYMBOL_DEFAULT=${KUBE_PS1_SYMBOL_DEFAULT:-$'\u2388'}
KUBE_PS1_SYMBOL_PADDING="${KUBE_PS1_SYMBOL_PADDING:-false}"
KUBE_PS1_SYMBOL_USE_IMG="${KUBE_PS1_SYMBOL_USE_IMG:-false}"
KUBE_PS1_NS_ENABLE="${KUBE_PS1_NS_ENABLE:-true}"
KUBE_PS1_CONTEXT_ENABLE="${KUBE_PS1_CONTEXT_ENABLE:-true}"
KUBE_PS1_PREFIX="${KUBE_PS1_PREFIX-(}"
KUBE_PS1_SEPARATOR="${KUBE_PS1_SEPARATOR-|}"
KUBE_PS1_DIVIDER="${KUBE_PS1_DIVIDER-:}"
KUBE_PS1_SUFFIX="${KUBE_PS1_SUFFIX-)}"

KUBE_PS1_SYMBOL_COLOR="${KUBE_PS1_SYMBOL_COLOR-blue}"
KUBE_PS1_CTX_COLOR="${KUBE_PS1_CTX_COLOR-red}"
KUBE_PS1_NS_COLOR="${KUBE_PS1_NS_COLOR-cyan}"
KUBE_PS1_BG_COLOR="${KUBE_PS1_BG_COLOR}"

KUBE_PS1_KUBECONFIG_CACHE="${KUBECONFIG}"
KUBE_PS1_KUBECONFIG_SYMLINK="${KUBE_PS1_KUBECONFIG_SYMLINK:-false}"
KUBE_PS1_DISABLE_PATH="${HOME}/.kube/kube-ps1/disabled"
KUBE_PS1_LAST_TIME=0
KUBE_PS1_CLUSTER_FUNCTION="${KUBE_PS1_CLUSTER_FUNCTION}"
KUBE_PS1_NAMESPACE_FUNCTION="${KUBE_PS1_NAMESPACE_FUNCTION}"

# Determine our shell
if [ "${ZSH_VERSION-}" ]; then
  KUBE_PS1_SHELL="zsh"
elif [ "${BASH_VERSION-}" ]; then
  KUBE_PS1_SHELL="bash"
fi

_kube_ps1_init() {
  [[ -f "${KUBE_PS1_DISABLE_PATH}" ]] && KUBE_PS1_ENABLED=off

  case "${KUBE_PS1_SHELL}" in
    "zsh")
      _KUBE_PS1_OPEN_ESC="%{"
      _KUBE_PS1_CLOSE_ESC="%}"
      _KUBE_PS1_DEFAULT_BG="%k"
      _KUBE_PS1_DEFAULT_FG="%f"
      setopt PROMPT_SUBST
      autoload -U add-zsh-hook
      add-zsh-hook precmd _kube_ps1_update_cache
      zmodload -F zsh/stat b:zstat
      zmodload zsh/datetime
      ;;
    "bash")
      _KUBE_PS1_OPEN_ESC=$'\001'
      _KUBE_PS1_CLOSE_ESC=$'\002'
      _KUBE_PS1_DEFAULT_BG=$'\033[49m'
      _KUBE_PS1_DEFAULT_FG=$'\033[39m'
      [[ $PROMPT_COMMAND =~ _kube_ps1_update_cache ]] || PROMPT_COMMAND="_kube_ps1_update_cache;${PROMPT_COMMAND:-:}"
      ;;
  esac
}

_kube_ps1_color_fg() {
  local KUBE_PS1_FG_CODE
  case "${1}" in
    black) KUBE_PS1_FG_CODE=0;;
    red) KUBE_PS1_FG_CODE=1;;
    green) KUBE_PS1_FG_CODE=2;;
    yellow) KUBE_PS1_FG_CODE=3;;
    blue) KUBE_PS1_FG_CODE=4;;
    magenta) KUBE_PS1_FG_CODE=5;;
    cyan) KUBE_PS1_FG_CODE=6;;
    white) KUBE_PS1_FG_CODE=7;;
    # 256
    [0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-6]) KUBE_PS1_FG_CODE="${1}";;
    *) KUBE_PS1_FG_CODE=default
  esac

  if [[ "${KUBE_PS1_FG_CODE}" == "default" ]]; then
    KUBE_PS1_FG_CODE="${_KUBE_PS1_DEFAULT_FG}"
    return
  elif [[ "${KUBE_PS1_SHELL}" == "zsh" ]]; then
    KUBE_PS1_FG_CODE="%F{$KUBE_PS1_FG_CODE}"
  elif [[ "${KUBE_PS1_SHELL}" == "bash" ]]; then
    if tput setaf 1 &> /dev/null; then
      KUBE_PS1_FG_CODE="$(tput setaf ${KUBE_PS1_FG_CODE})"
    elif [[ $KUBE_PS1_FG_CODE -ge 0 ]] && [[ $KUBE_PS1_FG_CODE -le 256 ]]; then
      KUBE_PS1_FG_CODE="\033[38;5;${KUBE_PS1_FG_CODE}m"
    else
      KUBE_PS1_FG_CODE="${_KUBE_PS1_DEFAULT_FG}"
    fi
  fi
  echo ${_KUBE_PS1_OPEN_ESC}${KUBE_PS1_FG_CODE}${_KUBE_PS1_CLOSE_ESC}
}

_kube_ps1_color_bg() {
  local KUBE_PS1_BG_CODE
  case "${1}" in
    black) KUBE_PS1_BG_CODE=0;;
    red) KUBE_PS1_BG_CODE=1;;
    green) KUBE_PS1_BG_CODE=2;;
    yellow) KUBE_PS1_BG_CODE=3;;
    blue) KUBE_PS1_BG_CODE=4;;
    magenta) KUBE_PS1_BG_CODE=5;;
    cyan) KUBE_PS1_BG_CODE=6;;
    white) KUBE_PS1_BG_CODE=7;;
    # 256
    [0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-4][0-9]|[2][5][0-6]) KUBE_PS1_BG_CODE="${1}";;
    *) KUBE_PS1_BG_CODE=$'\033[0m';;
  esac

  if [[ "${KUBE_PS1_BG_CODE}" == "default" ]]; then
    KUBE_PS1_FG_CODE="${_KUBE_PS1_DEFAULT_BG}"
    return
  elif [[ "${KUBE_PS1_SHELL}" == "zsh" ]]; then
    KUBE_PS1_BG_CODE="%K{$KUBE_PS1_BG_CODE}"
  elif [[ "${KUBE_PS1_SHELL}" == "bash" ]]; then
    if tput setaf 1 &> /dev/null; then
      KUBE_PS1_BG_CODE="$(tput setab ${KUBE_PS1_BG_CODE})"
    elif [[ $KUBE_PS1_BG_CODE -ge 0 ]] && [[ $KUBE_PS1_BG_CODE -le 256 ]]; then
      KUBE_PS1_BG_CODE="\033[48;5;${KUBE_PS1_BG_CODE}m"
    else
      KUBE_PS1_BG_CODE="${DEFAULT_BG}"
    fi
  fi
  echo ${OPEN_ESC}${KUBE_PS1_BG_CODE}${CLOSE_ESC}
}

_kube_ps1_binary_check() {
  command -v $1 >/dev/null
}

_kube_ps1_symbol() {
  [[ "${KUBE_PS1_SYMBOL_ENABLE}" == false ]] && return

  case "${KUBE_PS1_SHELL}" in
    bash)
      if ((BASH_VERSINFO[0] >= 4)) && [[ $'\u2388' != "\\u2388" ]]; then
        KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_DEFAULT}"
        KUBE_PS1_SYMBOL_IMG=$'\u2638\ufe0f'
      else
        KUBE_PS1_SYMBOL=$'\xE2\x8E\x88'
        KUBE_PS1_SYMBOL_IMG=$'\xE2\x98\xB8'
      fi
      ;;
    zsh)
      KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_DEFAULT}"
      KUBE_PS1_SYMBOL_IMG="\u2638";;
    *)
      KUBE_PS1_SYMBOL="k8s"
  esac

  if [[ "${KUBE_PS1_SYMBOL_USE_IMG}" == true ]]; then
    KUBE_PS1_SYMBOL="${KUBE_PS1_SYMBOL_IMG}"
  fi

  if [[ "${KUBE_PS1_SYMBOL_PADDING}" == true ]]; then
    echo "${KUBE_PS1_SYMBOL} "
  else
    echo "${KUBE_PS1_SYMBOL}"
  fi

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

  if [[ "${KUBE_PS1_KUBECONFIG_SYMLINK}" == "true" ]]; then
    if [[ "${KUBE_PS1_SHELL}" == "zsh" ]]; then
      mtime=$(zstat -L +mtime "${file}")
    elif stat -c "%s" /dev/null &> /dev/null; then
      # GNU stat
      mtime=$(stat -c %Y "${file}")
    else
      # BSD stat
      mtime=$(stat -f %m "$file")
    fi
  else
    if [[ "${KUBE_PS1_SHELL}" == "zsh" ]]; then
      mtime=$(zstat +mtime "${file}")
    elif stat -c "%s" /dev/null &> /dev/null; then
      # GNU stat
      mtime=$(stat -L -c %Y "${file}")
    else
      # BSD stat
      mtime=$(stat -L -f %m "$file")
    fi
  fi

  [[ "${mtime}" -gt "${check_time}" ]]
}

_kube_ps1_update_cache() {
  local return_code=$?

  [[ "${KUBE_PS1_ENABLED}" == "off" ]] && return $return_code

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

  return $return_code
}

_kube_ps1_get_context() {
  if [[ "${KUBE_PS1_CONTEXT_ENABLE}" == true ]]; then
    KUBE_PS1_CONTEXT="$(${KUBE_PS1_BINARY} config current-context 2>/dev/null)"
    # Set namespace to 'N/A' if it is not defined
    KUBE_PS1_CONTEXT="${KUBE_PS1_CONTEXT:-N/A}"

    if [[ ! -z "${KUBE_PS1_CLUSTER_FUNCTION}" ]]; then
      KUBE_PS1_CONTEXT=$($KUBE_PS1_CLUSTER_FUNCTION $KUBE_PS1_CONTEXT)
    fi
  fi
}

_kube_ps1_get_ns() {
  if [[ "${KUBE_PS1_NS_ENABLE}" == true ]]; then
    KUBE_PS1_NAMESPACE="$(${KUBE_PS1_BINARY} config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
    # Set namespace to 'default' if it is not defined
    KUBE_PS1_NAMESPACE="${KUBE_PS1_NAMESPACE:-default}"

    if [[ ! -z "${KUBE_PS1_NAMESPACE_FUNCTION}" ]]; then
        KUBE_PS1_NAMESPACE=$($KUBE_PS1_NAMESPACE_FUNCTION $KUBE_PS1_NAMESPACE)
    fi
  fi
}

_kube_ps1_get_context_ns() {
  # Set the command time
  if [[ "${KUBE_PS1_SHELL}" == "bash" ]]; then
    if ((BASH_VERSINFO[0] >= 4 && BASH_VERSINFO[1] >= 2)); then
      KUBE_PS1_LAST_TIME=$(printf '%(%s)T')
    else
      KUBE_PS1_LAST_TIME=$(date +%s)
    fi
  elif [[ "${KUBE_PS1_SHELL}" == "zsh" ]]; then
    KUBE_PS1_LAST_TIME=$EPOCHSECONDS
  fi

  _kube_ps1_get_context
  _kube_ps1_get_ns
}

# Set kube-ps1 shell defaults
_kube_ps1_init

_kubeon_usage() {
  cat <<"EOF"
Toggle kube-ps1 prompt on

Usage: kubeon [-g | --global] [-h | --help]

With no arguments, turn off kube-ps1 status for this shell instance (default).

  -g --global  turn on kube-ps1 status globally
  -h --help    print this message
EOF
}

_kubeoff_usage() {
  cat <<"EOF"
Toggle kube-ps1 prompt off

Usage: kubeoff [-g | --global] [-h | --help]

With no arguments, turn off kube-ps1 status for this shell instance (default).

  -g --global turn off kube-ps1 status globally
  -h --help   print this message
EOF
}

kubeon() {
  if [[ "${1}" == '-h' || "${1}" == '--help' ]]; then
    _kubeon_usage
  elif [[ "${1}" == '-g' || "${1}" == '--global' ]]; then
    rm -f -- "${KUBE_PS1_DISABLE_PATH}"
  elif [[ "$#" -ne 0 ]]; then
    echo -e "error: unrecognized flag ${1}\\n"
    _kubeon_usage
    return
  fi

  KUBE_PS1_ENABLED=on
}

kubeoff() {
  if [[ "${1}" == '-h' || "${1}" == '--help' ]]; then
    _kubeoff_usage
  elif [[ "${1}" == '-g' || "${1}" == '--global' ]]; then
    mkdir -p -- "$(dirname "${KUBE_PS1_DISABLE_PATH}")"
    touch -- "${KUBE_PS1_DISABLE_PATH}"
  elif [[ $# -ne 0 ]]; then
    echo "error: unrecognized flag ${1}" >&2
    _kubeoff_usage
    return
  fi

  KUBE_PS1_ENABLED=off
}

# Build our prompt
kube_ps1() {
  [[ "${KUBE_PS1_ENABLED}" == "off" ]] && return
  [[ -z "${KUBE_PS1_CONTEXT}" ]] && [[ "${KUBE_PS1_CONTEXT_ENABLE}" == true ]] && return

  local KUBE_PS1
  local KUBE_PS1_RESET_COLOR="${_KUBE_PS1_OPEN_ESC}${_KUBE_PS1_DEFAULT_FG}${_KUBE_PS1_CLOSE_ESC}"

  # Background Color
  [[ -n "${KUBE_PS1_BG_COLOR}" ]] && KUBE_PS1+="$(_kube_ps1_color_bg ${KUBE_PS1_BG_COLOR})"

  # Prefix
  if [[ -z "${KUBE_PS1_PREFIX_COLOR:-}" ]] && [[ -n "${KUBE_PS1_PREFIX}" ]]; then
      KUBE_PS1+="${KUBE_PS1_PREFIX}"
  else
      KUBE_PS1+="$(_kube_ps1_color_fg $KUBE_PS1_PREFIX_COLOR)${KUBE_PS1_PREFIX}${KUBE_PS1_RESET_COLOR}"
  fi

  # Symbol
  KUBE_PS1+="$(_kube_ps1_color_fg $KUBE_PS1_SYMBOL_COLOR)$(_kube_ps1_symbol)${KUBE_PS1_RESET_COLOR}"

  if [[ -n "${KUBE_PS1_SEPARATOR}" ]] && [[ "${KUBE_PS1_SYMBOL_ENABLE}" == true ]]; then
    KUBE_PS1+="${KUBE_PS1_SEPARATOR}"
  fi

  # Context
  if [[ "${KUBE_PS1_CONTEXT_ENABLE}" == true ]]; then
    KUBE_PS1+="$(_kube_ps1_color_fg $KUBE_PS1_CTX_COLOR)${KUBE_PS1_CONTEXT}${KUBE_PS1_RESET_COLOR}"
  fi

  # Namespace
  if [[ "${KUBE_PS1_NS_ENABLE}" == true ]]; then
    if [[ -n "${KUBE_PS1_DIVIDER}" ]] && [[ "${KUBE_PS1_CONTEXT_ENABLE}" == true ]]; then
      KUBE_PS1+="${KUBE_PS1_DIVIDER}"
    fi
    KUBE_PS1+="$(_kube_ps1_color_fg ${KUBE_PS1_NS_COLOR})${KUBE_PS1_NAMESPACE}${KUBE_PS1_RESET_COLOR}"
  fi

  # Suffix
  if [[ -z "${KUBE_PS1_SUFFIX_COLOR:-}" ]] && [[ -n "${KUBE_PS1_SUFFIX}" ]]; then
      KUBE_PS1+="${KUBE_PS1_SUFFIX}"
  else
      KUBE_PS1+="$(_kube_ps1_color_fg $KUBE_PS1_SUFFIX_COLOR)${KUBE_PS1_SUFFIX}${KUBE_PS1_RESET_COLOR}"
  fi

  # Close Background color if defined
  [[ -n "${KUBE_PS1_BG_COLOR}" ]] && KUBE_PS1+="${_KUBE_PS1_OPEN_ESC}${_KUBE_PS1_DEFAULT_BG}${_KUBE_PS1_CLOSE_ESC}"

  echo "${KUBE_PS1}"
}
