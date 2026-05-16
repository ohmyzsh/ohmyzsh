# Restart a rack app running under pow
# http://pow.cx/
#
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

rack_root(){
  setopt chaselinks
  local orgdir="$PWD"
  local basedir="$PWD"

  while [[ $basedir != '/' ]]; do
    test -e "$basedir/config.ru" && break
    builtin cd ".." 2>/dev/null
    basedir="$PWD"
  done

  builtin cd "$orgdir" 2>/dev/null
  [[ ${basedir} == "/" ]] && return 1
  echo $basedir
}

rack_root_detect(){
  basedir=$(rack_root)
  echo `basename $basedir | sed -E "s/.(com|net|org)//"`
}

kapow(){
  local vhost=$1
  [ ! -n "$vhost" ] && vhost=$(rack_root_detect)
  if [ ! -h ~/.pow/$vhost ]
  then
    echo "pow: This domain isn’t set up yet. Symlink your application to ${vhost} first."
    return 1
  fi

  [ ! -d ~/.pow/${vhost}/tmp ] && mkdir -p ~/.pow/$vhost/tmp
  touch ~/.pow/$vhost/tmp/restart.txt;
  [ $? -eq 0 ] &&  echo "pow: restarting $vhost.dev"
}
compctl -W ~/.pow -/ kapow

powit(){
  local basedir="$PWD"
  local vhost=$1
  [ ! -n "$vhost" ] && vhost=$(rack_root_detect)
  if [ ! -h ~/.pow/$vhost ]
  then
    echo "pow: Symlinking your app with pow. ${vhost}"
    [ ! -d ~/.pow/${vhost} ] && ln -s "$basedir" ~/.pow/$vhost
    return 1
  fi
}

powed(){
  local basedir="$(rack_root)"
  find ~/.pow/ -type l -lname "*$basedir*" -exec basename {}'.dev' \;
}

# Restart pow process
# taken from https://www.matthewratzloff.com
repow(){
  lsof | grep 20560 | awk '{print $2}' | xargs kill -9
  launchctl unload ~/Library/LaunchAgents/cx.pow.powd.plist
  launchctl load ~/Library/LaunchAgents/cx.pow.powd.plist
  echo "restarted pow"
}

# View the standard out (puts) from any pow app
alias kaput="tail -f ~/Library/Logs/Pow/apps/*"
