#
# Enables local Perl module installation on Mac OS X and defines aliases.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# For Perl older than 5.10.14, install local::lib.
#   curl -L -C - -O http://search.cpan.org/CPAN/authors/id/A/AP/APEIRON/local-lib-1.008004.tar.gz
#   tar xvf local-lib-1.008004.tar.gz
#   cd local-lib-1.008004
#   perl Makefile.PL --bootstrap=$HOME/Library/Perl/5.12
#   make && make test && make install
#
# Install cpanminus:
#   curl -L http://cpanmin.us | perl - --self-upgrade
#
if [[ "$OSTYPE" == darwin* ]]; then
  # Perl is slow; cache its output.
  cache_file="${0:h}/cache.zsh"
  perl_path="$HOME/Library/Perl/5.12"
  if [[ -f "$perl_path/lib/perl5/local/lib.pm" ]]; then
    manpath=("$perl_path/man" $manpath)
    if [[ ! -f "$cache_file" ]]; then
      perl -I$perl_path/lib/perl5 -Mlocal::lib=$perl_path >! "$cache_file"
      source "$cache_file"
    else
      source "$cache_file"
    fi
  fi
  unset perl_path
  unset cache_file

  # Set environment variables for launchd processes.
  for env_var in PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT PERL5LIB; do
    launchctl setenv "$env_var" "${(P)env_var}" &!
  done
  unset env_var
fi

# Aliases
alias pbi='perlbrew install'
alias pbl='perlbrew list'
alias pbo='perlbrew off'
alias pbs='perlbrew switch'
alias pbu='perlbrew use'
alias ple='perl -wlne'
alias pd='perldoc'

