alias fl="flutter"
alias flattach="flutter attach"
alias flb="flutter build"
alias flchnl="flutter channel"
alias flc="flutter clean"
alias fldvcs="flutter devices"
alias fldoc="flutter doctor"
alias flpub="flutter pub"
alias flget="flutter pub get"
alias flr="flutter run"
alias flrd="flutter run --debug"
alias flrp="flutter run --profile"
alias flrr="flutter run --release"
alias flupgrd="flutter upgrade"

# COMPLETION FUNCTION
if (( ! $+commands[flutter] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `flutter`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_flutter" ]]; then
  typeset -g -A _comps
  autoload -Uz _flutter
  _comps[flutter]=_flutter
fi

flutter zsh-completion < /dev/null >| "$ZSH_CACHE_DIR/completions/_flutter" &|