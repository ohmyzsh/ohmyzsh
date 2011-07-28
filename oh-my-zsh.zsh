# Initializes OH MY ZSH.

# Disable color in dumb terminals.
if [[ "$TERM" == 'dumb' ]]; then
  DISABLE_COLOR='true'
fi

# Add functions to fpath.
fpath=($OMZ/themes/*(/) $OMZ/plugins/${^plugins} $OMZ/functions $fpath)

# Load and initialize the completion system.
autoload -Uz compinit && compinit -i

# Load all files in $OMZ/oh-my-zsh/lib/ that end in .zsh.
for function_file in $OMZ/functions/*.zsh; do
  source "$function_file"
done

# Load all plugins defined in ~/.zshrc.
for plugin in $plugins; do
  if [[ -f "$OMZ/plugins/$plugin/$plugin.plugin.zsh" ]]; then
    source "$OMZ/plugins/$plugin/$plugin.plugin.zsh"
  fi
done

# Load and run the prompt theming system.
autoload -Uz promptinit && promptinit -i

# Load the automatic recompiler.
autoload -Uz zrecompile

# Compile files.
for zsh_file in $HOME/.z{login,logout,profile,shenv,shrc,compdump}(N) $OMZ/*.zsh(N); do
  zrecompile -q -p -U -z "$zsh_file"
done

# Compile function directories.
for (( i=1; i <= $#fpath; i++ )); do
  function_dir="$fpath[i]"
  [[ "$function_dir" == (.|..) ]] \
    || [[ "$function_dir" == (.|..)/* ]] \
    || [[ ! -w "$function_dir:h" ]] && continue
  function_files=($function_dir/^*(\.(rej|orig)|~|\#)(N-.))
  [[ -n "$function_files" ]] \
    && function_files=(${${(M)function_files%/*/*}#/}) \
    && ( cd "$function_dir:h" && zrecompile -q -p -U -z "${function_dir:t}.zwc" "$function_files[@]" ) \
    && fpath[i]="$fpath[i].zwc"
done
unset function_dir
unset function_files

