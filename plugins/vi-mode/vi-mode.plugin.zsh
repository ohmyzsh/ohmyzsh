# Updates editor information when the keymap changes.

if [ ! -n "${VIM_NORMAL_COLOR+x}" ]; then
  if [ $TERM = "screen" ]; then
    VIM_NORMAL_COLOR='\033P\033]12;#FF3333\007\033\\'
  else
    VIM_NORMAL_COLOR="\033]12;#FF3333\007"
  fi
fi

if [ ! -n "${VIM_INSERT_COLOR+x}" ]; then
  if [ $TERM = "screen" ]; then
    VIM_INSERT_COLOR='\033P\033]12;#99FF33\007\033\\'
  else
    VIM_INSERT_COLOR="\033]12;#00FF00\007"
  fi
fi

function zle-keymap-select() {
  zle reset-prompt
  zle -R
  if [ $TERM = "screen" ]; then
    if [ $KEYMAP = vicmd ]; then
      echo -ne $VIM_NORMAL_COLOR
    else
      echo -ne $VIM_INSERT_COLOR
    fi
  elif [ $TERM != "linux" ]; then
    if [ $KEYMAP = vicmd ]; then
      echo -ne $VIM_NORMAL_COLOR
    else
      echo -ne $VIM_INSERT_COLOR
    fi
  fi
}; zle -N zle-keymap-select

eval "override-vi-mode-$(declare -f zle-line-init)"
zle-line-init () {
  if [ $TERM = "screen" ]; then
    echo -ne $VIM_INSERT_COLOR
  elif [ $TERM != "linux" ]; then
    echo -ne $VIM_INSERT_COLOR
  fi
  override-vi-mode-zle-line-init
}; zle -N zle-line-init

autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

zle -N edit-command-line

bindkey -v

# allow v to edit the command line (psql behaviour)
autoload -Uz edit-command-line
bindkey -M vicmd '\e' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

# allow ctrl-r to perform backward search in history
bindkey '^r' history-incremental-search-backward

# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
