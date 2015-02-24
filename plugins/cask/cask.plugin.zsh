() {
  if which cask &> /dev/null; then
    local cask_bin cask_base f comp_files
    cask_bin=$(which cask)
    cask_base=${cask_bin:h:h}
    # Plain cask installation location (for Cask 0.7.2 and earlier)
    comp_files=( $cask_base/etc/cask_completion.zsh )
    # Mac Homebrew installs the completion in a different location
    if which brew &> /dev/null; then
      comp_files+=`brew --prefix`/share/zsh/site-functions/cask_completion.zsh
    fi
    for f in $comp_files; do
      if [[ -f $f ]]; then
        source $f;
        break;
      fi
    done
  else
    print "zsh cask plugin: cask not found"
  fi
}