# Laravel4 extend command & arguments completion

_laravel4_parse_commands () {
  local help_string
  
  while read help_string; do
    echo $help_string \
      | awk -F"   +|\) " '/^  [a-z]+/ { gsub("^ +","",$1); gsub(":","\:",$1); print $1"["$2"]" }'
  done
}

_laravel4_set_commands () {
  local laravel4_commands IFS=$'\n'

  laravel4_commands=(`php artisan --no-ansi | sed "1,/Available commands:/d" | _laravel4_parse_commands`)
  
  _values '### Available commands:' $laravel4_commands
}

_laravel4_parse_arguments () {
  local simple_args help_string regex arg_name alt_args description
  
  simple_args=(--help --quiet --verbose --version --ansi --no-ansi --no-interaction --pretend --seed)
  
  while read help_string; do
    regex="^\ *(-[a-z-]+)([\ +\(-]+([a-zA-Z\|]+)\)|)[\) ]+(.+?)"
    if [[ "$help_string" =~ "$regex" ]]; then
      arg_name="${match[1]}"
      alt_args=$(echo "${match[3]}" | sed -r 's/([a-zA-Z]+)/-\1/g' | sed 's/|/ /g')
      description="${match[4]}"
      
      # Detect allowed values for completion
      value_fn=''
      if [[ $arg_name =~ (-file|-path|Path)$ ]]; then
	value_fn='_files'
      fi
      
      if [[ $arg_name =~ -dir ]]; then
	value_fn='_directories'
      fi
      
      if [[ ${simple_args[(r)$arg_name]} == $arg_name ]]; then
      	printf "(%s)%s[%b]\n" "$alt_args" "$arg_name" "$description"
      else
        printf "%s=[%b]: :%s\n" "$arg_name" "$description" "$value_fn"
      fi
    fi
  done
}

_laravel4_set_arguments () {
  local laravel4arguments IFS=$'\n'
  
  laravel4arguments=(`php artisan --no-ansi --help "$1" | sed "1,/Options:/d" | _laravel4_parse_arguments`)
  
  _arguments $laravel4arguments
}

_laravel4completion () {
  local cmdline regex
  
  cmdline=(${=words})
  cmdline=(${cmdline[2,-1]})
  
  regex="\ [a-z][a-z:_-]+"
  if [[ $CURRENT == 2 ]] || ! [[ " ${(j/ /)cmdline}" =~ $regex ]]; then
    _laravel4_set_commands
  else
    _arguments '*:: :{{ _laravel4_set_arguments ${cmdline[1]} }}'
  fi
}

zstyle ':completion:*:descriptions' format '%B%d%b'

compdef _laravel4completion artisan

#Alias
alias la4='php artisan'
alias l='php artisan'

alias la4dump='php artisan dump-autoload'
alias la4cache='php artisan cache:clear'
alias la4routes='php artisan routes'
