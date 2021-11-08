# Copyright 2017-2020 Ilya Arkhanhelsky (https://github.com/iarkhanhelsky)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Updates hg root
function update_hg_root() {
  local path=$(pwd)
  while [[ $path != "/" && ( ! -d "$path/.hg" ) ]]; do
    local v="$path/.."
    path=$v:A
  done

  if [[ $path != "/" ]]; then
    HG_ROOT=$path
  else
    HG_ROOT="" # hg repository not found
  fi
}

function preexec_update_hg_root() {
    case "$2" in
        hg*)
        __EXECUTED_HG_COMMAND=1
        ;;
    esac
}

function precmd_update_hg_root() {
    if [ -n "$__EXECUTED_HG_COMMAND" ]; then
        update_hg_root
        unset __EXECUTED_HG_COMMAND
    fi
}

# Will update hg root every time user changes dir.
# This approach fast but doesn't work with some corner
# cases:
# - user deletes .hg  directory.

# Only one function
if  [[ ${chpwd_functions[(r)update_hg_root]} != update_hg_root ]]; then
  chpwd_functions+=(update_hg_root)
fi

if [[ ${precmd_functions[(r)precmd_update_hg_root]} != precmd_update_hg_root ]]; then
  precmd_functions+=(precmd_update_hg_root)
fi

if [[ ${preexec_functions[(r)preexec_update_hg_root]} != preexec_update_hg_root ]]; then
  preexec_functions+=(preexec_update_hg_root)
fi

function hg_branch() {
    if [[ -n $HG_ROOT ]]; then
        local current_file="$HG_ROOT/.hg/branch"
        if [[ "$ZSH_THEME_HG_PROMPT_USE_BOOKMARK" == "true" ]]; then
          current_file="$HG_ROOT/.hg/bookmarks.current"
        fi
        local branch=$(cat "$current_file" 2> /dev/null)
        if [[ -n $branch ]]; then
          echo $branch
        else
          # After creation of empty repository branch technicaly
          # is `default`. But .hg/branch is not created until
          # hg up -C will be run.
          echo "default"
        fi
    fi
}

function hg_prompt_info() {
    if [[ -n $HG_ROOT ]]; then
        echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_HG_PROMPT_TAG$ZSH_THEME_HG_PROMPT_PREFIX$ZSH_THEME_HG_PROMPT_BRANCH_COLOR$(hg_branch)$ZSH_THEME_HG_PROMPT_COLOR$ZSH_THEME_HG_PROMPT_SUFFIX%{${reset_color}%}"
    fi
}

# Default values for the appearance of the prompt.
ZSH_PROMPT_BASE_COLOR="%{${fg_bold[blue]}%}"
ZSH_THEME_HG_PROMPT_TAG="hg"
ZSH_THEME_HG_PROMPT_PREFIX=":"
ZSH_THEME_HG_PROMPT_SUFFIX=""
ZSH_THEME_HG_PROMPT_SEPARATOR="|"
ZSH_THEME_HG_PROMPT_BRANCH_COLOR="%{$fg_bold[magenta]%}"
