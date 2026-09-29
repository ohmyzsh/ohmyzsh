# Don't try to load nvm if command already available
# Note: nvm is a function so we need to use `which`
which nvm &>/dev/null && return

# See https://github.com/nvm-sh/nvm#installation-and-update
if [[ -z "$NVM_DIR" ]]; then
  if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
  elif [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvm" ]]; then
    export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
  elif (( $+commands[brew] )); then
    NVM_HOMEBREW="${NVM_HOMEBREW:-${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/nvm}"
    if [[ -d "$NVM_HOMEBREW" ]]; then
      export NVM_DIR="$NVM_HOMEBREW"
    fi
  fi
fi

if [[ -z "$NVM_DIR" ]] || [[ ! -f "$NVM_DIR/nvm.sh" ]]; then
  return
fi

function _omz_nvm_setup_completion {
  local _nvm_completion
  # Load nvm bash completion
  for _nvm_completion in "$NVM_DIR/bash_completion" "$NVM_HOMEBREW/etc/bash_completion.d/nvm"; do
    if [[ -f "$_nvm_completion" ]]; then
      # Load bashcompinit
      autoload -U +X bashcompinit && bashcompinit
      # Bypass compinit call in nvm bash completion script. See:
      # https://github.com/nvm-sh/nvm/blob/4436638/bash_completion#L86-L93
      ZSH_VERSION= source "$_nvm_completion"
      break
    fi
  done
  unfunction _omz_nvm_setup_completion
}

function _omz_nvm_setup_autoload {
  if ! zstyle -t ':omz:plugins:nvm' autoload; then
    unfunction _omz_nvm_setup_autoload
    return
  fi

  # Autoload nvm when finding a .nvmrc file in the current directory
  # Adapted from: https://github.com/nvm-sh/nvm#zsh
  function load-nvmrc {
    local nvmrc_path="$(nvm_find_nvmrc)"
    local nvm_silent=""
    zstyle -t ':omz:plugins:nvm' silent-autoload && nvm_silent="--silent"

    if [[ -n "$nvmrc_path" ]]; then
      local nvmrc_node_version=$(nvm version $(command cat "$nvmrc_path" | tr -dc '[:print:]'))

      if [[ "$nvmrc_node_version" = "N/A" ]]; then
        nvm install
      elif [[ "$nvmrc_node_version" != "$(nvm version)" ]]; then
        nvm use $nvm_silent
      fi
    elif [[ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ]] && [[ "$(nvm version)" != "$(nvm version default)" ]]; then
      [[ -z $nvm_silent ]] && echo "Reverting to nvm default version"

      nvm use default $nvm_silent
    fi
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd load-nvmrc

  load-nvmrc
  unfunction _omz_nvm_setup_autoload
}

# Put the default node on PATH without loading nvm, as `nvm use default` would.
# Global npm tools (eslint, tsc...) then work before nvm is loaded.
# Only handles a default alias that resolves to an installed version
# (v20.11.1, 20, 20.11, lts/*, lts/iron); in any other case it does nothing.
function _omz_nvm_default_path {
  emulate -L zsh -o extended_glob

  # PATH already has an nvm dir (parent shell): leave it to nvm, as before
  [[ ":$PATH:" == *":$NVM_DIR/"* ]] && return
  # nvm puts NVM_DIR into grep/sed patterns: with regex characters it matches differently
  [[ "$NVM_DIR" == *[][\\*^\$+?\(\){}\|\#]* ]] && return

  # Follow the alias chain (default -> lts/* -> lts/iron -> v20.x) like
  # nvm_alias: skip comments, blank lines and trailing spaces, use the first line.
  # The hop limit stops alias loops; a loop then fails the version check below.
  local name=default target line i
  for i in {1..10}; do
    [[ -f "$NVM_DIR/alias/$name" ]] || return
    target=
    for line in "${(@f)"$(<"$NVM_DIR/alias/$name")"}"; do
      line=${${line%%\#*}%%[[:space:]]#}
      [[ -n "$line" ]] && { target=$line; break }
    done
    [[ -n "$target" && -f "$NVM_DIR/alias/$target" ]] || break
    name=$target
  done

  # Match an installed version like nvm_version: exact, or the highest for a prefix
  target=v${target#v}
  [[ "$target" == v<->(.<->)(#c0,2) ]] || return
  local -a dirs=("$NVM_DIR/versions/node/$target"(N/) "$NVM_DIR/versions/node/$target".*(N/nOn))
  (( $#dirs )) && [[ -x "$dirs[1]/bin/node" ]] || return

  path=("$dirs[1]/bin" $path)
  # nvm changes MANPATH only if `manpath` exists; an empty MANPATH stays empty
  # (nvm uses `local MANPATH` for that case)
  [[ -n "$MANPATH" ]] && (( $+commands[manpath] )) && export MANPATH="$dirs[1]/share/man:$MANPATH"
  export NVM_BIN="$dirs[1]/bin" NVM_INC="$dirs[1]/include/node"
}

if zstyle -t ':omz:plugins:nvm' lazy; then
  _omz_nvm_default_path
  unfunction _omz_nvm_default_path

  # Call nvm when first using nvm, node, npm, pnpm, yarn, corepack or other commands in lazy-cmd
  zstyle -a ':omz:plugins:nvm' lazy-cmd nvm_lazy_cmd
  nvm_lazy_cmd=(_omz_nvm_load nvm node npm npx pnpm pnpx yarn corepack $nvm_lazy_cmd) # default values
  eval "
    function $nvm_lazy_cmd {
      for func in $nvm_lazy_cmd; do
        if (( \$+functions[\$func] )); then
          unfunction \$func
        fi
      done
      # Load nvm if it exists in \$NVM_DIR
      [[ -f \"\$NVM_DIR/nvm.sh\" ]] && source \"\$NVM_DIR/nvm.sh\"
      _omz_nvm_setup_completion
      _omz_nvm_setup_autoload
      if [[ \"\$0\" != _omz_nvm_load ]]; then
        \"\$0\" \"\$@\"
      fi
    }
  "
  unset nvm_lazy_cmd
else
  unfunction _omz_nvm_default_path
  source "$NVM_DIR/nvm.sh"
  _omz_nvm_setup_completion
  _omz_nvm_setup_autoload
fi
