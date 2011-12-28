# Initializes Oh My Zsh.

# Check for the minimum supported version.
min_zsh_version=4.3.9
if ! autoload -Uz is-at-least || ! is-at-least "$min_zsh_version"; then
  print "omz: The minimum supported Zsh version is $min_zsh_version."
fi
unset min_zsh_version

# Disable color and theme in dumb terminals.
if [[ "$TERM" == 'dumb' ]]; then
  zstyle ':omz:*:*' color 'no'
  zstyle ':omz:prompt' theme 'off'
fi

# Get enabled plugins.
zstyle -a ':omz:load' plugin 'plugins'

# Add functions to fpath.
fpath=(
  ${0:h}/themes/*(/FN)
  ${plugins:+${0:h}/plugins/${^plugins}/{functions,completions}(/FN)}
  ${0:h}/{functions,completions}(/FN)
  $fpath
)

# Load and initialize the completion system ignoring insecure directories.
autoload -Uz compinit && compinit -i

# Source files (the order matters).
source "${0:h}/helper.zsh"
source "${0:h}/environment.zsh"
source "${0:h}/terminal.zsh"
source "${0:h}/keyboard.zsh"
source "${0:h}/completion.zsh"
source "${0:h}/history.zsh"
source "${0:h}/directory.zsh"
source "${0:h}/alias.zsh"
source "${0:h}/spectrum.zsh"
source "${0:h}/utility.zsh"

# Autoload Zsh function builtins.
autoload -Uz age
autoload -Uz zargs
autoload -Uz zcalc
autoload -Uz zmv

# Source plugins defined in ~/.zshrc.
for plugin in "$plugins[@]"; do
  zstyle ":omz:plugin:$plugin" enable 'yes'
  if [[ -f "${0:h}/plugins/$plugin/init.zsh" ]]; then
    source "${0:h}/plugins/$plugin/init.zsh"
  fi
done
unset plugin plugins

# Autoload Oh My Zsh functions.
for fdir in "$fpath[@]"; do
  if [[ "$fdir" == ${0:h}/(|*/)functions ]]; then
    for afunction in $fdir/[^_.]*(N.:t); do
      autoload -Uz $afunction
    done
  fi
done

# Set environment variables for launchd processes.
if [[ "$OSTYPE" == darwin* ]]; then
  for env_var in PATH MANPATH; do
    launchctl setenv "$env_var" "${(P)env_var}" &!
  done
fi

# Load and run the prompt theming system.
autoload -Uz promptinit && promptinit

# Load the prompt theme.
zstyle -a ':omz:prompt' theme 'prompt_argv'
prompt "$prompt_argv[@]"
unset prompt_argv

# Compile zcompdump, if modified, to increase startup speed.
if [[ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" ]] || [[ ! -f "$HOME/.zcompdump.zwc" ]]; then
  zcompile "$HOME/.zcompdump"
fi

