# Aliases

# Hub by defunkt
# https://github.com/defunkt/hub
if (( $+commands[hub] )); then
  function git() {
    hub "$@"
  }
fi

