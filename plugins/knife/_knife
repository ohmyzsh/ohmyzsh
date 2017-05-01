#compdef knife

# You can override the path to knife.rb and your cookbooks by setting
# KNIFE_CONF_PATH=/path/to/my/.chef/knife.rb
# KNIFE_COOKBOOK_PATH=/path/to/my/chef/cookbooks
# If you want your local cookbooks path to be calculated relative to where you are then 
# set the below option
# KNIFE_RELATIVE_PATH=true 
# Read around where these are used for more detail.

# These flags should be available everywhere according to man knife
knife_general_flags=( --help --server-url --key --config --editor --format --log_level --logfile --no-editor --user --print-after --version --yes )

# knife has a very special syntax, some example calls are:
# knife status
# knife cookbook list
# knife role show ROLENAME
# knife data bag show DATABAGNAME
# knife role show ROLENAME --attribute ATTRIBUTENAME
# knife cookbook show COOKBOOKNAME COOKBOOKVERSION recipes

# The -Q switch in compadd allow for completions of things like "data bag" without having to go through two rounds of completion and avoids zsh inserting a \ for escaping spaces
_knife() {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  cloudproviders=(bluebox ec2 rackspace slicehost terremark)
  _arguments \
    '1: :->knifecmd'\
    '2: :->knifesubcmd'\
    '3: :->knifesubcmd2' \
    '4: :->knifesubcmd3' \
    '5: :->knifesubcmd4' \
    '6: :->knifesubcmd5'
  
  case $state in
  knifecmd)
    compadd -Q "$@" bootstrap client configure cookbook "cookbook site" "data bag" diff exec environment index node recipe role search ssh status upload vault windows $cloudproviders
  ;;
  knifesubcmd)
    case $words[2] in
    (bluebox|ec2|rackspace|slicehost|terremark)
      compadd "$@" server images
    ;;
    client)
      compadd -Q "$@" "bulk delete" list create show delete edit reregister
    ;;
    configure)
      compadd "$@" client
    ;;
    cookbook)
      compadd -Q "$@" test list create download delete "metadata from" show "bulk delete" metadata upload
    ;;
    diff)
      _arguments '*:file or directory:_files -g "*"'
    ;;
    environment)
      compadd -Q "$@" list create delete edit show "from file"
    ;;
    node)
     compadd -Q "$@" "from file" create show edit delete list run_list "bulk delete"
    ;;
    recipe)
     compadd "$@" list
    ;;
    role)
      compadd -Q "$@" "bulk delete" create delete edit "from file" list show
    ;; 
    upload)
     _arguments '*:file or directory:_files -g "*"'
    ;;
    vault)
      compadd -Q "$@" create decrypt delete edit remove "rotate all keys" "rotate keys" show update
    ;;
    windows)
      compadd "$@" bootstrap
    ;;
    *)
    _arguments '2:Subsubcommands:($(_knife_options1))'
    esac
   ;;
   knifesubcmd2)
    case $words[3] in
     server)
      compadd "$@" list create delete
    ;;
     images)
      compadd "$@" list
    ;;
     site)
      compadd "$@" vendor show share search download list unshare
    ;;
     (show|delete|edit)
     _arguments '3:Subsubcommands:($(_chef_$words[2]s_remote))'
    ;;
    (upload|test)
     _arguments '3:Subsubcommands:($(_chef_$words[2]s_local) --all)'
    ;;
    list)
     compadd -a "$@" knife_general_flags
    ;;
    bag)
      compadd -Q "$@" show edit list "from file" create delete
    ;;
    *)
      _arguments '3:Subsubcommands:($(_knife_options2))'
    esac
   ;;
   knifesubcmd3)
     case $words[3] in
      show)
       case $words[2] in
       cookbook)
          versioncomp=1
          _arguments '4:Cookbookversions:($(_cookbook_versions) latest)'
       ;;
       (node|client|role)
         compadd "$@" --attribute
       esac
     esac
     case $words[4] in
     (show|edit)
     _arguments '4:Subsubsubcommands:($(_chef_$words[2]_$words[3]s_remote))'
    ;;
     file)
      case $words[2] in
      environment)
        _arguments '*:files:_path_files -g "*.(rb|json)" -W "$(_chef_root)/environments"'
      ;;
      node)
        _arguments '*:files:_path_files -g "*.(rb|json)" -W "$(_chef_root)/nodes"'
      ;;
      role)
        _arguments '*:files:_path_files -g "*.(rb|json)" -W "$(_chef_root)/roles"'
      ;;
      *)
        _arguments '*:Subsubcommands:($(_knife_options3))'
      esac 
    ;;
      list)
     compadd -a "$@" knife_general_flags
    ;;
        *)
       _arguments '*:Subsubcommands:($(_knife_options3))'
    esac
    ;;
    knifesubcmd4)
      if (( versioncomp > 0 )); then
        compadd "$@" attributes definitions files libraries providers recipes resources templates
      else
      case $words[5] in 
        file)
          _arguments '*:directory:_path_files -/ -W "$(_chef_root)/data_bags" -qS \ '
        ;;
        *) _arguments '*:Subsubcommands:($(_knife_options2))'
      esac
      fi
    ;; 
    knifesubcmd5) 
      case $words[5] in 
        file) 
          _arguments '*:files:_path_files -g "*.json" -W "$(_chef_root)/data_bags/$words[6]"'
        ;;
        *) 
          _arguments '*:Subsubcommands:($(_knife_options3))'
      esac
   esac
}

