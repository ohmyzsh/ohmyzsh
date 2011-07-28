# Smart URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# General
setopt rc_quotes          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
unsetopt mail_warning     # Don't print a warning message if a mail file has been accessed

# Jobs
setopt long_list_jobs     # List jobs in the long format by default.
setopt auto_resume        # Attempt to resume existing job before creating a new process.
setopt notify             # Report status of background jobs immediately.
unsetopt bg_nice          # Don't run all background jobs at a lower priority.
unsetopt hup              # Don't kill jobs on shell exit.
unsetopt check_jobs       # Don't report on jobs when shell exit.

# PATH
typeset -U path manpath cdpath fpath

path=(
  $HOME/.tilde/bin
  $HOME/.tilde/opt/bin
  /usr/local/bin
  /usr/local/sbin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
)

for path_file in /etc/paths.d/*; do
  path+=($(<$path_file))
done

manpath=(
  $HOME/.tilde/share/man
  $HOME/.tilde/opt/share/man
  /usr/local/share/man
  /usr/share/man
)

for path_file in /etc/manpaths.d/*; do
  manpath+=($(<$path_file))
done

cdpath=(
  $HOME
  $HOME/Developer
)

# Language
export LANG="en_AU.UTF-8"
export LC_ALL="$LANG"
export LC_COLLATE="$LANG"
export LC_CTYPE="$LANG"
export LC_MESSAGES="$LANG"
export LC_MONETARY="$LANG"
export LC_NUMERIC="$LANG"
export LC_TIME="$LANG"

# Editors
export EDITOR="vim"
export VISUAL="vim"
export PAGER='less'

# Grep
if [[ "$DISABLE_COLOR" != 'true' ]]; then
  export GREP_COLOR='37;45'
  export GREP_OPTIONS='--color=auto'
fi

# Browser (Default)
if (( $+commands[xdg-open] )); then
  export BROWSER='xdg-open'
fi

if (( $+commands[open] )); then
  export BROWSER='open'
fi

# Less
export LESSCHARSET="UTF-8"
export LESSHISTFILE='-'
export LESSEDIT='vim ?lm+%lm. %f'
export LESS='-F -g -i -M -R -S -w -X -z-4'

if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# Termcap
if [[ "$DISABLE_COLOR" != 'true' ]]; then
  export LESS_TERMCAP_mb=$'\E[01;31m'      # begin blinking
  export LESS_TERMCAP_md=$'\E[01;31m'      # begin bold
  export LESS_TERMCAP_me=$'\E[0m'          # end mode
  export LESS_TERMCAP_se=$'\E[0m'          # end standout-mode
  export LESS_TERMCAP_so=$'\E[00;47;30m'   # begin standout-mode
  export LESS_TERMCAP_ue=$'\E[0m'          # end underline
  export LESS_TERMCAP_us=$'\E[01;32m'      # begin underline
fi

