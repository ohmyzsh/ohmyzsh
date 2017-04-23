zsh-npm-path() {
  if [[ ! -x $(which npm) ]]; then
    # there is no npm
    return
  fi

  if [[ ! -r $(which npm-path) ]]; then
    echo "WARNING: npm-path must be available for the oh-my-zshell npm-path module to update your PATH. Perhaps \`npm --global install npm-path\` will help."
    return
  fi

  export PATH=$(npm-path)
}

precmd_functions+="zsh-npm-path"
