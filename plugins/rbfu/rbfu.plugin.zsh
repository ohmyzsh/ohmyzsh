# Enables rbfu with --auto option, if available.
#
# Also provides a command to list all installed/available
# rubies. To ensure compatibility with themes, creates the
# rvm_prompt_info function to return the $RBFU_RUBY_VERSION
# version.

command -v rbfu &>/dev/null || return

eval "$(rbfu --init --auto)"

# Internal: Print ruby version details, if it's currently active, etc.
function _rbfu_rubies_print() {
  # 1: path to ruby file
  # 2: active ruby
  local rb rb_out
  rb="${$1:t}"
  rb_out="$rb"

  # If the ruby is a symlink, add @ to the name.
  if [[ -h "$1" ]]; then
    rb_out="${rb_out}${fg[green]}@${reset_color}"
  fi

  # If the ruby is active, add * to the name and show it in red.
  if [[ "$rb" = "$2" ]]; then
    rb_out="${fg[red]}${rb_out} ${fg[red]}*${reset_color}"
  fi

  echo $rb_out
}

# Public: Provide a list with all available rubies, this basically depends
# on ~/.rfbu/rubies. Highlights the currently active ruby version and aliases.
function rbfu-rubies() {
  local rbfu_dir active_rb
  rbfu_dir="${RBFU_RUBIES:-${HOME}/.rbfu/rubies}"
  active_rb="${RBFU_RUBY_VERSION:-system}"

  _rbfu_rubies_print "${rbfu_dir}/system" "$active_rb"
  for rb in ${rbfu_dir}/*(N); do
    _rbfu_rubies_print "$rb" "$active_rb"
  done
}

# Public: Create rvm_prompt_info command for themes compatibility, unless
# it has already been defined.
(( ${+functions[rvm_prompt_info]} )) || \
function rvm_prompt_info() { echo "${${RBFU_RUBY_VERSION:=system}:gs/%/%%}" }
