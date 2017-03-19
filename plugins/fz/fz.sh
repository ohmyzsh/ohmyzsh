[[ -n "$FZ_CMD" ]] || FZ_CMD=z
[[ -n "$FZ_SUBDIR_CMD" ]] || FZ_SUBDIR_CMD=zz

[[ -n "$FZ_HISTORY_CD_CMD" ]] || FZ_HISTORY_CD_CMD=_z
[[ -n "$FZ_SUBDIR_HISTORY_CD_CMD" ]] || FZ_SUBDIR_HISTORY_CD_CMD="_z -c"

[[ -n "$FZ_HISTORY_LIST_GENERATOR" ]] \
  || FZ_HISTORY_LIST_GENERATOR=__fz_generate_matched_history_list
[[ -n "$FZ_SUBDIR_HISTORY_LIST_GENERATOR" ]] \
  || FZ_SUBDIR_HISTORY_LIST_GENERATOR=__fz_generate_matched_subdir_history_list

[[ -n "$FZ_SUBDIR_TRAVERSAL" ]] || FZ_SUBDIR_TRAVERSAL=1
[[ -n "$FZ_CASE_INSENSITIVE" ]] || FZ_CASE_INSENSITIVE=1
[[ -n "$FZ_ABBREVIATE_HOME" ]] || FZ_ABBREVIATE_HOME=1

alias ${FZ_CMD}='_fz'
alias ${FZ_SUBDIR_CMD}='_fzz'

__fz_generate_matched_subdir_list() {
  local dir seg starts_with_dir
  if [[ "$1" == */ ]]; then
    dir="$1"
    find -L "$(cd "$dir" 2>/dev/null && pwd)" -mindepth 1 -maxdepth 1 -type d \
        2>/dev/null | while read -r line; do
      base="${line##*/}"
      if [[ "$base" == .* ]]; then
        continue
      fi
      echo "$line"
    done
  else
    dir=$(dirname -- "$1")
    seg=$(basename -- "$1")
    if [[ "$FZ_CASE_INSENSITIVE" == "1" ]]; then
      seg=$(echo "$seg" | tr '[:upper:]' '[:lower:]')
    fi
    starts_with_dir=$( \
      find -L "$(cd "$dir" 2>/dev/null && pwd)" -mindepth 1 -maxdepth 1 \
          -type d 2>/dev/null | while read -r line; do \
        base="${line##*/}"
        if [[ "$seg" != .* && "$base" == .* ]]; then
          continue
        fi
        if [[ "$FZ_CASE_INSENSITIVE" != "1" ]]; then
          if [[ "$base" == "$seg"* ]]; then
            echo "$line"
          fi
        else
          if [[ -n "$BASH_VERSION" ]]; then
            if [[ "${base,,}" == "${seg,,}"* ]]; then
              echo "$line"
            fi
          elif [[ -n "$ZSH_VERSION" ]]; then
            if [[ "${base:l}" == "${seg:l}"* ]]; then
              echo "$line"
            fi
          fi
        fi
      done
    )
    if [ -n "$starts_with_dir" ]; then
      echo "$starts_with_dir"
    else
      find -L "$(cd "$dir" 2>/dev/null && pwd)" -mindepth 1 -maxdepth 1 \
          -type d 2>/dev/null | while read -r line; do \
        base="${line##*/}"
        if [[ "$seg" != .* && "$base" == .* ]]; then
          continue
        fi
        if [[ "$FZ_CASE_INSENSITIVE" != "1" ]]; then
          if [[ "$base" == *"$seg"* ]]; then
            echo "$line"
          fi
        else
          if [[ -n "$BASH_VERSION" ]]; then
            if [[ "${base,,}" == *"${seg,,}"* ]]; then
              echo "$line"
            fi
          elif [[ -n "$ZSH_VERSION" ]]; then
            if [[ "${base:l}" == *"${seg:l}"* ]]; then
              echo "$line"
            fi
          fi
        fi
      done
    fi
  fi
}

__fz_generate_matched_history_list() {
  _z -l $@ 2>&1 | while read -r line; do
    if [[ "$line" == common:* ]]; then continue; fi
    # Reverse the order and cut off the scores
    echo "$line"
  done | sed '1!G;h;$!d' | cut -b 12-
}

