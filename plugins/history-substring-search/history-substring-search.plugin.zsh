# This file integrates the history-substring-search script into oh-my-zsh.

source "${0:r:r}.zsh"

if check-bool "$CASE_SENSITIVE"; then
  unset HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS
fi

if ! check-bool "$COLOR"; then
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
  unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
fi

