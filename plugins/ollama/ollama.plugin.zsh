# Keep long Ollama tables within the terminal while retaining every match.
# More specific styles, or styles set after Oh My Zsh loads, can override these.
zmodload -i zsh/complist
zstyle ':completion:*:*:ollama*:*:*' menu yes select=2 select=long-list
zstyle ':completion:*:*:ollama*:*:default' select-prompt \
  '%S%p -- %m matches (Tab/arrows to move, Enter to accept)%s'
zstyle ':completion:*:*:ollama*:*:default' select-scroll 0
zstyle ':completion:*:*:ollama*:*:default' list-prompt \
  '%S%p -- Tab for more%s'
