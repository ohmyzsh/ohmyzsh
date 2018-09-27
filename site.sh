if [[ -v ENABLE_ITERM2_INTEGRATION ]]; then
    test -e "${HOME}/.oh-my-zsh/iterm2_shell_integration.zsh" && source "${HOME}/.oh-my-zsh/iterm2_shell_integration.zsh"
fi
plugins=(
  git
  tmux
  pyenv
  mosh
  golang
  git
  extract
  zsh-autosuggestions
)

