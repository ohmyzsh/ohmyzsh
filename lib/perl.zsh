# oh-my-zsh library helper file for Perl prompts and the like

ZSH_THEME_PERL_PROMPT_PREFIX=""
ZSH_THEME_PERL_PROMPT_SUFFIX=""

function perl_prompt_info {

    # there are a number of environment variables we might expect to see in a
    # typical, modern Perl environment.  Three of the more popular (and
    # mildly, at least, sane ways) options involve just using the system perl,
    # using the system perl with a local::lib-managed environment, and using
    # perlbrew (and letting it manage local::lib libraries, if any).  We can
    # expect to see things like this:

    # e.g.
    #PERLBREW_BASHRC_VERSION=0.63
    #PERLBREW_HOME=/home/rsrchboy/.perlbrew
    #PERLBREW_LIB=trunk
    #PERLBREW_MANPATH=/home/rsrchboy/.perlbrew/libs/perl-5.16.2@trunk/man:/home/rsrchboy/perl5/perlbrew/perls/perl-5.16.2/man
    #PERLBREW_PATH=/home/rsrchboy/.perlbrew/libs/perl-5.16.2@trunk/bin:/home/rsrchboy/perl5/perlbrew/bin:/home/rsrchboy/perl5/perlbrew/perls/perl-5.16.2/bin
    #PERLBREW_PERL=perl-5.16.2
    #PERLBREW_ROOT=/home/rsrchboy/perl5/perlbrew
    #PERLBREW_VERSION=0.63
    #PERL_LOCAL_LIB_ROOT=/home/rsrchboy/.perlbrew/libs/perl-5.16.2@trunk
    #PERL5LIB=/home/rsrchboy/.perlbrew/libs/perl-5.16.2@trunk/lib/perl5

    # we assume perlbrew and local::lib, but don't check for too much else.

    # XXX: NOT FINISHED!
    # TODO: needs determination of *where* perl is if not /usr/bin/perl, as that's not system perl
    #

    #PSTAT=''

    if [ -z $PERLBREW_PERL ] ; then
        PSTAT="system-perl"
        if [ $PERL_LOCAL_LIB_ROOT ] ; then
            PSTAT="$PSTAT@${PERL_LOCAL_LIB_ROOT/#:$HOME/~}"
        fi
    elif [ $PERLBREW_PERL ] ; then
        PSTAT="$PERLBREW_PERL"
        if [ $PERLBREW_LIB ] ; then
            PSTAT="$PSTAT@$PERLBREW_LIB"
        fi
    elif [ $PERL_LOCAL_LIB_ROOT ] ; then
        #echo ' %{$_is%}and %{$fg[cyan]%}local::lib at' $PERL_LOCAL_LIB_ROOT
    fi

    # only print if we actually have anything interesting to print
    test ! -z "$PSTAT" && echo "$ZSH_THEME_PERL_PROMPT_PREFIX$PSTAT$ZSH_THEME_PERL_PROMPT_SUFFIX"
}

