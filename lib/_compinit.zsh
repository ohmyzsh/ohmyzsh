# Load all stock functions (from $fpath files)
autoload -U compaudit compinit

# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

# Handle completions insecurities (i.e., completion-dependent directories with
# insecure ownership or permissions) by:
#
# * Human-readably notifying the user of these insecurities.
function handle_completion_insecurities() {
  # List of the absolute paths of all unique insecure directories, split on
  # newline from compaudit()'s output resembling:
  #
  #     There are insecure directories:
  #     /usr/share/zsh/site-functions
  #     /usr/share/zsh/5.0.6/functions
  #     /usr/share/zsh
  #     /usr/share/zsh/5.0.6
  #
  # Since the ignorable first line is printed to stderr and thus not captured,
  # stderr is squelched to prevent this output from leaking to the user.
  local -aU insecure_dirs
  insecure_dirs=( ${(f@):-"$(compaudit 2>/dev/null)"} )

  # If no such directories exist, get us out of here.
  [[ -z "${insecure_dirs}" ]] && return

  # List ownership and permissions of all insecure directories.
  print "[oh-my-zsh] Insecure completion-dependent directories detected:"
  ls -ld "${(@)insecure_dirs}"

  cat <<EOD

[oh-my-zsh] For safety, we will not load completions from these directories until
[oh-my-zsh] you fix their permissions and ownership and restart zsh.
[oh-my-zsh] See the above list for directories with group or other writability.

[oh-my-zsh] To fix your permissions you can do so by disabling
[oh-my-zsh] the write permission of "group" and "others" and making sure that the
[oh-my-zsh] owner of these directories is either root or your current user.
[oh-my-zsh] The following command may help:
[oh-my-zsh]     compaudit | xargs chmod g-w,o-w

[oh-my-zsh] If the above didn't help or you want to skip the verification of
[oh-my-zsh] insecure directories you can set the variable ZSH_DISABLE_COMPFIX to
[oh-my-zsh] "true" before oh-my-zsh is sourced in your zshrc file.

EOD
}

#
function run_compinit() {
  # Construct zcompdump OMZ metadata
  local zcompdump_revision="#omz revision: $(builtin cd -q "$ZSH"; git rev-parse HEAD 2>/dev/null)"
  local zcompdump_fpath="#omz fpath: $fpath"
  local zcompdump_refresh=

  # Delete the zcompdump file if OMZ zcompdump metadata changed
  if ! command grep -q -Fx "$zcompdump_revision" "$ZSH_COMPDUMP" 2>/dev/null \
     || ! command grep -q -Fx "$zcompdump_fpath" "$ZSH_COMPDUMP" 2>/dev/null; then
    command rm -f "$ZSH_COMPDUMP"
    zcompdump_refresh=1
  fi

  if [[ $ZSH_DISABLE_COMPFIX != true ]]; then
    # If completion insecurities exist, warn the user
    handle_completion_insecurities
    # Load only from secure directories
    compinit -i -C -d "${ZSH_COMPDUMP}"
  else
    # If the user wants it, load from all found directories
    compinit -u -C -d "${ZSH_COMPDUMP}"
  fi

  # Append zcompdump metadata if missing
  if (( $zcompdump_refresh )); then
    # Use `tee` in case the $ZSH_COMPDUMP filename is invalid, to silence the error
    # See https://github.com/ohmyzsh/ohmyzsh/commit/dd1a7269#commitcomment-39003489
    tee -a "$ZSH_COMPDUMP" &>/dev/null <<EOF

$zcompdump_revision
$zcompdump_fpath
EOF
    fi
}
run_compinit
