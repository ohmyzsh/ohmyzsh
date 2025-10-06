# octozen plugin

# Displays a zen quote from octocat
function display_octozen() {
  curl -m 2 -fsL "https://api.github.com/octocat"
  add-zsh-hook -d precmd display_octozen
}

# Display the octocat on the first precmd, after the whole starting process has finished
autoload -Uz add-zsh-hook
add-zsh-hook precmd display_octozen
