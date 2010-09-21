# get the name of the branch we are on
function rvm_prompt_info() {
  ruby_version=$(~/.rvm/bin/rvm-prompt 2> /dev/null) || return
  echo "($ruby_version)"
}

# get the name of the ruby as well as the gemset
# from http://snipplr.com/view.php?codeview&id=36724
function rvm_with_gemset {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
  # local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
  local version=$(~/.rvm/bin/rvm-prompt s i v)
  [ "$version" != "" ] && version="$version"
  local full="$version$gemset"
  [ "$full" != "" ] && echo "$full"
}

