# Adapted from: https://github.com/garabik/grc/blob/master/grc.zsh

if [[ "$TERM" = dumb ]] || (( ! $+commands[grc] )); then
  return
fi

# Supported commands
cmds=(
  cc
  configure
  cvs
  df
  diff
  dig
  gcc
  gmake
  ifconfig
  iwconfig
  last
  ldap
  make
  mount
  mtr
  netstat
  ping
  ping6
  ps
  traceroute
  traceroute6
  wdiff
  whois
)

# Set alias for supported commands
for cmd in $cmds; do
  if (( $+commands[$cmd] )); then
    eval "function $cmd {
      grc --colour=auto \"${commands[$cmd]}\" \"\$@\"
    }"
  fi
done

# Clean up variables
unset cmds cmd
