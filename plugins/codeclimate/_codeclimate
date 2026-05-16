#compdef codeclimate

_codeclimate_all_engines() {
  engines_all=(`codeclimate engines:list | tail -n +2 | gawk '{ print $2 }' | gawk -F: '{ print $1 }'`)
}

_codeclimate_installed_engines() {
  _codeclimate_all_engines

  engines_installed=()

  if [ -e .codeclimate.yml ]
  then
    for engine in $engines_all
    do
      if grep -q $engine ".codeclimate.yml"
      then
        engines_installed+=$engine
      fi
    done
  fi
}

_codeclimate_not_installed_engines() {
  _codeclimate_all_engines

  engines_not_installed=()

  if [ -e .codeclimate.yml ]
  then
    for engine in $engines_all
    do
      if ! grep -q $engine ".codeclimate.yml"
      then
        engines_not_installed+=$engine
      fi
    done
  fi
}

local curcontext="$curcontext" state line ret=1
local expl
local -a engines_all engines_installed engines_not_installed

_arguments \
  '1: :->cmds' \
  '*:: :->args' && ret=0

case $state in
  cmds)
    _values "bundle command" \
      "analyze[Analyze all relevant files in the current working directory]" \
      "console[Start an interactive session providing access to the classes within the CLI]" \
      "engines\:disable[Prevents the engine from being used in this project]" \
      "engines\:enable[This engine will be run the next time your project is analyzed]" \
      "engines\:install[Compares the list of engines in your .codeclimate.yml file to those that are currently installed, then installs any missing engines]" \
      "engines\:list[Lists all available engines in the Code Climate Docker Hub]" \
      "engines\:remove[Removes an engine from your .codeclimate.yml file]" \
      "help[Displays a list of commands that can be passed to the Code Climate CLI]" \
      "init[Generates a new .codeclimate.yml file in the current working directory]" \
      "validate-config[Validates the .codeclimate.yml file in the current working directory]" \
      "version[Displays the current version of the Code Climate CLI]"
    ret=0
    ;;
  args)
    case $line[1] in
      engines:enable)
        _codeclimate_not_installed_engines
        _wanted engines_not_installed expl 'not installed engines' compadd -a engines_not_installed ;;
      engines:disable|engines:remove)
        _codeclimate_installed_engines
        _wanted engines_installed expl 'installed engines' compadd -a engines_installed ;;
      analyze)
        _arguments \
          '-f:Output Format:(text json)'
        ret=0
        ;;
    esac
    ;;
esac

return ret