__fz_generate_matched_subdir_history_list() {
  __fz_generate_matched_history_list -c "$@"
}

__fz_generate_matches() {
  local cmd histories subdirs

  if [[ -n "$BASH_VERSION" ]]; then
    cmd=$([[ "${COMP_WORDS[0]}" =~ [[:space:]]*([^[:space:]]|[^[:space:]].*[^[:space:]])[[:space:]]* ]]; \
      echo -n "${BASH_REMATCH[1]}")
  elif [[ -n "$ZSH_VERSION" ]]; then
    cmd=(${(z)LBUFFER})
    cmd=${cmd[1]}
  fi

  if [[ "$cmd" == "$FZ_CMD" ]]; then
    if [[ "$FZ_ABBREVIATE_HOME" == "1" ]]; then
      if [ "$FZ_SUBDIR_TRAVERSAL" == "1" ]; then
        cat <("$FZ_HISTORY_LIST_GENERATOR" "$@") \
          <(__fz_generate_matched_subdir_list "$@") \
          | sed '/^$/d' | sed -e "s,^$HOME,~," | awk '!seen[$0]++'
      else
        cat <("$FZ_HISTORY_LIST_GENERATOR" "$@") \
          | sed '/^$/d' | sed -e "s,^$HOME,~," | awk '!seen[$0]++'
      fi
    else
      if [ "$FZ_SUBDIR_TRAVERSAL" == "1" ]; then
        cat <("$FZ_HISTORY_LIST_GENERATOR" "$@") \
          <(__fz_generate_matched_subdir_list "$@") \
          | sed '/^$/d' | awk '!seen[$0]++'
      else
        cat <("$FZ_HISTORY_LIST_GENERATOR" "$@") \
          | sed '/^$/d' | awk '!seen[$0]++'
      fi
    fi
  elif [[ "$cmd" == "$FZ_SUBDIR_CMD" ]]; then
    histories=$("$FZ_SUBDIR_HISTORY_LIST_GENERATOR" "$@")
    if [[ "$FZ_ABBREVIATE_HOME" == "1" ]]; then
      if [ "$FZ_SUBDIR_TRAVERSAL" == "1" ]; then
        cat <("$FZ_SUBDIR_HISTORY_LIST_GENERATOR" "$@") \
          <(__fz_generate_matched_subdir_list "$@") \
          | sed '/^$/d' | sed -e "s,^$HOME,~," | awk '!seen[$0]++'
      else
        cat <("$FZ_SUBDIR_HISTORY_LIST_GENERATOR" "$@") \
          | sed '/^$/d' | sed -e "s,^$HOME,~," | awk '!seen[$0]++'
      fi
    else
      if [ "$FZ_SUBDIR_TRAVERSAL" == "1" ]; then
        cat <("$FZ_SUBDIR_HISTORY_LIST_GENERATOR" "$@") \
          <(__fz_generate_matched_subdir_list "$@") \
          | sed '/^$/d' | awk '!seen[$0]++'
      else
        cat <("$FZ_SUBDIR_HISTORY_LIST_GENERATOR" "$@") \
          | sed '/^$/d' | awk '!seen[$0]++'
      fi
    fi
  fi
}

