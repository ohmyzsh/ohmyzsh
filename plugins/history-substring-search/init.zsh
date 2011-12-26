# This file integrates the history-substring-search script into oh-my-zsh.

source "${0:h}/history-substring-search.zsh"

if zstyle -t ':omz:plugin:history-substring-search' case-sensitive; then
  unset HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS
fi

if ! zstyle -t ':omz:plugin:history-substring-search' color; then
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
fi

