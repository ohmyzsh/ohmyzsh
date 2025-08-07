# If direnv is not found, don't continue and print a warning
if (( ! $+commands[direnv] )); then
  echo "Warning: direnv not found. Please install direnv and ensure it's in your PATH before using this plugin."
  return
fi

# Load direnv's shell hook, which is the supported integration mechanism for
# modern direnv versions.
if ! eval "$(direnv hook zsh)"; then
  echo "Warning: direnv hook failed to initialize. Please ensure direnv is installed correctly."
fi
