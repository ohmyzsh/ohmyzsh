# Thanks to Christopher Sexton
# https://gist.github.com/1019777

# Adds a kapow command that will restart an app
#
#   $ kapow myapp
#
# Supports command completion.
#
# If you are not already using completion you might need to enable it with
# 
#    autoload -U compinit compinit
#
# Changes:
#
# Defaults to the current application, and will walk up the tree to find 
# a config.ru file and restart the corresponding app
#
# Will Detect if a app does not exist in pow and print a (slightly) helpful 
# error message

rack_root_detect(){
  setopt chaselinks
  local orgdir=$(pwd)
  local basedir=$(pwd)

  while [[ $basedir != '/' ]]; do
    test -e "$basedir/config.ru" && break
    builtin cd ".." 2>/dev/null
    basedir="$(pwd)"
  done

  builtin cd $orgdir 2>/dev/null
  [[ ${basedir} == "/" ]] && return 1
	echo $basedir
}

kapow(){
  local vhost=$1
  [ ! -n "$vhost" ] && vhost=$(basename `rack_root_detect` | sed -E "s/.(com|net|org)//")
  if [ ! -h ~/.pow/$vhost ]
  then
    echo "pow: This domain isn’t set up yet. Symlink your application to ${vhost} first."
    return 1
  fi

  [ ! -d "~/.pow/${vhost}/tmp" ] &&  mkdir -p "~/.pow/$vhost/tmp"
  touch ~/.pow/$vhost/tmp/restart.txt;
  [ $? -eq 0 ] &&  echo "pow: restarting $vhost.dev"
}

# The powinit command symlinks a dir to ~/.pow
#
#   $ powinit /path/to/myapp
#
# powinit alone uses the working dir:
#
#   $ powinit

powinit(){
  local full_path=$1
  [ -n "$full_path" ] && full_path=$(echo $full_path(:A))
  [ ! -n "$full_path" ] && full_path=$(rack_root_detect)
  if [ ! -n "$full_path" ]
  then
    echo "pow: Not a rack app"
    return 1
  fi
  local vhost=$(basename $full_path | sed -E "s/.(com|net|org)//")
  if [ -h ~/.pow/$vhost ]
  then
    echo "pow: This domain is already set up. Remove the symlink in ~/.pow to reconfigure."
    return 1
  fi
	ln -s $full_path ~/.pow/$vhost
	echo "pow: Application set up on http://$vhost.dev"
}
compctl -W ~/.pow -/ kapow

# View the standard out (puts) from any pow app
alias kaput="tail -f ~/Library/Logs/Pow/apps/*"