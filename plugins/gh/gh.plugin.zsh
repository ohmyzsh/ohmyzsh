# Autocompletion for the GitHub CLI (gh).
#
# Copy from kubectl : https://github.com/pstadler

if [ $commands[gh] ]; then
  source <(gh completion --shell zsh)
fi
