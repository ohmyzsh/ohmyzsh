# Updates editor information when the keymap changes.
function zle-keymap-select() {
  # update keymap variable for the prompt
  VI_KEYMAP=$KEYMAP

  zle reset-prompt
  zle -R
}

zle -N zle-keymap-select

function vi-accept-line() {
  VI_KEYMAP=main
  zle accept-line
}

zle -N vi-accept-line


bindkey -v

# Helper function to bind keys in multiple vi modes
function vi-bindkey () {
  # Parse argumets
  local -a modes
  local command
  while (( $# )); do
    [[ $1 = "--" ]] && break
    modes+=$1
    shift
  done
  shift
  command=$1
  shift

  # Execute commands
  for c in $@; do
    for m in $modes; do
      bindkey -M $m "$c" $command
    done
  done
}

# use custom accept-line widget to update $VI_KEYMAP
vi-bindkey vicmd viins visual -- vi-accept-line                      '^J'
vi-bindkey vicmd viins visual -- vi-accept-line                      '^M'

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
vi-bindkey vicmd visual       -- edit-command-line                   '^v'

# allow for  visual mode based selection
vi-bindkey vicmd              -- visual-mode                         'v'

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
vi-bindkey vicmd viins        -- up-history                          '^P'
vi-bindkey vicmd viins        -- down-history                        '^N'

# allow ctrl-h, ctrl-w, ctrl-?, ctrl-u for char, word, line deletion (standard behaviour)
vi-bindkey vicmd viins        -- backward-delete-char                '^?'
vi-bindkey vicmd viins        -- backward-delete-char                '^h'
vi-bindkey vicmd viins        -- backward-kill-word                  '^w'
vi-bindkey vicmd viins        -- backward-kill-line                  '^u'

# allow ctrl-r and ctrl-s to search the history
vi-bindkey vicmd viins        -- history-incremental-search-backward '^r'
vi-bindkey vicmd viins        -- history-incremental-search-forward  '^s'

# allow ctrl-a and ctrl-e to move to beginning/end of line
vi-bindkey vicmd viins visual -- beginning-of-line                   '^a'
vi-bindkey vicmd viins visual -- end-of-line                         '^e'

# surround on text objects
autoload -U select-bracketed
zle -N select-bracketed
autoload -U select-quoted
zle -N select-quoted
autoload -Uz surround
zle -N delete-surround surround
zle -N change-surround surround
zle -N add-surround surround

for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    vi-bindkey $m             -- select-bracketed                    $c
  done
  for c in {a,i}{\',\",\`}; do
    vi-bindkey $m             -- select-quoted                       $c
  done
done
vi-bindkey vicmd              -- change-surround                     cs
vi-bindkey vicmd              -- delete-surround                     ds
vi-bindkey vicmd              -- add-surround                        ys

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${VI_KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi
