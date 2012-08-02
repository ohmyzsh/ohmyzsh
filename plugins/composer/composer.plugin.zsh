# Composer basic command completion

_composer_chpwd () {
  if [ -f composer.json ]; then
#    echo "composer exist";
  else
#
  fi

  if (( $+commands[composer] )) ; then
    # it exists
    #echo "exist command";
    #$COMPOSER_AS_COMMAND TRUE;
    _composer_get_command_list () {
        composer --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
    }

    _composer () {
        compadd `_composer_get_command_list`
    }

    compdef _composer composer
  else
    _composer_get_command_list () {
        php composer.phar --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
    }

    _composer () {
      if [ -f composer.phar ]; then
        compadd `_composer_get_command_list`
      fi
    }

    compdef _composer composer.phar
  fi
}

chpwd_functions=( "${chpwd_functions[@]}" _composer_chpwd )
