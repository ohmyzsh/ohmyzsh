# nvm
#
# This plugin locates and loads nvm, looking for it in well-known locations.

() {
  emulate -L zsh
  local nvm_dir="" dir install_locations
  if [[ -n $NVM_DIR ]]; then
  	nvm_dir=$NVM_DIR
  else
    # Well-known common installation locations for NVM
    install_locations=( ~/.nvm )
    # Mac Homebrew sticks 
    which brew &>/dev/null && install_locations+=$(brew --prefix nvm)
    for dir ($install_locations); do
      if [[ -s $dir/nvm.sh ]]; then
        nvm_dir=$dir
        break
      fi
    done
  fi

  if [[ -n $nvm_dir ]]; then
    source $nvm_dir/nvm.sh
  fi

  # Locate and use the completion file shipped with NVM, instead of this
  # plugin's completion
  # (Their bash completion file has zsh portability support)
  if [[ $ZSH_NVM_BUNDLED_COMPLETION == true ]]; then
    local bash_comp_file
    # Homebrew relocates the bash completion file, so look multiple places
    for bash_comp_file ( bash_completion etc/bash_completion.d/nvm ); do
      if [[ -s $NVM_DIR/$bash_comp_file ]]; then
        source $NVM_DIR/$bash_comp_file
        break;
      fi
    done
  fi
}
