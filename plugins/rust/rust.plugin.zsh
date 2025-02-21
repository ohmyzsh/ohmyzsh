if ! (( $+commands[rustup] && $+commands[cargo] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `cargo`. Otherwise, compinit will have already done that
if [[ ! -f "$ZSH_CACHE_DIR/completions/_cargo" ]]; then
  autoload -Uz _cargo
  typeset -g -A _comps
  _comps[cargo]=_cargo
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rustup`. Otherwise, compinit will have already done that
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rustup" ]]; then
  autoload -Uz _rustup
  typeset -g -A _comps
  _comps[rustup]=_rustup
fi

# Generate completion files in the background
rustup completions zsh >| "$ZSH_CACHE_DIR/completions/_rustup" &|
cat >| "$ZSH_CACHE_DIR/completions/_cargo" <<'EOF'
#compdef cargo
source "$(rustup run ${${(z)$(rustup default)}[1]} rustc --print sysroot)"/share/zsh/site-functions/_cargo
EOF
