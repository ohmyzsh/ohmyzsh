# In vi-mode, map v to edit the command line
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Yes, we're in vi-mode, but ^r is a habit
bindkey -M viins "^r" vi-history-search-backward
bindkey -M vicmd "^r" vi-history-search-backward

# Sometimes its useful to find in insert mode
bindkey -M viins "^F" vi-find-next-char
bindkey -M viins "^P" vi-find-prev-char
