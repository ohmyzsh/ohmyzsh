function fzf_setup_using_base_dir() {
  local fzf_base fzf_shell fzfdirs dir

  test -d "${FZF_BASE}" && fzf_base="${FZF_BASE}"

  if [[ -z "${fzf_base}" ]]; then
    fzfdirs=(
      "${HOME}/.fzf"
      "${HOME}/.nix-profile/share/fzf"
      "${XDG_DATA_HOME:-$HOME/.local/share}/fzf"
      "/usr/local/opt/fzf"
      "/usr/share/fzf"
      "/usr/local/share/examples/fzf"
    )
    for dir in ${fzfdirs}; do
      if [[ -d "${dir}" ]]; then
        fzf_base="${dir}"
        break
      fi
    done

    if [[ -z "${fzf_base}" ]]; then
      if (( ${+commands[fzf-share]} )) && dir="$(fzf-share)" && [[ -d "${dir}" ]]; then
        fzf_base="${dir}"
      elif (( ${+commands[brew]} )) && dir="$(brew --prefix fzf 2>/dev/null)"; then
        if [[ -d "${dir}" ]]; then
          fzf_base="${dir}"
        fi
      fi
    fi
  fi

  if [[ ! -d "${fzf_base}" ]]; then
    return 1
  fi

  # Fix fzf shell directory for Arch Linux, NixOS or Void Linux packages
  if [[ ! -d "${fzf_base}/shell" ]]; then
    fzf_shell="${fzf_base}"
  else
    fzf_shell="${fzf_base}/shell"
  fi

  # Setup fzf binary path
  if (( ! ${+commands[fzf]} )) && [[ "$PATH" != *$fzf_base/bin* ]]; then
    export PATH="$PATH:$fzf_base/bin"
  fi

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "${fzf_shell}/completion.zsh" 2> /dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "${fzf_shell}/key-bindings.zsh"
  fi
}


function fzf_setup_using_debian() {
  if (( ! $+commands[dpkg] )) || ! dpkg -s fzf &>/dev/null; then
    # Either not a debian based distro, or no fzf installed
    return 1
  fi

  # NOTE: There is no need to configure PATH for debian package, all binaries
  # are installed to /usr/bin by default

  local completions key_bindings

  case $PREFIX in
    *com.termux*)
      # Support Termux package
      completions="${PREFIX}/share/fzf/completion.zsh"
      key_bindings="${PREFIX}/share/fzf/key-bindings.zsh"
      ;;
    *)
      # Determine completion file path: first bullseye/sid, then buster/stretch
      completions="/usr/share/doc/fzf/examples/completion.zsh"
      [[ -f "$completions" ]] || completions="/usr/share/zsh/vendor-completions/_fzf"
      key_bindings="/usr/share/doc/fzf/examples/key-bindings.zsh"
      ;;
  esac

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source $completions 2> /dev/null
  fi

  # Key bindings
  if [[ ! "$DISABLE_FZF_KEY_BINDINGS" == "true" ]]; then
    source $key_bindings
  fi

  return 0
}

function fzf_setup_using_opensuse() {
  # OpenSUSE installs fzf in /usr/bin/fzf
  # If the command is not found, the package isn't installed
  (( $+commands[fzf] )) || return 1

  # The fzf-zsh-completion package installs the auto-completion in
  local completions="/usr/share/zsh/site-functions/_fzf"
  # The fzf-zsh-completion package installs the key-bindings file in
  local key_bindings="/etc/zsh_completion.d/fzf-key-bindings"

  # If these are not found: (1) maybe we're not on OpenSUSE, or
  # (2) maybe the fzf-zsh-completion package isn't installed.
  if [[ ! -f "$completions" || ! -f "$key_bindings" ]]; then
    return 1
  fi

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

function fzf_setup_using_openbsd() {
  # openBSD installs fzf in /usr/local/bin/fzf
  if [[ "$OSTYPE" != openbsd* ]] || (( ! $+commands[fzf] )); then
    return 1
  fi

  # The fzf package installs the auto-completion in
  local completions="/usr/local/share/zsh/site-functions/_fzf_completion"
  # The fzf package installs the key-bindings file in
  local key_bindings="/usr/local/share/zsh/site-functions/_fzf_key_bindings"

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

function fzf_setup_using_cygwin() {
  # Cygwin installs fzf in /usr/local/bin/fzf
  if [[ "$OSTYPE" != cygwin* ]] || (( ! $+commands[fzf] )); then
    return 1
  fi

  # The fzf-zsh-completion package installs the auto-completion in
  local completions="/etc/profile.d/fzf-completion.zsh"
  # The fzf-zsh package installs the key-bindings file in
  local key_bindings="/etc/profile.d/fzf.zsh"

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

function fzf_setup_using_macports() {
  # If the command is not found, the package isn't installed
  (( $+commands[fzf] )) || return 1

  # The fzf-zsh-completion package installs the auto-completion in
  local completions="/opt/local/share/zsh/site-functions/fzf"
  # The fzf-zsh-completion package installs the key-bindings file in
  local key_bindings="/opt/local/share/fzf/shell/key-bindings.zsh"

  if [[ ! -f "$completions" || ! -f "$key_bindings" ]]; then
    return 1
  fi

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

# Indicate to user that fzf installation not found if nothing worked
function fzf_setup_error() {
  cat >&2 <<'EOF'
[oh-my-zsh] fzf plugin: Cannot find fzf installation directory.
Please add `export FZF_BASE=/path/to/fzf/install/dir` to your .zshrc
EOF
}

fzf_setup_using_openbsd \
  || fzf_setup_using_debian \
  || fzf_setup_using_opensuse \
  || fzf_setup_using_cygwin \
  || fzf_setup_using_macports \
  || fzf_setup_using_base_dir \
  || fzf_setup_error

unset -f -m 'fzf_setup_*'

if [[ -z "$FZF_DEFAULT_COMMAND" ]]; then
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  elif (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
  elif (( $+commands[ag] )); then
    export FZF_DEFAULT_COMMAND='ag -l --hidden -g "" --ignore .git'
  fi
fi
