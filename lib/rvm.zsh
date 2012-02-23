# get the name of the branch we are on
function rvm_prompt_info() {
  ruby_version=$(~/.rvm/bin/rvm-prompt 2> /dev/null) || return
  echo "($ruby_version)"
}

if [[ -s $HOME/.rvm/scripts/rvm ]]; then
    # Bugfix: prompt displays the current directory as "~rvm_rvmrc_cwd"
    # http://beginrescueend.com/integration/zsh/
    unsetopt auto_name_dirs

    source $HOME/.rvm/scripts/rvm
fi
