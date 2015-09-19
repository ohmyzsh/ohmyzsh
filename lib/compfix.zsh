# Handle completions insecurities (i.e., completion-dependent directories with
# insecure ownership or permissions) by:
#
# * Human-readably notifying the user of these insecurities.
# * Moving away all existing completion caches to a temporary directory. Since
#   any of these caches may have been generated from insecure directories, they
#   are all suspect now. Failing to do so typically causes subsequent compinit()
#   calls to fail with "command not found: compdef" errors. (That's bad.)
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
  if (( ! ${#insecure_dirs} )); then
      print "[oh-my-zsh] No insecure completion-dependent directories detected."
      return
  fi

  # List ownership and permissions of all insecure directories.
  print "[oh-my-zsh] Insecure completion-dependent directories detected:"
  ls -ld "${(@)insecure_dirs}"
  print "[oh-my-zsh] For safety, completions will be disabled until you manually fix all"
  print "[oh-my-zsh] insecure directory permissions and ownership and restart oh-my-zsh."
  print "[oh-my-zsh] See the above list for directories with group or other writability.\n"

  # Locally enable the "NULL_GLOB" option, thus removing unmatched filename
  # globs from argument lists *AND* printing no warning when doing so. Failing
  # to do so prints an unreadable warning if no completion caches exist below.
  setopt local_options null_glob

  # List of the absolute paths of all unique existing completion caches.
  local -aU zcompdump_files
  zcompdump_files=( "${ZSH_COMPDUMP}"(.) "${ZDOTDIR:-${HOME}}"/.zcompdump* )

  # Move such caches to a temporary directory.
  if (( ${#zcompdump_files} )); then
    # Absolute path of the directory to which such files will be moved.
    local ZSH_ZCOMPDUMP_BAD_DIR="${ZSH_CACHE_DIR}/zcompdump-bad"

    # List such files first.
    print "[oh-my-zsh] Insecure completion caches also detected:"
    ls -l "${(@)zcompdump_files}"

    # For safety, move rather than permanently remove such files.
    print "[oh-my-zsh] Moving to \"${ZSH_ZCOMPDUMP_BAD_DIR}/\"...\n"
    mkdir -p "${ZSH_ZCOMPDUMP_BAD_DIR}"
    mv "${(@)zcompdump_files}" "${ZSH_ZCOMPDUMP_BAD_DIR}/"
  fi
}
