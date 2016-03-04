# Variables
pkgsrc=/opt/pkg
ports=/opt/ports

# Some global vars
export EDITOR=vim
export WORKON_HOME=/Volumes/DATA/dev/python/.virtualenvs
export PROJECT_HOME=/Volumes/DATA/dev/python
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'

# Custom paths
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
export MANPATH=/usr/local/share/man:$MANPATH

# PkgSrc paths
#export PATH=$pkgsrc/bin:$pkgsrc/sbin:$pkgsrc/gnu/bin:$PATH
#export MANPATH=$pkgsrc/man:$pkgsrc/share/man:$MANPATH

# MacPorts paths
#export PATH=$ports/bin:$ports/sbin:$PATH
#export INFOPATH=$ports/share/info:$INFOPATH
#export MANPATH=$ports/man:$MANPATH

# TeX Live paths
export INFOPATH=/usr/local/texlive/2015/texmf-dist/doc/info:$INFOPATH
export MANPATH=/usr/local/texlive/2015/texmf-dist/doc/man:$MANPATH
export PATH=/usr/local/texlive/2015/bin/x86_64-darwin:$PATH

# Perl paths
PATH="/Users/jeff/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/Users/jeff/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/jeff/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/jeff/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/jeff/perl5"; export PERL_MM_OPT;

# Brew
export HOMEBREW_GITHUB_API_TOKEN="ff63b6db62e214113aec1736b18d871939c06b39"

# Evaluate system PATH
#if [ -x /usr/libexec/path_helper ]; then
#    eval `/usr/libexec/path_helper -s`
#fi

source $(which virtualenvwrapper.sh)
