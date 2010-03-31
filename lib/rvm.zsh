function rvm_ruby_prompt {
  if (declare -f rvm > /dev/null) {
      if [[ -x $MY_RUBY_HOME ]]
      then ruby -v | sed 's/\([^(]*\).*/\1/'
      fi
  }
}

