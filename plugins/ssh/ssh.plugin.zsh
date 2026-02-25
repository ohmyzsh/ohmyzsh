############################################################
# Take all host sections in .ssh/config and offer them for
# completion as hosts (e.g. for ssh, rsync, scp and the like)
# Filter out wildcard host sections.
_ssh_configfile="$HOME/.ssh/config"
if [[ -f "$_ssh_configfile" ]]; then
  _ssh_hosts=($(
    grep -E '^Host.*' "$_ssh_configfile" |\
    awk '{for (i=2; i<=NF; i++) print $i}' |\
    sort |\
    uniq |\
    grep -v '^*' |\
    sed -e 's/\.*\*$//'
  ))
  zstyle ':completion:*:hosts' hosts $_ssh_hosts
  unset _ssh_hosts
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

############################################################
# Port forwarding
function ssh_port_forward {
  if [[ $# -lt 2 ]]; then
    echo "Usage: ssh port-forward <local_port>:<remote_port> user@host [ssh options]"
    return 1
  fi
  local ports="$1"
  shift
  local local_port="${ports%%:*}"
  local remote_port="${ports##*:}"
  if [[ -z "$local_port" || -z "$remote_port" ]]; then
    echo "Invalid port format. Use local_port:remote_port"
    return 1
  fi
  command ssh -N -L "${local_port}:127.0.0.1:${remote_port}" "$@"
}

############################################################
# SSH SOCKS proxy
function ssh_proxy {
  local local_port="$1"
  if [[ -z "$local_port" ]]; then
    echo "Usage: ssh proxy <local_port> user@host [ssh options]"
    return 1
  fi
  shift
  if [[ -z "$local_port" || "$local_port" != <-> ]]; then
    echo "Invalid port. Use a numeric local port."
    return 1
  fi
  if [[ $# -lt 1 ]]; then
    echo "Usage: ssh proxy local_port user@host [ssh options]"
    return 1
  fi

  command ssh -D "${local_port}" -N "$@"
}

############################################################
# Configure ssh command to support custom subcommands
function ssh {
  case "$1" in
    port-forward|pf)
      shift
      ssh_port_forward "$@"
      return $?
      ;;
    proxy|px)
      shift
      ssh_proxy "$@"
      return $?
      ;;
    *)
      command ssh "$@"
      ;;
  esac
}
