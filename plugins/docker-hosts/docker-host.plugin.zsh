# MIT License
#
# Copyright (c) 2016 Buck Brady
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# initilizes the plugin dir
function dh-init() {
  if [ ! -d ~/.docker-hosts ]
  then
    mkdir -p ~/.docker-hosts
    touch ~/.docker-hosts/hosts
    touch ~/.docker-hosts/default
    printf "docker-host plugin intialized.\n"
  fi
}

# lists all hosts in hosts file
function dh-list() {
  dh-init
  printf '%-20s  %s\n' '-- Nickname --' '-- Host IP/FQDN --'
  awk -F',' '{printf "%-20s  %s\n", $1, $2}' \
    $HOME/.docker-hosts/hosts | grep -v "#"
}

# adds host to hostfile
function dh-add() {
  dh-init
  echo "$1,$2" >> ~/.docker-hosts/hosts
  printf 'Host "%s" added with IP/FQDN "%s"\n' $1 $2
}

# removes host from host file
function dh-remove() {
  mv $HOME/.docker-hosts/hosts $HOME/.docker-hosts/hosts.old
  grep -vw "$1" $HOME/.docker-hosts/hosts.old > $HOME/.docker-hosts/hosts
  rm -f $HOME/.docker-hosts/hosts.old
}

# sets $DOCKER_HOST to given host in hostfile
function dh-set() {
  dh-init
  host=`grep -w $1 $HOME/.docker-hosts/hosts | awk -F',' '{print $2}'`
  export DOCKER_HOST=tcp://$host
}

# loads the default host
function dh-get-default() {
  host=`cat $HOME/.docker-hosts/default`
  export DOCKER_HOST=tcp://$host
}

# sets host to be loaded as the default
function dh-set-default() {
  grep -w $1 $HOME/.docker-hosts/hosts \
    | awk -F',' '{print $2}' > $HOME/.docker-hosts/default
}

# list the current docker host
function dh-current() {
  printf 'Current Docker Host: %s\n' $DOCKER_HOST
}

# clears the $DOCKER_HOST env
function dh-clear() {
  export DOCKER_HOST=''
  print 'DOCKER_HOST is now empty, docker will try to connect to localhost socket.'
}

# load plugin
dh-init
dh-get-default
