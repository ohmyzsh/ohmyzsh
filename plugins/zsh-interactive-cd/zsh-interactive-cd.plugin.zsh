#!/usr/bin/env zsh
#
# Copyright 2017-2018 Henry Chang
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

__zic_fzf_prog() {
  [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ] \
    && echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
}

__zic_matched_subdir_list() {
  local dir length seg starts_with_dir
  if [[ "$1" == */ ]]; then
    dir="$1"
    if [[ "$dir" != / ]]; then
      dir="${dir: : -1}"
    fi
    length=$(echo -n "$dir" | wc -c)
    if [ "$dir" = "/" ]; then
      length=0
    fi
    find -L "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
        | cut -b $(( ${length} + 2 ))- | command sed '/^$/d' | while read -r line; do
      if [[ "${line[1]}" == "." ]]; then
        continue
      fi
      echo "$line"
    done
  else
    dir=$(dirname -- "$1")
    length=$(echo -n "$dir" | wc -c)
    if [ "$dir" = "/" ]; then
      length=0
    fi
    seg=$(basename -- "$1")
    starts_with_dir=$( \
      find -L "$dir" -mindepth 1 -maxdepth 1 -type d \
          2>/dev/null | cut -b $(( ${length} + 2 ))- | command sed '/^$/d' \
          | while read -r line; do
        if [[ "${seg[1]}" != "." && "${line[1]}" == "." ]]; then
          continue
        fi
        if [ "$zic_case_insensitive" = "true" ]; then
          if [[ "$line:u" == "$seg:u"* ]]; then
            echo "$line"
          fi
        else
          if [[ "$line" == "$seg"* ]]; then
            echo "$line"
          fi
        fi
      done
    )
    if [ -n "$starts_with_dir" ]; then
      echo "$starts_with_dir"
    else
      find -L "$dir" -mindepth 1 -maxdepth 1 -type d \
          2>/dev/null | cut -b $(( ${length} + 2 ))- | command sed '/^$/d' \
          | while read -r line; do
        if [[ "${seg[1]}" != "." && "${line[1]}" == "." ]]; then
          continue
        fi
        if [ "$zic_case_insensitive" = "true" ]; then
          if [[ "$line:u" == *"$seg:u"* ]]; then
            echo "$line"
          fi
        else
          if [[ "$line" == *"$seg"* ]]; then
            echo "$line"
          fi
        fi
      done
    fi
  fi
}

__zic_fzf_bindings() {
  autoload is-at-least
  fzf=$(__zic_fzf_prog)

  if $(is-at-least '0.21.0' $(${=fzf} --version)); then
    echo 'shift-tab:up,tab:down,bspace:backward-delete-char/eof'
  else
    echo 'shift-tab:up,tab:down'
  fi
}

_zic_list_generator() {
  __zic_matched_subdir_list "${(Q)@[-1]}" | sort
}

_zic_complete() {
  setopt localoptions nonomatch
  local l matches fzf tokens base

  l=$(_zic_list_generator $@)

  if [ -z "$l" ]; then
    zle ${__zic_default_completion:-expand-or-complete}
    return
  fi

  fzf=$(__zic_fzf_prog)
  fzf_bindings=$(__zic_fzf_bindings)

  if [ $(echo $l | wc -l) -eq 1 ]; then
    matches=${(q)l}
  else
    matches=$(echo $l \
        | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} \
          --reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS \
          --bind '${fzf_bindings}'" ${=fzf} \
        | while read -r item; do
      echo -n "${(q)item} "
    done)
  fi

  matches=${matches% }
  if [ -n "$matches" ]; then
    tokens=(${(z)LBUFFER})
    base="${(Q)@[-1]}"
    if [[ "$base" != */ ]]; then
      if [[ "$base" == */* ]]; then
        base="$(dirname -- "$base")"
        if [[ ${base[-1]} != / ]]; then
          base="$base/"
        fi
      else
        base=""
      fi
    fi
    LBUFFER="${tokens[1]} "
    if [ -n "$base" ]; then
      base="${(q)base}"
      if [ "${tokens[2][1]}" = "~" ]; then
        base="${base/#$HOME/~}"
      fi
      LBUFFER="${LBUFFER}${base}"
    fi
    LBUFFER="${LBUFFER}${matches}/"
  fi
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
}

zic-completion() {
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
  local tokens cmd

  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}

  if [[ "$LBUFFER" =~ "^\ *cd$" ]]; then
    zle ${__zic_default_completion:-expand-or-complete}
  elif [ "$cmd" = cd ]; then
    _zic_complete ${tokens[2,${#tokens}]/#\~/$HOME}
  else
    zle ${__zic_default_completion:-expand-or-complete}
  fi
}

[ -z "$__zic_default_completion" ] && {
  binding=$(bindkey '^I')
  # $binding[(s: :w)2]
  # The command substitution and following word splitting to determine the
  # default zle widget for ^I formerly only works if the IFS parameter contains
  # a space via $binding[(w)2]. Now it specifically splits at spaces, regardless
  # of IFS.
  [[ $binding =~ 'undefined-key' ]] || __zic_default_completion=$binding[(s: :w)2]
  unset binding
}

zle -N zic-completion
if [ -z $zic_custom_binding ]; then
  zic_custom_binding='^I'
fi
bindkey "${zic_custom_binding}" zic-completion
