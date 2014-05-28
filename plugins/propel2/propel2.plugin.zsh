# Propel2 command and arguments completion

_parse_symfony2_console_commands_name () {
  vendor/bin/propel --no-ansi | sed "1,/Available commands:/d" | awk '/^  [a-z]+/ { print $1 }'
}

_parse_symfony2_console_commands () {
  vendor/bin/propel --no-ansi \
    | sed "1,/Available commands:/d" \
    | awk -F"   +|\) " '/^  [a-z]+/ { gsub("^ +","",$1); gsub(":","\:",$1); print $1"["$2"]" }'
}

_propel2_set_commands () {
  local propel2_commands IFS=$'\n'
  read propel2_commands
  
  ## List to array
  propel2_commands=(`_parse_symfony2_console_commands`)
  
 _values '### Available commands:' $propel2_commands
}

_propel2_parse_arguments () {
  _propel2_command_arguments_content=$(vendor/bin/propel --no-ansi --help $1 \
    | sed "1,/Options:/d" \
    | awk -F"  +" '/^ --/ { gsub("^ | \(.+\)$","",$1); gsub(":","\:",$1); print $1"=["$2"]:-:" }') > /dev/null
}

_propel2_set_arguments () {
  local command_name propel_args simple_args arg_name alt_args description value_fn regex match arg_string
  typeset -a propel_args;

  command_name=${line[1]}
  
  if [[ $command_name =~ 'reverse' ]]; then
    if ! [[ $line =~ host\= ]]; then
      _propel2_set_values_dsn
    fi
  fi
  
  if [[ $command_name == 'model:build' ]] || [[ $command_name == 'build' ]]; then
    propel_args+=("--enable-package-object-model[?]")
  fi
  
  # @todo Parse the output help in XML: php vendor/bin/propel reverse --help --format=xml
  vendor/bin/propel "$line[1]" --help | while read line; do
    # @todo Parse the "command usage" help and add an equal sign arguments that need it
    
    # @todo Parse command usage help text
    # Example:
    #   database:reverse [--input-dir="..."] [--database-name="..."] [connection]
    
    regex="^\ *(-[a-z-]+)([\ +\(-]+([a-zA-Z\|]+)\)|)[\) ]+(.+?)"
    if [[ $line =~ $regex ]]; then
      if [[ $BASH_REMATCH != '' ]]; then
	match=("${BASH_REMATCH[@]}")
      fi
      
      arg_name="${match[1]}"
      alt_args=$(echo "${match[3]}" | sed -r 's/([a-zA-Z]+)/-\1/g' | sed 's/|/ /g')
      description="${match[4]}"
      
      # Put alternative arguments
      if [[ $alt_args != '' ]]; then
	echo $alt_args | tr ' ' "\n" | while read p; do
	  if [[ $p == '-vvv' ]]; then
	    # @todo If > 2x alternate args, showed message: "zsh: do you wish to see all 115 possibilities (23 lines)?" Why?
	    propel_args+=("($arg_name $alt_args)${p}[Show the Debug messages (3th level of verbosity)]")
	  else
	    propel_args+=("($arg_name $alt_args)${p}[$description]")
	  fi
	done
      fi
      
      # Detect allowed values for completion
      value_fn=''
      if [[ $arg_name =~ (-file|-path)$ ]]; then
	value_fn='_files'
      fi
      
      if [[ $arg_name =~ -dir ]]; then
        value_fn='_directories'
      fi
      
      if [[ $arg_name == '--mysql-engine' ]]; then
        value_fn='(MyISAM InnoDB)'
      fi
      
      if [[ $arg_name == '--connection' ]]; then
        value_fn='_propel2_set_values_dsn'
      fi
      
      # Detect required in '=' sign
      simple_args=(--help --quiet --verbose --version --ansi --no-ansi --no-interaction --validate --disable-namespace-auto-package --enable-identifier-quoting)
      
      if [[ ${simple_args[(r)$arg_name]} == $arg_name ]]; then
      	arg_string=$(printf "(%s)%s[%b]" "$alt_args" "$arg_name" "$description")
      else
        arg_string=$(printf "%s=[%b]: :%s" "$arg_name" "$description" "$value_fn")
      fi
      
      propel_args+=("$arg_string")
    fi
  done
  
  _arguments $propel_args
}

_propel2_set_values_dsn () {
  _values -S ":" 'DSN Connections (!) Attention! Remove backslashes!' \
    '"mysql["mysql:host=localhost;port=3306;dbname=%;user=%;password=%"]::1:("host=localhost;port=3306;dbname=%;user=%;password=%\"")' \
    '"pgsql["pgsql:host=localhost;port=3306;dbname=%;user=%;password=%"]::2:("host=localhost;port=3306;dbname=%;user=%;password=%\"")' \
    '"sqlite["sqlite:/path/to/database.sq3"]::3:_files' \
    '"sqlite2["sqlite2:/path/to/database.sq2"]::4:_files' \
    '"sqlite\:\:memory\:["sqlite::memory:"]::5:' \
    '"sqlite2\:\:memory\:["sqlite2::memory:"]::6:'
}

_propel2_set_common_commands () {
  # @todo Fix output the args aliases with commands description
  #_arguments '(- :)'{--version,-V}'[Displays software version]'

  _arguments \
    '(--help)-h[Display this help message]' '(-h)--help[Display this help message.]' \
    '(-V)--version[Display this application version]' '(--version)-V[Display this application version.]' \
    '(-n)--no-interaction[Do not ask any interactive question]' '(--no-interaction)-n[Do not ask any interactive question.]'
  
  _parse_symfony2_console_commands | _propel2_set_commands
}

_propel2completion () {
  local curcontext="$curcontext" local context state state_descr line expl
  typeset -A opt_args
  
  if ! [[ -f vendor/bin/propel ]]; then
    echo 'Propel not found in "vendor/bin/propel"!'
    return 1
  fi
   
  line=(${=words})
  shift line
  
  regex="\ [a-z][a-z:-]+\ "
  if [[ $CURRENT < 3 ]] || ! [[ " ${(j/ /)words}" =~ $regex ]]; then
    _propel2_set_common_commands
  else
    _arguments '*:: :_propel2_set_arguments'
  fi
}

# Enable display names of groups for commands and values
zstyle ':completion:*:descriptions' format '%B%d%b'

## Bind completion function on command
compdef _propel2completion 'vendor/bin/propel'

## Aliases
alias propel2='vendor/bin/propel'
alias p='vendor/bin/propel'
#alias propel2migrate='php app/console cache:clear'
