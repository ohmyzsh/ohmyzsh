# BASH completion script for Drush.
#
# Place this in your /etc/bash_completion.d/ directory or source it from your
# ~/.bash_completion or ~/.bash_profile files.  Alternatively, source
# examples/example.bashrc instead, as it will automatically find and source
# this file.
#
# If you're using ZSH instead of BASH, add the following to your ~/.zshrc file
# and source it.
#
#   autoload bashcompinit
#   bashcompinit
#   source /path/to/your/drush.complete.sh

# Ensure drush is available.
which drush > /dev/null || alias drush &> /dev/null || return

__drush_ps1() {
  f="${TMPDIR:-/tmp/}/drush-env-${USER}/drush-drupal-site-$$"
  if [ -f $f ]
  then
    __DRUPAL_SITE=$(cat "$f")
  else
    __DRUPAL_SITE="$DRUPAL_SITE"
  fi

  # Set DRUSH_PS1_SHOWCOLORHINTS to a non-empty value and define a
  # __drush_ps1_colorize_alias() function for color hints in your Drush PS1
  # prompt. See example.prompt.sh for an example implementation.
  if [ -n "${__DRUPAL_SITE-}" ] && [ -n "${DRUSH_PS1_SHOWCOLORHINTS-}" ]; then
    __drush_ps1_colorize_alias
  fi

  [[ -n "$__DRUPAL_SITE" ]] && printf "${1:- (%s)}" "$__DRUPAL_SITE"
}

# Completion function, uses the "drush complete" command to retrieve
# completions for a specific command line COMP_WORDS.
_drush_completion() {
  # Set IFS to newline (locally), since we only use newline separators, and
  # need to retain spaces (or not) after completions.
  local IFS=$'\n'
  # The '< /dev/null' is a work around for a bug in php libedit stdin handling.
  # Note that libedit in place of libreadline in some distributions. See:
  # https://bugs.launchpad.net/ubuntu/+source/php5/+bug/322214
  COMPREPLY=( $(drush --early=includes/complete.inc "${COMP_WORDS[@]}" < /dev/null 2> /dev/null) )
}

# Register our completion function. We include common short aliases for Drush.
complete -o bashdefault -o default -o nospace -F _drush_completion d dr drush drush5 drush6 drush7 drush8 drush.php
