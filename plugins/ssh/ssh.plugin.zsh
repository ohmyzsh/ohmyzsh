############################################################
# Take all host sections in .ssh/config and offer them for
# completion as hosts (e.g. for ssh, rsync, scp and the like)
# Filter out wildcard host sections.
# If the .ssh/config has Include directives, load them too.
function _load_ssh_hosts {
  local conf="$1"
  if [[ -f "$conf" ]]; then
    local _ssh_hosts=($(
      egrep '^Host\ .*' "$conf" |\
      awk '{for (i=2; i<=NF; i++) print $i}' |\
      sort |\
      uniq |\
      grep -v '^*' |\
      sed -e 's/\.*\*$//'
    ))
    echo "${_ssh_hosts[@]}"
  fi
}

# XXX: We could make it recursive but won't implement for now
function _find_include_files {
  local conf="$1"
  if [[ -f "$conf" ]]; then
    egrep '^Include\ .*' "$conf" |\
    awk '{for (i=2; i<=NF; i++) print $i}'
  fi
}

all_hosts=($(_load_ssh_hosts "$HOME/.ssh/config"))

_find_include_files "$HOME/.ssh/config" | while read include_file; do
  # omz doesn't know "~" directory
  if [[ "$include_file" == ~* ]]; then
    include_file="${HOME}${include_file:1}"
  fi
  if [[ -f "$include_file" ]]; then
    hosts=($(_load_ssh_hosts "$include_file"))
    all_hosts+=("${hosts[@]}")
  fi
done

zstyle ':completion:*:hosts' hosts "${all_hosts[@]}"

unset -f _load_ssh_hosts
unset -f _find_include_files
unset all_hosts

############################################################
# Remove host key from known hosts based on a host section
# name from .ssh/config
function ssh_rmhkey {
  local ssh_configfile="$HOME/.ssh/config"
  local ssh_host="$1"
  if [[ -z "$ssh_host" ]]; then return; fi
  ssh-keygen -R $(grep -A10 "$ssh_host" "$ssh_configfile" | grep -i HostName | head -n 1 | awk '{print $2}')
}
compctl -k hosts ssh_rmhkey

############################################################
# Load SSH key into agent
function ssh_load_key() {
  local key="$1"
  if [[ -z "$key" ]]; then return; fi
  local keyfile="$HOME/.ssh/$key"
  local keysig=$(ssh-keygen -l -f "$keyfile")
  if ( ! ssh-add -l | grep -q "$keysig" ); then
    ssh-add "$keyfile"
  fi
}

############################################################
# Remove SSH key from agent
function ssh_unload_key {
  local key="$1"
  if [[ -z "$key" ]]; then return; fi
  local keyfile="$HOME/.ssh/$key"
  local keysig=$(ssh-keygen -l -f "$keyfile")
  if ( ssh-add -l | grep -q "$keysig" ); then
    ssh-add -d "$keyfile"
  fi
}
