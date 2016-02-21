0=${(%):-%N}
source ${0:A:h}/history-substring-search.zsh

# Bind terminal-specific up and down keys

if [[ -n "$terminfo[kcuu1]" ]]; then
  omz_bindkey -M emacs -t kcuu1 history-substring-search-up
  omz_bindkey -M viins -t kcuu1 history-substring-search-up
fi
if [[ -n "$terminfo[kcud1]" ]]; then
  omz_bindkey -M emacs -t kcud1 history-substring-search-down
  omz_bindkey -M viins -t kcud1 history-substring-search-down
fi

