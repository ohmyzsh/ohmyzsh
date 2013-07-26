# Enables rbfu with --auto option, if available.
#
# Also provides a command to list all installed/available
# rubies. To ensure compatibility with themes, creates the
# rvm_prompt_info function to return the $RBFU_RUBY_VERSION
# version.

command -v rbfu &>/dev/null

if [[ $? -eq 0 ]]; then
  eval "$(rbfu --init --auto)"

  # Internal: Print ruby version details, if it's currently
  # active etc.
  function _rbfu_rubies_print() {
    local rb rb_out
    rb=$(basename $1)
    rb_out="$rb"
    [[ -h $1 ]] && rb_out="$rb_out${fg[green]}@${reset_color}"
    [[ "x$rb" == "x$2" ]] && rb_out="${fg[red]}$rb_out ${fg[red]}*${reset_color}"
    echo $rb_out
  }

  # Public: Provide a list with all available rubies, this basically depends
  # on `ls -1` and .rfbu/rubies. Highlights the currently active ruby version
  # and aliases.
  function rbfu-rubies() {
    local rbfu_dir active_rb
    rbfu_dir=$RBFU_RUBIES
    active_rb=$RBFU_RUBY_VERSION
    [[ -z "$rbfu_dir" ]] && rbfu_dir="${HOME}/.rbfu/rubies"
    [[ -z "$active_rb" ]] && active_rb="system"
    _rbfu_rubies_print "${rbfu_dir}/system" $active_rb
    for rb in $(ls -1 $rbfu_dir); do
      _rbfu_rubies_print "${rbfu_dir}/${rb}" $active_rb
    done
  }

  # Public: Create rvm_prompt_info command for themes compatibility, unless
  # it has already been defined.
  [ ! -x rvm_prompt_info ] && function rvm_prompt_info() { echo "${RBFU_RUBY_VERSION:=system}" }
fi
