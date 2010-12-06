function tab() {
  osascript 2>/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end
    tell application "Terminal"
      activate
      do script with command "cd \"$PWD\"; $*" in window 1
    end tell
EOF
}

# OSX doesn't have wget
alias wget='curl -O'

# Postgres for Mac OS X
if [ -x /usr/local/pgsql ]; then
  export PATH=/usr/local/pgsql/bin:$PATH
fi
 
# Macports for Mac OS X
if [ -x /opt/local/bin/port ]; then
  export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH
  
  alias Pg='sudo port -v install'
  alias Ps='port search'
  alias Pi='port info'
  alias Pr='sudo port uninstall'
  alias dsl='port installed | grep -i'
 
  function InitMacports () {
    cmds=(
      cat chgrp chmod chown cp dd df diff du false head
      ln ls mkdir mkfifo mv pwd rm rmdir sleep sort
      stat tail tee true uniq who whoami yes
    )

    for cmd in $cmds; do
      ln -vs /opt/local/bin/g$cmd /usr/local/bin/$cmd
    done
  }
fi
 
# Fink for Mac OS X
if [ -x /sw/bin/init.sh ]; then
  _append_to_path /sw/bin/init.sh
fi