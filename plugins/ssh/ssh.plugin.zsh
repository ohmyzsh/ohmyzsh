############################################################
# Take all host sections in .ssh/config and offer them for
# completion as hosts (e.g. for ssh, rsync, scp and the like)
# Filter out wildcard host sections.
local hosts
if [[ -f $HOME/.ssh/config ]]; then
  hosts=($(egrep '^Host.*' $HOME/.ssh/config | awk '{print $2}' | grep -v '^*' | sed -e 's/\.*\*$//'))
  zstyle ':completion:*:hosts' hosts $hosts
fi

############################################################
# Remove host key from known hosts based on a host section
# name from .ssh/config
function ssh_rmhkey {
  if [[ "x$1" == "x" ]]; then return; fi
  ssh-keygen -R $(grep -A10 $1 ~/.ssh/config | grep -i HostName | head -n 1 | awk '{print $2}')
}
compctl -k hosts ssh_rmhkey

############################################################
# Load SSH key into agent
function ssh_load_key() {
  local key=$1
  if [[ "$key" == "" ]]; then return; fi
  if ( ! ssh-add -l | grep -q $key ); then
    ssh-add ~/.ssh/$key;
  fi
}

############################################################
# Remove SSH key from agent
function ssh_unload_key {
  local key=$1
  if [[ "$key" == "" ]]; then return; fi
  if ( ssh-add -l|grep -q $key ); then
    local keyfile=$(ssh-add -l | grep $key | cut -d ' ' -f 3)
    ssh-add -d $keyfile
  fi
}