# Helper functions to provide the argument completion for several depths of commands
_knife_options1() {
 ( for line in $( knife $words[2] --help | grep -v "^knife" ); do echo $line | grep "\-\-"; done )
}

_knife_options2() {
 ( for line in $( knife $words[2] $words[3] --help | grep -v "^knife" ); do echo $line | grep "\-\-"; done )
}

_knife_options3() {
 ( for line in $( knife $words[2] $words[3] $words[4] --help | grep -v "^knife" ); do echo $line | grep "\-\-"; done )
}

# The chef_x_remote functions use knife to get a list of objects of type x on the server
_chef_roles_remote() {
 (knife role list --format json | grep \" | awk '{print $1}' | awk -F"," '{print $1}' | awk -F"\"" '{print $2}')
}

_chef_clients_remote() {
 (knife client list --format json | grep \" | awk '{print $1}' | awk -F"," '{print $1}' | awk -F"\"" '{print $2}')
}

_chef_nodes_remote() {
 (knife node list --format json | grep \" | awk '{print $1}' | awk -F"," '{print $1}' | awk -F"\"" '{print $2}')
}

_chef_cookbooks_remote() {
 (knife cookbook list --format json | grep \" | awk '{print $1}' | awk -F"," '{print $1}' | awk -F"\"" '{print $2}')
}

_chef_sitecookbooks_remote() {
 (knife cookbook site list --format json | grep \" | awk '{print $1}' | awk -F"," '{print $1}' | awk -F"\"" '{print $2}')
}

_chef_data_bags_remote() {
 (knife data bag list --format json | grep \" | awk '{print $1}' | awk -F"," '{print $1}' | awk -F"\"" '{print $2}')
}

_chef_environments_remote() {
  (knife environment list | awk '{print $1}')
}

# The chef_x_local functions use the knife config to find the paths of relevant objects x to be uploaded to the server
_chef_cookbooks_local() {
  if [ $KNIFE_RELATIVE_PATH ]; then 
    local cookbook_path="$(_chef_root)/cookbooks"
  else 
    local knife_rb=${KNIFE_CONF_PATH:-${HOME}/.chef/knife.rb}
    if [ -f ./.chef/knife.rb ]; then
      knife_rb="./.chef/knife.rb"
    fi
    local cookbook_path=${KNIFE_COOKBOOK_PATH:-$(grep cookbook_path $knife_rb | awk 'BEGIN {FS = "[" }; {print $2}' | sed 's/\,//g' | sed "s/'//g" | sed 's/\(.*\)]/\1/' )}
  fi
  (for i in $cookbook_path; do ls $i; done)
}

# This function extracts the available cookbook versions on the chef server
_cookbook_versions() {
  (knife cookbook show $words[4] | grep -v $words[4] | grep -v -E '\]|\[|\{|\}' | sed 's/ //g' | sed 's/"//g')
}

# Searches up from current directory to find the closest folder that has a .chef folder 
# Useful for the knife upload/from file commands 
_chef_root () {
  directory="$PWD"
  while [ $directory != '/' ]
  do
    test -e "$directory/.chef" && echo "$directory" && return
    directory="${directory:h}"
  done
}

_knife "$@"
