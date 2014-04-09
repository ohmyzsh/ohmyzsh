#compdef clouds
#autoload

# clouds zsh completion

_clouds_all_stacks() {
  all_stacks=(`clouds list | tail -n +3 | awk '{print $1}'`)
}

_clouds_local_stacks() {
  local_stacks=(`test -d stacks && ls -1 stacks`)
}

local -a _1st_arguments
_1st_arguments=(
  'clone:Clones an existing stack into a new one'
  'delete:Deletes a stack'
  'dump:Dump CloudFormation stacks from your account into the current directory'
  'edit:Edit a CloudFormation stack locally'
  'help:Shows a list of commands or help for one command'
  'list:List CloudFormation stacks from your account'
  'update:Updated a list of CloudFormation stacks based on information from the current directory'
)

local expl
local -a all_stacks local_stacks

_arguments \
  '(-f)--force[Force overwrites of existing data]' \
  '(--help)--help[Show help]' \
  '(--version)--version[Display the program version]' \
  '*:: :->subcmds' && return 0

if (( CURRENT == 1 )); then
  _describe -t commands "clouds subcommand" _1st_arguments
  return
fi

case "$words[1]" in
  clone|edit)
    _clouds_local_stacks
    _wanted local_stacks expl 'local stacks' compadd -a local_stacks
  ;;
  update)
    _arguments '(-c)--create_missing[Create AWS stacks if the required sources exist locally]'
    _clouds_local_stacks
    _wanted local_stacks expl 'local stacks' compadd -a local_stacks
  ;;
  dump)
    _arguments '(--all)--all[dump all stacks]'
    _clouds_all_stacks
    _wanted all_stacks expl 'all stacks' compadd -a all_stacks
  ;;
  delete)
    _clouds_all_stacks
    _wanted all_stacks expl 'all stacks' compadd -a all_stacks
  ;;
esac
