zsh-node_modules-bin-update-path() {
  if [[ ! -x $(which npm) ]]; then
    # there is no npm
    return
  fi

  if [[ ! -r $(which npm-path) ]]; then
    echo "npm-path must be available for the oh-my-zshell npm-path module to update your PATH"
    return
  fi

  export PATH=$(npm-path)
}

precmd_functions+="zsh-node_modules-bin-update-path"