__fz_bash_completion() {
  COMPREPLY=()

  local selected slug
  eval "slug=${COMP_WORDS[@]:(-1)}"

  if [[ "$(__fz_generate_matches "$slug" | head | wc -l)" -gt 1 ]]; then
    selected=$(__fz_generate_matches "$slug" \
      | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse \
      --bind 'shift-tab:up,tab:down' $FZF_DEFAULT_OPTS" fzf)
  elif [[ "$(__fz_generate_matches "$slug" | head | wc -l)" -eq 1 ]]; then
    selected=$(__fz_generate_matches "$slug")
  else
    return
  fi

  if [[ -n "$selected" ]]; then
    if [[ "$FZ_ABBREVIATE_HOME" == "1" ]]; then
      selected=${selected/#\~/$HOME}
    fi
    selected=$(printf %q "$selected")
    if [[ "$selected" != */ ]]; then
      selected="${selected}/"
    fi
    if [[ "$FZ_ABBREVIATE_HOME" == "1" ]]; then
      selected=${selected/#$HOME/\~}
    fi
    COMPREPLY=( "$selected" )
  fi

  printf '\e[5n'
}

__fz_zsh_completion() {
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins nonomatch
  local args cmd selected slug

  args=(${(z)LBUFFER})
  cmd=${args[1]}

  if [[ "$cmd" != "$FZ_CMD" && "$cmd" != "$FZ_SUBDIR_CMD" ]] \
      || [[ "$cmd" == "$FZ_CMD" && "$LBUFFER" =~ "^\s*$FZ_CMD$" ]] \
      || [[ "$cmd" == "$FZ_SUBDIR_CMD" && "$LBUFFER" =~ "^\s*$FZ_SUBDIR_CMD$" ]]; then
    zle ${__fz_zsh_default_completion:-expand-or-complete}
    return
  fi

  if [[ "${#args}" -gt 1 ]]; then
    eval "slug=${args[-1]}"
  fi

  if [[ "$(__fz_generate_matches "$slug" | head | wc -l)" -gt 1 ]]; then
    selected=$(__fz_generate_matches "$slug" \
      | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse \
      --bind 'shift-tab:up,tab:down' $FZF_DEFAULT_OPTS" fzf)
  elif [[ "$(__fz_generate_matches "$slug" | head | wc -l)" -eq 1 ]]; then
    selected=$(__fz_generate_matches "$slug")
  else
    return
  fi

  if [[ -n "$selected" ]]; then
    if [[ "$FZ_ABBREVIATE_HOME" == "1" ]]; then
      selected=${selected/#\~/$HOME}
    fi
    selected="${(q)selected}"
    if [[ "$selected" != */ ]]; then
      selected="${selected}/"
    fi
    if [[ "$FZ_ABBREVIATE_HOME" == "1" ]]; then
      selected=${selected/#$HOME/\~}
    fi
    LBUFFER="$cmd $selected"
  fi

  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
}

__fz_init_bash_completion() {
  # Enable redrawing line by printf '\e[5n'
  bind '"\e[0n": redraw-current-line'

  complete -o nospace -F __fz_bash_completion "$FZ_CMD"
  complete -o nospace -F __fz_bash_completion "$FZ_SUBDIR_CMD"
}

__fz_init_zsh_completion() {
  [ -n "$__fz_zsh_default_completion" ] || {
    binding=$(bindkey '^I')
    # $binding[(s: :w)2]
    # The command substitution and following word splitting to determine the
    # default zle widget for ^I formerly only works if the IFS parameter contains
    # a space via $binding[(w)2]. Now it specifically splits at spaces, regardless
    # of IFS.
    # It’s not compatitable with bash so use awk instead.
    [[ $binding =~ 'undefined-key' ]] \
      || __fz_zsh_default_completion=$(echo "$binding" | awk '{print $2}')
    unset binding
  }
  zle -N __fz_zsh_completion
  bindkey '^I' __fz_zsh_completion
}

_fz() {
  local rc
  if [[ "$($FZ_HISTORY_LIST_GENERATOR "$@" | head | wc -l)" -gt 0 ]]; then
    "$FZ_HISTORY_CD_CMD" "$@"
  elif [[ "$FZ_SUBDIR_TRAVERSAL" -ne 0 ]]; then
    err=$(cd "${@: -1}" 2>&1)
    rc=$?
    if ! cd "${@: -1}" 2>/dev/null; then
      echo ${err#* } >&2
      return $rc
    fi
  fi
}

_fzz() {
  local rc
  if [[ "$($FZ_SUBDIR_HISTORY_LIST_GENERATOR "$@" | head | wc -l)" -gt 0 ]]; then
    if [[ -n "$BASH_VERSION" ]]; then
      $FZ_SUBDIR_HISTORY_CD_CMD "$@"
    elif [[ -n "$ZSH_VERSION" ]]; then
      ${=FZ_SUBDIR_HISTORY_CD_CMD} "$@"
    fi
  elif [[ "$FZ_SUBDIR_TRAVERSAL" -ne 0 ]]; then
    err=$(cd "${@: -1}" 2>&1)
    rc=$?
    if ! cd "${@: -1}" 2>/dev/null; then
      echo ${err#* } >&2
      return $rc
    fi
  fi
}

if [[ -n "$BASH_VERSION" ]]; then
  __fz_init_bash_completion
elif [[ -n "$ZSH_VERSION" ]]; then
  __fz_init_zsh_completion
fi
