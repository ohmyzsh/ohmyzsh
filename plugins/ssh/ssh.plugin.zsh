############################################################
# Take all host sections in .ssh/config and offer them for
# completion as hosts (e.g. for ssh, rsync, scp and the like)
# Filter out wildcard host sections.
_ssh_configfile="$HOME/.ssh/config"
if [[ -f "$_ssh_configfile" ]]; then
  _ssh_hosts=($(
    egrep '^Host.*' "$_ssh_configfile" |\
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
# Calculate SSH key fingerprint
function ssh_fingerprint {
  local fptype
  local quiet
  local ansi

  zmodload zsh/zutil
  zparseopts -D -- md5=fptype q=quiet n=ansi
  fptype="${fptype[*]}"
  if [[ -z $fptype ]]; then
    fptype="sha256"
  else
    fptype="${fptype:1}"
  fi
  if [[ -z ${ansi[*]} ]]; then
    ansi=("\e[1;30m" "\e[0m")
  else
    ansi=("" "")
  fi

  local keyfiles=( "$@" )
  if [[ ${#keyfiles[@]} == 0 ]]; then keyfiles=( "$HOME/.ssh/authorized_keys" ); fi
  local f
  for f in "${keyfiles[@]}"; do
    if [[ $quiet != "-q" ]]; then printf "${ansi[1]}$f:${ansi[2]}\n"; fi
    ssh-keygen -l -E "$fptype" -f "$f"
  done
}
alias ssh_fp='ssh_fingerprint'

