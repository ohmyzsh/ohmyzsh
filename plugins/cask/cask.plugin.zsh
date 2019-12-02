() {
  emulate -L zsh

  if ! (( $+commands[cask] )); then
    print "zsh cask plugin: cask command not found" >&2
    return
  fi

  cask_base=${commands[cask]:h:h}

  # Plain cask installation location (for Cask 0.7.2 and earlier)
  comp_files=($cask_base/etc/cask_completion.zsh)

  # Mac Homebrew installs the completion in a different location
  if (( $+commands[brew] )); then
    comp_files+=($(brew --prefix)/share/zsh/site-functions/cask_completion.zsh)
  fi

  # Load first found file
  for f in $comp_files; do
    if [[ -f "$f" ]]; then
      source "$f"
      break
    fi
  done
}
