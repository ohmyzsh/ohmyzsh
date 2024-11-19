# https://github.com/dbbolton
#
# Below are some useful Perl-related aliases/functions that I use with zsh.


# Aliases ###################################################################

# perlbrew ########
alias pbi='perlbrew install'
alias pbl='perlbrew list'
alias pbo='perlbrew off'
alias pbs='perlbrew switch'
alias pbu='perlbrew use'

# Perl ############

# perldoc`
alias pd='perldoc'

# use perl like awk/sed
alias ple='perl -wlne'

# show the latest stable release of Perl
alias latest-perl='curl -s https://www.perl.org/get.html | perl -wlne '\''if (/perl\-([\d\.]+)\.tar\.gz/) { print $1; exit;}'\'



# Functions #################################################################

# newpl - creates a basic Perl script file and opens it with $EDITOR
newpl () {
	# set $EDITOR to 'vim' if it is undefined
	[[ -z $EDITOR ]] && EDITOR=vim

	# if the file exists, just open it
	[[ -e $1 ]] && print "$1 exists; not modifying.\n" && $EDITOR $1

	# if it doesn't, make it, and open it
	[[ ! -e $1 ]] && print '#!/usr/bin/perl'"\n"'use strict;'"\n"'use warnings;'\
		"\n\n" > $1 && $EDITOR $1
}


# pgs - Perl Global Substitution
# find pattern		= 1st arg
# replace pattern	= 2nd arg
# filename			= 3rd arg
pgs() { # [find] [replace] [filename]
    perl -i.orig -pe 's/'"$1"'/'"$2"'/g' "$3"
}


# Perl grep, because 'grep -P' is terrible. Lets you work with pipes or files.
prep() { # [pattern] [filename unless STDOUT]
    perl -nle 'print if /'"$1"'/;' $2
}

# If the 'perlbrew' function isn't defined, perlbrew isn't setup.
if ! typeset -f perlbrew > /dev/null; then
  # Has PERLBREW_ROOT been set prior, and is it a valid directory?  If so, store
  # value
  if [[ -n "${PERLBREW_ROOT}" && -d "{{PERLBREW_ROOT}" ]]; then
    perlbrew_root="${PERLBREW_ROOT}"
  fi

  # If perlbrew_root isn't set yet, then set the default path
  if [[ -z "${perlbrew_root}" ]]; then
    perlbrew_root="${HOME}/perl5/perlbrew"
  fi

  # If we can find perlbrew's 'bashrc' (yes, I know!)...
  if [[ -d "${perlbrew_root}" && -f "${perlbrew_root}/etc/bashrc" ]]; then
    # and if NO_AUTO_ADD isn't set
    if [[ -z "${PERLBREW_NO_AUTO_ADD}" ]]; then
      # Initialize perlbrew
      source "${perlbrew_root}/etc/bashrc"
    fi
  fi

  # Clear our temporary variable
  unset perlbrew_root
fi
