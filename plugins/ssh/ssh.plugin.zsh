############################################################
# Take all host sections in .ssh/config and offer them for
# completion as hosts (e.g. for ssh, rsync, scp and the like)
# Filter out wildcard host sections.
_ssh_configfile="$HOME/.ssh/config"
if [[ -f "$_ssh_configfile" ]]; then

  parse_ssh_config() {
    local config_file="$1"

    if [[ -f "$config_file" ]]; then
      # Extract all "Host" entries
      local hosts=($(
       egrep -i '^Host.*' "$config_file" |\
        awk '{for (i=2; i<=NF; i++) print $i}' |\
        sort |\
        uniq |\
        grep -v '^*' |\
        sed -e 's/\.*\*$//'
              ))

    # Add hosts to the global array
    _ssh_hosts+=("${hosts[@]}")

    # Handle Include directives by reading the files they reference
    local includes=($(egrep '^Include ' "$config_file" | awk '{print $2}'))

    # Loop through each included file or pattern
    for include in "${includes[@]}"; do

      # Resolve relative paths and handle wildcards
      for file in $(eval echo $include); do
        parse_ssh_config "$file"
      done
    done
    fi
  }


  _ssh_hosts=()
  # Start parsing from the main SSH config file
  _ssh_configfile="$HOME/.ssh/config"
  parse_ssh_config "$_ssh_configfile"
  _final_hosts=($(sort <<< "${_ssh_hosts[@]}" |\
        uniq |\
        grep -v '^*' |\
        sed -e 's/\.*\*$//'
          ))

  zstyle ':completion:*:hosts' hosts $_final_hosts
  unset _ssh_hosts
  unset _final_hosts
fi
unset _ssh_configfile

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
