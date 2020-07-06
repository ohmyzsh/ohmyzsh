# get version ruby and print only version
function rbenv_prompt_info() {
  ruby_version=$(~/.rbenv/shims/ruby -v | awk '{print $2}' 2> /dev/null) || return
  echo "($ruby_version)"
}
