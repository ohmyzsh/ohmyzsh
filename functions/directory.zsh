setopt auto_cd              # Auto cd to a directory without typing cd.
setopt auto_pushd           # Push the old directory onto the stack on cd.
setopt pushd_ignore_dups    # Don't store duplicates in the stack.
setopt pushd_silent         # Do not print the directory stack after pushd or popd.
setopt pushd_to_home        # Push to home directory when no argument is given.
setopt pushd_minus          # Use +/-n to specify a directory in the stack.
setopt cdable_vars          # Change directory to a path stored in a variable.
setopt auto_name_dirs       # Auto add variable-stored paths to ~ list.
setopt multios              # Write to multiple descriptors.
setopt extended_glob        # Use extended globbing syntax.
unsetopt clobber            # Don't overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.

alias 1='cd -'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

