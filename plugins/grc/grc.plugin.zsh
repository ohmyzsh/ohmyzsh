#File from https://github.com/garabik/grc.git repo


if [[ "$TERM" != dumb ]] && (( $+commands[grc] )) ; then
# Prevent grc aliases from overriding zsh completions.
  setopt COMPLETE_ALIASES
# Supported commands
  cmds=(
    cc \
    configure \
    cvs \
    df \
    diff \
    dig \
    gcc \
    gmake \
    ifconfig \
    last \
    ldap \
    ls \
    make \
    mount \
    mtr \
    netstat \
    ping \
    ping6 \
    ps \
    traceroute \
    traceroute6 \
    wdiff \
  );
# Set alias for available commands.
for cmd in $cmds ; do
if (( $+commands[$cmd] )) ; then
alias $cmd="grc --colour=auto $cmd"
fi
done
# Clean up variables
unset cmds cmd
fi
