#!/bin/zsh

# GCP prompt helper for zsh
# ported to oh-my-zsh
# Displays current configuration
#
# Author: Marcin Niemira
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
add-zsh-hook precmd _gcp_ps1_update_cache


GCP_PS1_COLOR_SYMBOL="%{$fg[blue]%}"
GCP_PS1_COLOR_NS="%{$fg[cyan]%}"

_gcp_ps1_symbol() {
  echo "☁️  "
}

_gcp_ps1_update_cache() {
  CONTEXT=$(cat "$HOME/.config/gcloud/active_config")
}

gcp_ps1 () {
  local reset_color="%{$reset_color%}"

  GCP_PS1="${reset_color}("
  GCP_PS1+="$(_gcp_ps1_symbol)"
  GCP_PS1+="${GCP_PS1_COLOR_SYMBOL}$CONTEXT${reset_color}"
  GCP_PS1+=")${reset_color}"

  echo "${GCP_PS1}"
}
