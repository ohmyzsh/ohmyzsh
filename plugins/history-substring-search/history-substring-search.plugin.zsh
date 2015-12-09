# This file integrates the zsh-history-substring-search script into oh-my-zsh.

source "${0:r:r}.zsh"

if test "$CASE_SENSITIVE" = true; then
  unset HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS
fi

if test "$DISABLE_COLOR" = true; then
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
fi


# Bind terminal-specific up and down keys

if [[ -n "$terminfo[kcuu1]" ]]; then
  bindkey "$terminfo[kcuu1]" history-substring-search-up
fi
if [[ -n "$terminfo[kcud1]" ]]; then
  bindkey "$terminfo[kcud1]" history-substring-search-down
fi

