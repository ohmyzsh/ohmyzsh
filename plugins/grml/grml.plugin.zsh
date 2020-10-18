# Filename:      /etc/zsh/zshrc
# Purpose:       config file for zsh (z shell)
# Authors:       grml-team (grml.org), (c) Michael Prokop <mika@grml.org>
# Bug-Reports:   see http://grml.org/bugs/
# License:       This file is licensed under the GPL v2.
################################################################################
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin
################################################################################

# USAGE
# If you are using this file as your ~/.zshrc file, please use ~/.zshrc.pre
# and ~/.zshrc.local for your own customisations. The former file is read
# before ~/.zshrc, the latter is read after it. Also, consider reading the
# refcard and the reference manual for this setup, both available from:
#     <http://grml.org/zsh/>

# Contributing:
# If you want to help to improve grml's zsh setup, clone the grml-etc-core
# repository from git.grml.org:
#   git clone git://git.grml.org/grml-etc-core.git
#
# Make your changes, commit them; use 'git format-patch' to create a series
# of patches and send those to the following address via 'git send-email':
#   grml-etc-core@grml.org
#
# Doing so makes sure the right people get your patches for review and
# possibly inclusion.

# zsh-refcard-tag documentation:
#   You may notice strange looking comments in this file.
#   These are there for a purpose. grml's zsh-refcard can now be
#   automatically generated from the contents of the actual configuration
#   file. However, we need a little extra information on which comments
#   and what lines of code to take into account (and for what purpose).
#
# Here is what they mean:
#
# List of tags (comment types) used:
#   #a#     Next line contains an important alias, that should
#           be included in the grml-zsh-refcard.
#           (placement tag: @@INSERT-aliases@@)
#   #f#     Next line contains the beginning of an important function.
#           (placement tag: @@INSERT-functions@@)
#   #v#     Next line contains an important variable.
#           (placement tag: @@INSERT-variables@@)
#   #k#     Next line contains an important keybinding.
#           (placement tag: @@INSERT-keybindings@@)
#   #d#     Hashed directories list generation:
#               start   denotes the start of a list of 'hash -d'
#                       definitions.
#               end     denotes its end.
#           (placement tag: @@INSERT-hasheddirs@@)
#   #A#     Abbreviation expansion list generation:
#               start   denotes the beginning of abbreviations.
#               end     denotes their end.
#           Lines within this section that end in '#d .*' provide
#           extra documentation to be included in the refcard.
#           (placement tag: @@INSERT-abbrev@@)
#   #m#     This tag allows you to manually generate refcard entries
#           for code lines that are hard/impossible to parse.
#               Example:
#                   #m# k ESC-h Call the run-help function
#               That would add a refcard entry in the keybindings table
#               for 'ESC-h' with the given comment.
#           So the syntax is: #m# <section> <argument> <comment>
#   #o#     This tag lets you insert entries to the 'other' hash.
#           Generally, this should not be used. It is there for
#           things that cannot be done easily in another way.
#           (placement tag: @@INSERT-other-foobar@@)
#
#   All of these tags (except for m and o) take two arguments, the first
#   within the tag, the other after the tag:
#
#   #<tag><section># <comment>
#
#   Where <section> is really just a number, which are defined by the
#   @secmap array on top of 'genrefcard.pl'. The reason for numbers
#   instead of names is, that for the reader, the tag should not differ
#   much from a regular comment. For zsh, it is a regular comment indeed.
#   The numbers have got the following meanings:
#         0 -> "default"
#         1 -> "system"
#         2 -> "user"
#         3 -> "debian"
#         4 -> "search"
#         5 -> "shortcuts"
#         6 -> "services"
#
#   So, the following will add an entry to the 'functions' table in the
#   'system' section, with a (hopefully) descriptive comment:
#       #f1# Edit an alias via zle
#       edalias() {
#
#   It will then show up in the @@INSERT-aliases-system@@ replacement tag
#   that can be found in 'grml-zsh-refcard.tex.in'.
#   If the section number is omitted, the 'default' section is assumed.
#   Furthermore, in 'grml-zsh-refcard.tex.in' @@INSERT-aliases@@ is
#   exactly the same as @@INSERT-aliases-default@@. If you want a list of
#   *all* aliases, for example, use @@INSERT-aliases-all@@.

# zsh profiling
# just execute 'ZSH_PROFILE_RC=1 zsh' and run 'zprof' to get the details
if [[ $ZSH_PROFILE_RC -gt 0 ]] ; then
    zmodload zsh/zprof
fi

# load .zshrc.pre to give the user the chance to overwrite the defaults
[[ -r ${ZDOTDIR:-${HOME}}/.zshrc.pre ]] && source ${ZDOTDIR:-${HOME}}/.zshrc.pre

# check for version/system
# check for versions (compatibility reasons)
function is4 () {
    [[ $ZSH_VERSION == <4->* ]] && return 0
    return 1
}

function is41 () {
    [[ $ZSH_VERSION == 4.<1->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

function is42 () {
    [[ $ZSH_VERSION == 4.<2->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

function is425 () {
    [[ $ZSH_VERSION == 4.2.<5->* || $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

function is43 () {
    [[ $ZSH_VERSION == 4.<3->* || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

function is433 () {
    [[ $ZSH_VERSION == 4.3.<3->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

function is437 () {
    [[ $ZSH_VERSION == 4.3.<7->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

function is439 () {
    [[ $ZSH_VERSION == 4.3.<9->* || $ZSH_VERSION == 4.<4->* \
                                 || $ZSH_VERSION == <5->* ]] && return 0
    return 1
}

#f1# Checks whether or not you're running grml
function isgrml () {
    [[ -f /etc/grml_version ]] && return 0
    return 1
}

#f1# Checks whether or not you're running a grml cd
function isgrmlcd () {
    [[ -f /etc/grml_cd ]] && return 0
    return 1
}

if isgrml ; then
#f1# Checks whether or not you're running grml-small
    function isgrmlsmall () {
        if [[ ${${${(f)"$(</etc/grml_version)"}%% *}##*-} == 'small' ]]; then
            return 0
        fi
        return 1
    }
else
    function isgrmlsmall () { return 1 }
fi

GRML_OSTYPE=$(uname -s)

function islinux () {
    [[ $GRML_OSTYPE == "Linux" ]]
}

function isdarwin () {
    [[ $GRML_OSTYPE == "Darwin" ]]
}

function isfreebsd () {
    [[ $GRML_OSTYPE == "FreeBSD" ]]
}

function isopenbsd () {
    [[ $GRML_OSTYPE == "OpenBSD" ]]
}

function issolaris () {
    [[ $GRML_OSTYPE == "SunOS" ]]
}

#f1# are we running within an utf environment?
function isutfenv () {
    case "$LANG $CHARSET $LANGUAGE" in
        *utf*) return 0 ;;
        *UTF*) return 0 ;;
        *)     return 1 ;;
    esac
}

# check for user, if not running as root set $SUDO to sudo
(( EUID != 0 )) && SUDO='sudo' || SUDO=''

# change directory to home on first invocation of zsh
# important for rungetty -> autologin
# Thanks go to Bart Schaefer!
isgrml && function checkhome () {
    if [[ -z "$ALREADY_DID_CD_HOME" ]] ; then
        export ALREADY_DID_CD_HOME=$HOME
        cd
    fi
}

# check for zsh v3.1.7+

if ! [[ ${ZSH_VERSION} == 3.1.<7->*      \
     || ${ZSH_VERSION} == 3.<2->.<->*    \
     || ${ZSH_VERSION} == <4->.<->*   ]] ; then

    printf '-!-\n'
    printf '-!- In this configuration we try to make use of features, that only\n'
    printf '-!- require version 3.1.7 of the shell; That way this setup can be\n'
    printf '-!- used with a wide range of zsh versions, while using fairly\n'
    printf '-!- advanced features in all supported versions.\n'
    printf '-!-\n'
    printf '-!- However, you are running zsh version %s.\n' "$ZSH_VERSION"
    printf '-!-\n'
    printf '-!- While this *may* work, it might as well fail.\n'
    printf '-!- Please consider updating to at least version 3.1.7 of zsh.\n'
    printf '-!-\n'
    printf '-!- DO NOT EXPECT THIS TO WORK FLAWLESSLY!\n'
    printf '-!- If it does today, you'\''ve been lucky.\n'
    printf '-!-\n'
    printf '-!- Ye been warned!\n'
    printf '-!-\n'

    function zstyle () { : }
fi

# autoload wrapper - use this one instead of autoload directly
# We need to define this function as early as this, because autoloading
# 'is-at-least()' needs it.
function zrcautoload () {
    emulate -L zsh
    setopt extended_glob
    local fdir ffile
    local -i ffound

    ffile=$1
    (( ffound = 0 ))
    for fdir in ${fpath} ; do
        [[ -e ${fdir}/${ffile} ]] && (( ffound = 1 ))
    done

    (( ffound == 0 )) && return 1
    if [[ $ZSH_VERSION == 3.1.<6-> || $ZSH_VERSION == <4->* ]] ; then
        autoload -U ${ffile} || return 1
    else
        autoload ${ffile} || return 1
    fi
    return 0
}

# The following is the ‘add-zsh-hook’ function from zsh upstream. It is
# included here to make the setup work with older versions of zsh (prior to
# 4.3.7) in which this function had a bug that triggers annoying errors during
# shell startup. This is exactly upstreams code from f0068edb4888a4d8fe94def,
# with just a few adjustments in coding style to make the function look more
# compact. This definition can be removed as soon as we raise the minimum
# version requirement to 4.3.7 or newer.
function add-zsh-hook () {
    # Add to HOOK the given FUNCTION.
    # HOOK is one of chpwd, precmd, preexec, periodic, zshaddhistory,
    # zshexit, zsh_directory_name (the _functions subscript is not required).
    #
    # With -d, remove the function from the hook instead; delete the hook
    # variable if it is empty.
    #
    # -D behaves like -d, but pattern characters are active in the function
    # name, so any matching function will be deleted from the hook.
    #
    # Without -d, the FUNCTION is marked for autoload; -U is passed down to
    # autoload if that is given, as are -z and -k. (This is harmless if the
    # function is actually defined inline.)
    emulate -L zsh
    local -a hooktypes
    hooktypes=(
        chpwd precmd preexec periodic zshaddhistory zshexit
        zsh_directory_name
    )
    local usage="Usage: $0 hook function\nValid hooks are:\n  $hooktypes"
    local opt
    local -a autoopts
    integer del list help
    while getopts "dDhLUzk" opt; do
        case $opt in
        (d) del=1 ;;
        (D) del=2 ;;
        (h) help=1 ;;
        (L) list=1 ;;
        ([Uzk]) autoopts+=(-$opt) ;;
        (*) return 1 ;;
        esac
    done
    shift $(( OPTIND - 1 ))
    if (( list )); then
        typeset -mp "(${1:-${(@j:|:)hooktypes}})_functions"
        return $?
    elif (( help || $# != 2 || ${hooktypes[(I)$1]} == 0 )); then
        print -u$(( 2 - help )) $usage
        return $(( 1 - help ))
    fi
    local hook="${1}_functions"
    local fn="$2"
    if (( del )); then
        # delete, if hook is set
        if (( ${(P)+hook} )); then
            if (( del == 2 )); then
                set -A $hook ${(P)hook:#${~fn}}
            else
                set -A $hook ${(P)hook:#$fn}
            fi
            # unset if no remaining entries --- this can give better
            # performance in some cases
            if (( ! ${(P)#hook} )); then
                unset $hook
            fi
        fi
    else
        if (( ${(P)+hook} )); then
            if (( ${${(P)hook}[(I)$fn]} == 0 )); then
                set -A $hook ${(P)hook} $fn
            fi
        else
            set -A $hook $fn
        fi
        autoload $autoopts -- $fn
    fi
}

# Load is-at-least() for more precise version checks Note that this test will
# *always* fail, if the is-at-least function could not be marked for
# autoloading.
zrcautoload is-at-least || function is-at-least () { return 1 }

# set some important options (as early as possible)

# append history list to the history file; this is the default but we make sure
# because it's required for share_history.
setopt append_history

# import new commands from the history file also in other zsh-session
is4 && setopt share_history

# save each command's beginning timestamp and the duration to the history file
setopt extended_history

# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
is4 && setopt histignorealldups

# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace

# if a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

# in order to use #, ~ and ^ for filename generation grep word
# *~(*.gz|*.bz|*.bz2|*.zip|*.Z) -> searches for word not in compressed files
# don't forget to quote '^', '~' and '#'!
setopt extended_glob

# display PID when suspending processes as well
setopt longlistjobs

# report the status of backgrounds jobs immediately
setopt notify

# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all

# not just at the end
setopt completeinword

# Don't send SIGHUP to background processes when the shell exits.
setopt nohup

# make cd push the old directory onto the directory stack.
setopt auto_pushd

# avoid "beep"ing
setopt nobeep

# don't push the same dir twice.
setopt pushd_ignore_dups

# * shouldn't match dotfiles. ever.
setopt noglobdots

# use zsh style word splitting
setopt noshwordsplit

# don't error out when unset parameters are used
setopt unset

# setting some default values
NOCOR=${NOCOR:-0}
NOMENU=${NOMENU:-0}
NOPRECMD=${NOPRECMD:-0}
COMMAND_NOT_FOUND=${COMMAND_NOT_FOUND:-0}
GRML_ZSH_CNF_HANDLER=${GRML_ZSH_CNF_HANDLER:-/usr/share/command-not-found/command-not-found}
GRML_DISPLAY_BATTERY=${GRML_DISPLAY_BATTERY:-${BATTERY:-0}}
GRMLSMALL_SPECIFIC=${GRMLSMALL_SPECIFIC:-1}
ZSH_NO_DEFAULT_LOCALE=${ZSH_NO_DEFAULT_LOCALE:-0}

typeset -ga ls_options
typeset -ga grep_options

# Colors on GNU ls(1)
if ls --color=auto / >/dev/null 2>&1; then
    ls_options+=( --color=auto )
# Colors on FreeBSD and OSX ls(1)
elif ls -G / >/dev/null 2>&1; then
    ls_options+=( -G )
fi

# Natural sorting order on GNU ls(1)
# OSX and IllumOS have a -v option that is not natural sorting
if ls --version |& grep -q 'GNU' >/dev/null 2>&1 && ls -v / >/dev/null 2>&1; then
    ls_options+=( -v )
fi

# Color on GNU and FreeBSD grep(1)
if grep --color=auto -q "a" <<< "a" >/dev/null 2>&1; then
    grep_options+=( --color=auto )
fi

# utility functions
# this function checks if a command exists and returns either true
# or false. This avoids using 'which' and 'whence', which will
# avoid problems with aliases for which on certain weird systems. :-)
# Usage: check_com [-c|-g] word
#   -c  only checks for external commands
#   -g  does the usual tests and also checks for global aliases
function check_com () {
    emulate -L zsh
    local -i comonly gatoo
    comonly=0
    gatoo=0

    if [[ $1 == '-c' ]] ; then
        comonly=1
        shift 1
    elif [[ $1 == '-g' ]] ; then
        gatoo=1
        shift 1
    fi

    if (( ${#argv} != 1 )) ; then
        printf 'usage: check_com [-c|-g] <command>\n' >&2
        return 1
    fi

    if (( comonly > 0 )) ; then
        (( ${+commands[$1]}  )) && return 0
        return 1
    fi

    if     (( ${+commands[$1]}    )) \
        || (( ${+functions[$1]}   )) \
        || (( ${+aliases[$1]}     )) \
        || (( ${+reswords[(r)$1]} )) ; then
        return 0
    fi

    if (( gatoo > 0 )) && (( ${+galiases[$1]} )) ; then
        return 0
    fi

    return 1
}

# creates an alias and precedes the command with
# sudo if $EUID is not zero.
function salias () {
    emulate -L zsh
    local only=0 ; local multi=0
    local key val
    while getopts ":hao" opt; do
        case $opt in
            o) only=1 ;;
            a) multi=1 ;;
            h)
                printf 'usage: salias [-hoa] <alias-expression>\n'
                printf '  -h      shows this help text.\n'
                printf '  -a      replace '\'' ; '\'' sequences with '\'' ; sudo '\''.\n'
                printf '          be careful using this option.\n'
                printf '  -o      only sets an alias if a preceding sudo would be needed.\n'
                return 0
                ;;
            *) salias -h >&2; return 1 ;;
        esac
    done
    shift "$((OPTIND-1))"

    if (( ${#argv} > 1 )) ; then
        printf 'Too many arguments %s\n' "${#argv}"
        return 1
    fi

    key="${1%%\=*}" ;  val="${1#*\=}"
    if (( EUID == 0 )) && (( only == 0 )); then
        alias -- "${key}=${val}"
    elif (( EUID > 0 )) ; then
        (( multi > 0 )) && val="${val// ; / ; sudo }"
        alias -- "${key}=sudo ${val}"
    fi

    return 0
}

# Check if we can read given files and source those we can.
function xsource () {
    if (( ${#argv} < 1 )) ; then
        printf 'usage: xsource FILE(s)...\n' >&2
        return 1
    fi

    while (( ${#argv} > 0 )) ; do
        [[ -r "$1" ]] && source "$1"
        shift
    done
    return 0
}

# Check if we can read a given file and 'cat(1)' it.
function xcat () {
    emulate -L zsh
    if (( ${#argv} != 1 )) ; then
        printf 'usage: xcat FILE\n' >&2
        return 1
    fi

    [[ -r $1 ]] && cat $1
    return 0
}

# Remove these functions again, they are of use only in these
# setup files. This should be called at the end of .zshrc.
function xunfunction () {
    emulate -L zsh
    local -a funcs
    local func
    funcs=(salias xcat xsource xunfunction zrcautoload zrcautozle)
    for func in $funcs ; do
        [[ -n ${functions[$func]} ]] \
            && unfunction $func
    done
    return 0
}

# this allows us to stay in sync with grml's zshrc and put own
# modifications in ~/.zshrc.local
function zrclocal () {
    xsource "/etc/zsh/zshrc.local"
    xsource "${ZDOTDIR:-${HOME}}/.zshrc.local"
    return 0
}

# locale setup
if (( ZSH_NO_DEFAULT_LOCALE == 0 )); then
    xsource "/etc/default/locale"
fi

for var in LANG LC_ALL LC_MESSAGES ; do
    [[ -n ${(P)var} ]] && export $var
done
builtin unset -v var

# set some variables
if check_com -c vim ; then
#v#
    export EDITOR=${EDITOR:-vim}
else
    export EDITOR=${EDITOR:-vi}
fi

#v#
export PAGER=${PAGER:-less}

#v#
export MAIL=${MAIL:-/var/mail/$USER}

# color setup for ls:
check_com -c dircolors && eval $(dircolors -b)
# color setup for ls on OS X / FreeBSD:
isdarwin && export CLICOLOR=1
isfreebsd && export CLICOLOR=1

# do MacPorts setup on darwin
if isdarwin && [[ -d /opt/local ]]; then
    # Note: PATH gets set in /etc/zprofile on Darwin, so this can't go into
    # zshenv.
    PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    MANPATH="/opt/local/share/man:$MANPATH"
fi
# do Fink setup on darwin
isdarwin && xsource /sw/bin/init.sh

# load our function and completion directories
for fdir in /usr/share/grml/zsh/completion /usr/share/grml/zsh/functions; do
    fpath=( ${fdir} ${fdir}/**/*(/N) ${fpath} )
done
typeset -aU ffiles
ffiles=(/usr/share/grml/zsh/functions/**/[^_]*[^~](N.:t))
(( ${#ffiles} > 0 )) && autoload -U "${ffiles[@]}"
unset -v fdir ffiles

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# mailchecks
MAILCHECK=30

# report about cpu-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5

# watch for everyone but me and root
watch=(notme root)

# automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH

# Load a few modules
is4 && \
for mod in parameter complist deltochar mathfunc ; do
    zmodload -i zsh/${mod} 2>/dev/null || print "Notice: no ${mod} available :("
done && builtin unset -v mod

# autoload zsh modules when they are referenced
if is4 ; then
    zmodload -a  zsh/stat    zstat
    zmodload -a  zsh/zpty    zpty
    zmodload -ap zsh/mapfile mapfile
fi

# completion system
COMPDUMPFILE=${COMPDUMPFILE:-${ZDOTDIR:-${HOME}}/.zcompdump}
if zrcautoload compinit ; then
    typeset -a tmp
    zstyle -a ':grml:completion:compinit' arguments tmp
    compinit -d ${COMPDUMPFILE} "${tmp[@]}" || print 'Notice: no compinit available :('
    unset tmp
else
    print 'Notice: no compinit available :('
    function compdef { }
fi

# completion system

# called later (via is4 && grmlcomp)
# note: use 'zstyle' for getting current settings
#         press ^xh (control-x h) for getting tags in context; ^x? (control-x ?) to run complete_debug with trace output
function grmlcomp () {
    # TODO: This could use some additional information

    # Make sure the completion system is initialised
    (( ${+_comps} )) || return 1

    # allow one error for every three characters typed in approximate completer
    zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'

    # don't complete backup files as executables
    zstyle ':completion:*:complete:-command-::commands' ignored-patterns '(aptitude-*|*\~)'

    # start menu completion only if it could find no unambiguous initial string
    zstyle ':completion:*:correct:*'       insert-unambiguous true
    zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
    zstyle ':completion:*:correct:*'       original true

    # activate color-completion
    zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

    # format on completion
    zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'

    # automatically complete 'cd -<tab>' and 'cd -<ctrl-d>' with menu
    # zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

    # insert all expansions for expand completer
    zstyle ':completion:*:expand:*'        tag-order all-expansions
    zstyle ':completion:*:history-words'   list false

    # activate menu
    zstyle ':completion:*:history-words'   menu yes

    # ignore duplicate entries
    zstyle ':completion:*:history-words'   remove-all-dups yes
    zstyle ':completion:*:history-words'   stop yes

    # match uppercase from lowercase
    zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'

    # separate matches into groups
    zstyle ':completion:*:matches'         group 'yes'
    zstyle ':completion:*'                 group-name ''

    if [[ "$NOMENU" -eq 0 ]] ; then
        # if there are more than 5 options allow selecting from a menu
        zstyle ':completion:*'               menu select=5
    else
        # don't use any menus at all
        setopt no_auto_menu
    fi

    zstyle ':completion:*:messages'        format '%d'
    zstyle ':completion:*:options'         auto-description '%d'

    # describe options in full
    zstyle ':completion:*:options'         description 'yes'

    # on processes completion complete all user processes
    zstyle ':completion:*:processes'       command 'ps -au$USER'

    # offer indexes before parameters in subscripts
    zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

    # provide verbose completion information
    zstyle ':completion:*'                 verbose true

    # recent (as of Dec 2007) zsh versions are able to provide descriptions
    # for commands (read: 1st word in the line) that it will list for the user
    # to choose from. The following disables that, because it's not exactly fast.
    zstyle ':completion:*:-command-:*:'    verbose false

    # set format for warnings
    zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d'

    # define files to ignore for zcompile
    zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'
    zstyle ':completion:correct:'          prompt 'correct to: %e'

    # Ignore completion functions for commands you don't have:
    zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'

    # Provide more processes in completion of programs like killall:
    zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'

    # complete manual by their section
    zstyle ':completion:*:manuals'    separate-sections true
    zstyle ':completion:*:manuals.*'  insert-sections   true
    zstyle ':completion:*:man:*'      menu yes select

    # Search path for sudo completion
    zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                               /usr/local/bin  \
                                               /usr/sbin       \
                                               /usr/bin        \
                                               /sbin           \
                                               /bin            \
                                               /usr/X11R6/bin

    # provide .. as a completion
    zstyle ':completion:*' special-dirs ..

    # run rehash on completion so new installed program are found automatically:
    function _force_rehash () {
        (( CURRENT == 1 )) && rehash
        return 1
    }

    ## correction
    # some people don't like the automatic correction - so run 'NOCOR=1 zsh' to deactivate it
    if [[ "$NOCOR" -gt 0 ]] ; then
        zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _files _ignored
        setopt nocorrect
    else
        # try to be smart about when to use what completer...
        setopt correct
        zstyle -e ':completion:*' completer '
            if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]] ; then
                _last_try="$HISTNO$BUFFER$CURSOR"
                reply=(_complete _match _ignored _prefix _files)
            else
                if [[ $words[1] == (rm|mv) ]] ; then
                    reply=(_complete _files)
                else
                    reply=(_oldlist _expand _force_rehash _complete _ignored _correct _approximate _files)
                fi
            fi'
    fi

    # command for process lists, the local web server details and host completion
    zstyle ':completion:*:urls' local 'www' '/var/www/' 'public_html'

    # Some functions, like _apt and _dpkg, are very slow. We can use a cache in
    # order to speed things up
    if [[ ${GRML_COMP_CACHING:-yes} == yes ]]; then
        GRML_COMP_CACHE_DIR=${GRML_COMP_CACHE_DIR:-${ZDOTDIR:-$HOME}/.cache}
        if [[ ! -d ${GRML_COMP_CACHE_DIR} ]]; then
            command mkdir -p "${GRML_COMP_CACHE_DIR}"
        fi
        zstyle ':completion:*' use-cache  yes
        zstyle ':completion:*:complete:*' cache-path "${GRML_COMP_CACHE_DIR}"
    fi

    # host completion
    if is42 ; then
        [[ -r ~/.ssh/config ]] && _ssh_config_hosts=(${${(s: :)${(ps:\t:)${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }}}:#*[*?]*}) || _ssh_config_hosts=()
        [[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
        [[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
    else
        _ssh_config_hosts=()
        _ssh_hosts=()
        _etc_hosts=()
    fi
    hosts=(
        $(hostname)
        "$_ssh_config_hosts[@]"
        "$_ssh_hosts[@]"
        "$_etc_hosts[@]"
        localhost
    )
    zstyle ':completion:*:hosts' hosts $hosts
    # TODO: so, why is this here?
    #  zstyle '*' hosts $hosts

    # use generic completion system for programs not yet defined; (_gnu_generic works
    # with commands that provide a --help option with "standard" gnu-like output.)
    for compcom in cp deborphan df feh fetchipac gpasswd head hnb ipacsum mv \
                   pal stow uname ; do
        [[ -z ${_comps[$compcom]} ]] && compdef _gnu_generic ${compcom}
    done; unset compcom

    # see upgrade function in this file
    compdef _hosts upgrade
}

# Keyboard setup: The following is based on the same code, we wrote for
# debian's setup. It ensures the terminal is in the right mode, when zle is
# active, so the values from $terminfo are valid. Therefore, this setup should
# work on all systems, that have support for `terminfo'. It also requires the
# zsh in use to have the `zsh/terminfo' module built.
#
# If you are customising your `zle-line-init()' or `zle-line-finish()'
# functions, make sure you call the following utility functions in there:
#
#     - zle-line-init():      zle-smkx
#     - zle-line-finish():    zle-rmkx

# Use emacs-like key bindings by default:
bindkey -e

# Custom widgets:

## beginning-of-line OR beginning-of-buffer OR beginning of history
## by: Bart Schaefer <schaefer@brasslantern.com>, Bernhard Tittelbach
function beginning-or-end-of-somewhere () {
    local hno=$HISTNO
    if [[ ( "${LBUFFER[-1]}" == $'\n' && "${WIDGET}" == beginning-of* ) || \
      ( "${RBUFFER[1]}" == $'\n' && "${WIDGET}" == end-of* ) ]]; then
        zle .${WIDGET:s/somewhere/buffer-or-history/} "$@"
    else
        zle .${WIDGET:s/somewhere/line-hist/} "$@"
        if (( HISTNO != hno )); then
            zle .${WIDGET:s/somewhere/buffer-or-history/} "$@"
        fi
    fi
}
zle -N beginning-of-somewhere beginning-or-end-of-somewhere
zle -N end-of-somewhere beginning-or-end-of-somewhere

# add a command line to the shells history without executing it
function commit-to-history () {
    print -s ${(z)BUFFER}
    zle send-break
}
zle -N commit-to-history

# only slash should be considered as a word separator:
function slash-backward-kill-word () {
    local WORDCHARS="${WORDCHARS:s@/@}"
    # zle backward-word
    zle backward-kill-word
}
zle -N slash-backward-kill-word

# a generic accept-line wrapper

# This widget can prevent unwanted autocorrections from command-name
# to _command-name, rehash automatically on enter and call any number
# of builtin and user-defined widgets in different contexts.
#
# For a broader description, see:
# <http://bewatermyfriend.org/posts/2007/12-26.11-50-38-tooltime.html>
#
# The code is imported from the file 'zsh/functions/accept-line' from
# <http://ft.bewatermyfriend.org/comp/zsh/zsh-dotfiles.tar.bz2>, which
# distributed under the same terms as zsh itself.

# A newly added command will may not be found or will cause false
# correction attempts, if you got auto-correction set. By setting the
# following style, we force accept-line() to rehash, if it cannot
# find the first word on the command line in the $command[] hash.
zstyle ':acceptline:*' rehash true

function Accept-Line () {
    setopt localoptions noksharrays
    local -a subs
    local -xi aldone
    local sub
    local alcontext=${1:-$alcontext}

    zstyle -a ":acceptline:${alcontext}" actions subs

    (( ${#subs} < 1 )) && return 0

    (( aldone = 0 ))
    for sub in ${subs} ; do
        [[ ${sub} == 'accept-line' ]] && sub='.accept-line'
        zle ${sub}

        (( aldone > 0 )) && break
    done
}

function Accept-Line-getdefault () {
    emulate -L zsh
    local default_action

    zstyle -s ":acceptline:${alcontext}" default_action default_action
    case ${default_action} in
        ((accept-line|))
            printf ".accept-line"
            ;;
        (*)
            printf ${default_action}
            ;;
    esac
}

function Accept-Line-HandleContext () {
    zle Accept-Line

    default_action=$(Accept-Line-getdefault)
    zstyle -T ":acceptline:${alcontext}" call_default \
        && zle ${default_action}
}

function accept-line () {
    setopt localoptions noksharrays
    local -a cmdline
    local -x alcontext
    local buf com fname format msg default_action

    alcontext='default'
    buf="${BUFFER}"
    cmdline=(${(z)BUFFER})
    com="${cmdline[1]}"
    fname="_${com}"

    Accept-Line 'preprocess'

    zstyle -t ":acceptline:${alcontext}" rehash \
        && [[ -z ${commands[$com]} ]]           \
        && rehash

    if    [[ -n ${com}               ]] \
       && [[ -n ${reswords[(r)$com]} ]] \
       || [[ -n ${aliases[$com]}     ]] \
       || [[ -n ${functions[$com]}   ]] \
       || [[ -n ${builtins[$com]}    ]] \
       || [[ -n ${commands[$com]}    ]] ; then

        # there is something sensible to execute, just do it.
        alcontext='normal'
        Accept-Line-HandleContext

        return
    fi

    if    [[ -o correct              ]] \
       || [[ -o correctall           ]] \
       && [[ -n ${functions[$fname]} ]] ; then

        # nothing there to execute but there is a function called
        # _command_name; a completion widget. Makes no sense to
        # call it on the commandline, but the correct{,all} options
        # will ask for it nevertheless, so warn the user.
        if [[ ${LASTWIDGET} == 'accept-line' ]] ; then
            # Okay, we warned the user before, he called us again,
            # so have it his way.
            alcontext='force'
            Accept-Line-HandleContext

            return
        fi

        if zstyle -t ":acceptline:${alcontext}" nocompwarn ; then
            alcontext='normal'
            Accept-Line-HandleContext
        else
            # prepare warning message for the user, configurable via zstyle.
            zstyle -s ":acceptline:${alcontext}" compwarnfmt msg

            if [[ -z ${msg} ]] ; then
                msg="%c will not execute and completion %f exists."
            fi

            zformat -f msg "${msg}" "c:${com}" "f:${fname}"

            zle -M -- "${msg}"
        fi
        return
    elif [[ -n ${buf//[$' \t\n']##/} ]] ; then
        # If we are here, the commandline contains something that is not
        # executable, which is neither subject to _command_name correction
        # and is not empty. might be a variable assignment
        alcontext='misc'
        Accept-Line-HandleContext

        return
    fi

    # If we got this far, the commandline only contains whitespace, or is empty.
    alcontext='empty'
    Accept-Line-HandleContext
}

zle -N accept-line
zle -N Accept-Line
zle -N Accept-Line-HandleContext

# power completion / abbreviation expansion / buffer expansion
# see http://zshwiki.org/home/examples/zleiab for details
# less risky than the global aliases but powerful as well
# just type the abbreviation key and afterwards 'ctrl-x .' to expand it
declare -A abk
setopt extendedglob
setopt interactivecomments
abk=(
#   key   # value                  (#d additional doc string)
#A# start
    '...'  '../..'
    '....' '../../..'
    'BG'   '& exit'
    'C'    '| wc -l'
    'G'    '|& grep '${grep_options:+"${grep_options[*]}"}
    'H'    '| head'
    'Hl'   ' --help |& less -r'    #d (Display help in pager)
    'L'    '| less'
    'LL'   '|& less -r'
    'M'    '| most'
    'N'    '&>/dev/null'           #d (No Output)
    'R'    '| tr A-z N-za-m'       #d (ROT13)
    'SL'   '| sort | less'
    'S'    '| sort -u'
    'T'    '| tail'
    'V'    '|& vim -'
#A# end
    'co'   './configure && make && sudo make install'
)

function zleiab () {
    emulate -L zsh
    setopt extendedglob
    local MATCH

    LBUFFER=${LBUFFER%%(#m)[.\-+:|_a-zA-Z0-9]#}
    LBUFFER+=${abk[$MATCH]:-$MATCH}
}

zle -N zleiab

function help-show-abk () {
  zle -M "$(print "Available abbreviations for expansion:"; print -a -C 2 ${(kv)abk})"
}

zle -N help-show-abk

# press "ctrl-x d" to insert the actual date in the form yyyy-mm-dd
function insert-datestamp () { LBUFFER+=${(%):-'%D{%Y-%m-%d}'}; }
zle -N insert-datestamp

# press esc-m for inserting last typed word again (thanks to caphuso!)
function insert-last-typed-word () { zle insert-last-word -- 0 -1 };
zle -N insert-last-typed-word;

function grml-zsh-fg () {
  if (( ${#jobstates} )); then
    zle .push-input
    [[ -o hist_ignore_space ]] && BUFFER=' ' || BUFFER=''
    BUFFER="${BUFFER}fg"
    zle .accept-line
  else
    zle -M 'No background jobs. Doing nothing.'
  fi
}
zle -N grml-zsh-fg

# run command line as user root via sudo:
function sudo-command-line () {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR+5 ))
    fi
}
zle -N sudo-command-line

### jump behind the first word on the cmdline.
### useful to add options.
function jump_after_first_word () {
    local words
    words=(${(z)BUFFER})

    if (( ${#words} <= 1 )) ; then
        CURSOR=${#BUFFER}
    else
        CURSOR=${#${words[1]}}
    fi
}
zle -N jump_after_first_word

#f5# Create directory under cursor or the selected area
function inplaceMkDirs () {
    # Press ctrl-xM to create the directory under the cursor or the selected area.
    # To select an area press ctrl-@ or ctrl-space and use the cursor.
    # Use case: you type "mv abc ~/testa/testb/testc/" and remember that the
    # directory does not exist yet -> press ctrl-XM and problem solved
    local PATHTOMKDIR
    if ((REGION_ACTIVE==1)); then
        local F=$MARK T=$CURSOR
        if [[ $F -gt $T ]]; then
            F=${CURSOR}
            T=${MARK}
        fi
        # get marked area from buffer and eliminate whitespace
        PATHTOMKDIR=${BUFFER[F+1,T]%%[[:space:]]##}
        PATHTOMKDIR=${PATHTOMKDIR##[[:space:]]##}
    else
        local bufwords iword
        bufwords=(${(z)LBUFFER})
        iword=${#bufwords}
        bufwords=(${(z)BUFFER})
        PATHTOMKDIR="${(Q)bufwords[iword]}"
    fi
    [[ -z "${PATHTOMKDIR}" ]] && return 1
    PATHTOMKDIR=${~PATHTOMKDIR}
    if [[ -e "${PATHTOMKDIR}" ]]; then
        zle -M " path already exists, doing nothing"
    else
        zle -M "$(mkdir -p -v "${PATHTOMKDIR}")"
        zle end-of-line
    fi
}

zle -N inplaceMkDirs

#v1# set number of lines to display per page
HELP_LINES_PER_PAGE=20
#v1# set location of help-zle cache file
HELP_ZLE_CACHE_FILE=~/.cache/zsh_help_zle_lines.zsh
# helper function for help-zle, actually generates the help text
function help_zle_parse_keybindings () {
    emulate -L zsh
    setopt extendedglob
    unsetopt ksharrays  #indexing starts at 1

    #v1# choose files that help-zle will parse for keybindings
    ((${+HELPZLE_KEYBINDING_FILES})) || HELPZLE_KEYBINDING_FILES=( /etc/zsh/zshrc ~/.zshrc.pre ~/.zshrc ~/.zshrc.local )

    if [[ -r $HELP_ZLE_CACHE_FILE ]]; then
        local load_cache=0
        local f
        for f ($HELPZLE_KEYBINDING_FILES) [[ $f -nt $HELP_ZLE_CACHE_FILE ]] && load_cache=1
        [[ $load_cache -eq 0 ]] && . $HELP_ZLE_CACHE_FILE && return
    fi

    #fill with default keybindings, possibly to be overwritten in a file later
    #Note that due to zsh inconsistency on escaping assoc array keys, we encase the key in '' which we will remove later
    local -A help_zle_keybindings
    help_zle_keybindings['<Ctrl>@']="set MARK"
    help_zle_keybindings['<Ctrl>x<Ctrl>j']="vi-join lines"
    help_zle_keybindings['<Ctrl>x<Ctrl>b']="jump to matching brace"
    help_zle_keybindings['<Ctrl>x<Ctrl>u']="undo"
    help_zle_keybindings['<Ctrl>_']="undo"
    help_zle_keybindings['<Ctrl>x<Ctrl>f<c>']="find <c> in cmdline"
    help_zle_keybindings['<Ctrl>a']="goto beginning of line"
    help_zle_keybindings['<Ctrl>e']="goto end of line"
    help_zle_keybindings['<Ctrl>t']="transpose charaters"
    help_zle_keybindings['<Alt>t']="transpose words"
    help_zle_keybindings['<Alt>s']="spellcheck word"
    help_zle_keybindings['<Ctrl>k']="backward kill buffer"
    help_zle_keybindings['<Ctrl>u']="forward kill buffer"
    help_zle_keybindings['<Ctrl>y']="insert previously killed word/string"
    help_zle_keybindings["<Alt>'"]="quote line"
    help_zle_keybindings['<Alt>"']="quote from mark to cursor"
    help_zle_keybindings['<Alt><arg>']="repeat next cmd/char <arg> times (<Alt>-<Alt>1<Alt>0a -> -10 times 'a')"
    help_zle_keybindings['<Alt>u']="make next word Uppercase"
    help_zle_keybindings['<Alt>l']="make next word lowercase"
    help_zle_keybindings['<Ctrl>xG']="preview expansion under cursor"
    help_zle_keybindings['<Alt>q']="push current CL into background, freeing it. Restore on next CL"
    help_zle_keybindings['<Alt>.']="insert (and interate through) last word from prev CLs"
    help_zle_keybindings['<Alt>,']="complete word from newer history (consecutive hits)"
    help_zle_keybindings['<Alt>m']="repeat last typed word on current CL"
    help_zle_keybindings['<Ctrl>v']="insert next keypress symbol literally (e.g. for bindkey)"
    help_zle_keybindings['!!:n*<Tab>']="insert last n arguments of last command"
    help_zle_keybindings['!!:n-<Tab>']="insert arguments n..N-2 of last command (e.g. mv s s d)"
    help_zle_keybindings['<Alt>h']="show help/manpage for current command"

    #init global variables
    unset help_zle_lines help_zle_sln
    typeset -g -a help_zle_lines
    typeset -g help_zle_sln=1

    local k v f cline
    local lastkeybind_desc contents     #last description starting with #k# that we found
    local num_lines_elapsed=0            #number of lines between last description and keybinding
    #search config files in the order they a called (and thus the order in which they overwrite keybindings)
    for f in $HELPZLE_KEYBINDING_FILES; do
        [[ -r "$f" ]] || continue   #not readable ? skip it
        contents="$(<$f)"
        for cline in "${(f)contents}"; do
            #zsh pattern: matches lines like: #k# ..............
            if [[ "$cline" == (#s)[[:space:]]#\#k\#[[:space:]]##(#b)(*)[[:space:]]#(#e) ]]; then
                lastkeybind_desc="$match[*]"
                num_lines_elapsed=0
            #zsh pattern: matches lines that set a keybinding using bind2map, bindkey or compdef -k
            #             ignores lines that are commentend out
            #             grabs first in '' or "" enclosed string with length between 1 and 6 characters
            elif [[ "$cline" == [^#]#(bind2maps[[:space:]](*)-s|bindkey|compdef -k)[[:space:]](*)(#b)(\"((?)(#c1,6))\"|\'((?)(#c1,6))\')(#B)(*)  ]]; then
                #description previously found ? description not more than 2 lines away ? keybinding not empty ?
                if [[ -n $lastkeybind_desc && $num_lines_elapsed -lt 2 && -n $match[1] ]]; then
                    #substitute keybinding string with something readable
                    k=${${${${${${${match[1]/\\e\^h/<Alt><BS>}/\\e\^\?/<Alt><BS>}/\\e\[5~/<PageUp>}/\\e\[6~/<PageDown>}//(\\e|\^\[)/<Alt>}//\^/<Ctrl>}/3~/<Alt><Del>}
                    #put keybinding in assoc array, possibly overwriting defaults or stuff found in earlier files
                    #Note that we are extracting the keybinding-string including the quotes (see Note at beginning)
                    help_zle_keybindings[${k}]=$lastkeybind_desc
                fi
                lastkeybind_desc=""
            else
              ((num_lines_elapsed++))
            fi
        done
    done
    unset contents
    #calculate length of keybinding column
    local kstrlen=0
    for k (${(k)help_zle_keybindings[@]}) ((kstrlen < ${#k})) && kstrlen=${#k}
    #convert the assoc array into preformated lines, which we are able to sort
    for k v in ${(kv)help_zle_keybindings[@]}; do
        #pad keybinding-string to kstrlen chars and remove outermost characters (i.e. the quotes)
        help_zle_lines+=("${(r:kstrlen:)k[2,-2]}${v}")
    done
    #sort lines alphabetically
    help_zle_lines=("${(i)help_zle_lines[@]}")
    [[ -d ${HELP_ZLE_CACHE_FILE:h} ]] || mkdir -p "${HELP_ZLE_CACHE_FILE:h}"
    echo "help_zle_lines=(${(q)help_zle_lines[@]})" >| $HELP_ZLE_CACHE_FILE
    zcompile $HELP_ZLE_CACHE_FILE
}
typeset -g help_zle_sln
typeset -g -a help_zle_lines

# Provides (partially autogenerated) help on keybindings and the zsh line editor
function help-zle () {
    emulate -L zsh
    unsetopt ksharrays  #indexing starts at 1
    #help lines already generated ? no ? then do it
    [[ ${+functions[help_zle_parse_keybindings]} -eq 1 ]] && {help_zle_parse_keybindings && unfunction help_zle_parse_keybindings}
    #already displayed all lines ? go back to the start
    [[ $help_zle_sln -gt ${#help_zle_lines} ]] && help_zle_sln=1
    local sln=$help_zle_sln
    #note that help_zle_sln is a global var, meaning we remember the last page we viewed
    help_zle_sln=$((help_zle_sln + HELP_LINES_PER_PAGE))
    zle -M "${(F)help_zle_lines[sln,help_zle_sln-1]}"
}
zle -N help-zle

## complete word from currently visible Screen or Tmux buffer.
if check_com -c screen || check_com -c tmux; then
    function _complete_screen_display () {
        [[ "$TERM" != "screen" ]] && return 1

        local TMPFILE=$(mktemp)
        local -U -a _screen_display_wordlist
        trap "rm -f $TMPFILE" EXIT

        # fill array with contents from screen hardcopy
        if ((${+TMUX})); then
            #works, but crashes tmux below version 1.4
            #luckily tmux -V option to ask for version, was also added in 1.4
            tmux -V &>/dev/null || return
            tmux -q capture-pane \; save-buffer -b 0 $TMPFILE \; delete-buffer -b 0
        else
            screen -X hardcopy $TMPFILE
            # screen sucks, it dumps in latin1, apparently always. so recode it
            # to system charset
            check_com recode && recode latin1 $TMPFILE
        fi
        _screen_display_wordlist=( ${(QQ)$(<$TMPFILE)} )
        # remove PREFIX to be completed from that array
        _screen_display_wordlist[${_screen_display_wordlist[(i)$PREFIX]}]=""
        compadd -a _screen_display_wordlist
    }
    #m# k CTRL-x\,\,\,S Complete word from GNU screen buffer
    bindkey -r "^xS"
    compdef -k _complete_screen_display complete-word '^xS'
fi

# Load a few more functions and tie them to widgets, so they can be bound:

function zrcautozle () {
    emulate -L zsh
    local fnc=$1
    zrcautoload $fnc && zle -N $fnc
}

function zrcgotwidget () {
    (( ${+widgets[$1]} ))
}

function zrcgotkeymap () {
    [[ -n ${(M)keymaps:#$1} ]]
}

zrcautozle insert-files
zrcautozle edit-command-line
zrcautozle insert-unicode-char
if zrcautoload history-search-end; then
    zle -N history-beginning-search-backward-end history-search-end
    zle -N history-beginning-search-forward-end  history-search-end
fi
zle -C hist-complete complete-word _generic
zstyle ':completion:hist-complete:*' completer _history

# The actual terminal setup hooks and bindkey-calls:

# An array to note missing features to ease diagnosis in case of problems.
typeset -ga grml_missing_features

function zrcbindkey () {
    if (( ARGC )) && zrcgotwidget ${argv[-1]}; then
        bindkey "$@"
    fi
}

function bind2maps () {
    local i sequence widget
    local -a maps

    while [[ "$1" != "--" ]]; do
        maps+=( "$1" )
        shift
    done
    shift

    if [[ "$1" == "-s" ]]; then
        shift
        sequence="$1"
    else
        sequence="${key[$1]}"
    fi
    widget="$2"

    [[ -z "$sequence" ]] && return 1

    for i in "${maps[@]}"; do
        zrcbindkey -M "$i" "$sequence" "$widget"
    done
}

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-smkx () {
        emulate -L zsh
        printf '%s' ${terminfo[smkx]}
    }
    function zle-rmkx () {
        emulate -L zsh
        printf '%s' ${terminfo[rmkx]}
    }
    function zle-line-init () {
        zle-smkx
    }
    function zle-line-finish () {
        zle-rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
else
    for i in {s,r}mkx; do
        (( ${+terminfo[$i]} )) || grml_missing_features+=($i)
    done
    unset i
fi

typeset -A key
key=(
    Home     "${terminfo[khome]}"
    End      "${terminfo[kend]}"
    Insert   "${terminfo[kich1]}"
    Delete   "${terminfo[kdch1]}"
    Up       "${terminfo[kcuu1]}"
    Down     "${terminfo[kcud1]}"
    Left     "${terminfo[kcub1]}"
    Right    "${terminfo[kcuf1]}"
    PageUp   "${terminfo[kpp]}"
    PageDown "${terminfo[knp]}"
    BackTab  "${terminfo[kcbt]}"
)

# Guidelines for adding key bindings:
#
#   - Do not add hardcoded escape sequences, to enable non standard key
#     combinations such as Ctrl-Meta-Left-Cursor. They are not easily portable.
#
#   - Adding Ctrl characters, such as '^b' is okay; note that '^b' and '^B' are
#     the same key.
#
#   - All keys from the $key[] mapping are obviously okay.
#
#   - Most terminals send "ESC x" when Meta-x is pressed. Thus, sequences like
#     '\ex' are allowed in here as well.

bind2maps emacs             -- Home   beginning-of-somewhere
bind2maps       viins vicmd -- Home   vi-beginning-of-line
bind2maps emacs             -- End    end-of-somewhere
bind2maps       viins vicmd -- End    vi-end-of-line
bind2maps emacs viins       -- Insert overwrite-mode
bind2maps             vicmd -- Insert vi-insert
bind2maps emacs             -- Delete delete-char
bind2maps       viins vicmd -- Delete vi-delete-char
bind2maps emacs viins vicmd -- Up     up-line-or-search
bind2maps emacs viins vicmd -- Down   down-line-or-search
bind2maps emacs             -- Left   backward-char
bind2maps       viins vicmd -- Left   vi-backward-char
bind2maps emacs             -- Right  forward-char
bind2maps       viins vicmd -- Right  vi-forward-char
#k# Perform abbreviation expansion
bind2maps emacs viins       -- -s '^x.' zleiab
#k# Display list of abbreviations that would expand
bind2maps emacs viins       -- -s '^xb' help-show-abk
#k# mkdir -p <dir> from string under cursor or marked area
bind2maps emacs viins       -- -s '^xM' inplaceMkDirs
#k# display help for keybindings and ZLE
bind2maps emacs viins       -- -s '^xz' help-zle
#k# Insert files and test globbing
bind2maps emacs viins       -- -s "^xf" insert-files
#k# Edit the current line in \kbd{\$EDITOR}
bind2maps emacs viins       -- -s '\ee' edit-command-line
#k# search history backward for entry beginning with typed text
bind2maps emacs viins       -- -s '^xp' history-beginning-search-backward-end
#k# search history forward for entry beginning with typed text
bind2maps emacs viins       -- -s '^xP' history-beginning-search-forward-end
#k# search history backward for entry beginning with typed text
bind2maps emacs viins       -- PageUp history-beginning-search-backward-end
#k# search history forward for entry beginning with typed text
bind2maps emacs viins       -- PageDown history-beginning-search-forward-end
bind2maps emacs viins       -- -s "^x^h" commit-to-history
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s '\ev' slash-backward-kill-word
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s '\e^h' slash-backward-kill-word
#k# Kill left-side word or everything up to next slash
bind2maps emacs viins       -- -s '\e^?' slash-backward-kill-word
# Do history expansion on space:
bind2maps emacs viins       -- -s ' ' magic-space
#k# Trigger menu-complete
bind2maps emacs viins       -- -s '\ei' menu-complete  # menu completion via esc-i
#k# Insert a timestamp on the command line (yyyy-mm-dd)
bind2maps emacs viins       -- -s '^xd' insert-datestamp
#k# Insert last typed word
bind2maps emacs viins       -- -s "\em" insert-last-typed-word
#k# A smart shortcut for \kbd{fg<enter>}
bind2maps emacs viins       -- -s '^z' grml-zsh-fg
#k# prepend the current command with "sudo"
bind2maps emacs viins       -- -s "^os" sudo-command-line
#k# jump to after first word (for adding options)
bind2maps emacs viins       -- -s '^x1' jump_after_first_word
#k# complete word from history with menu
bind2maps emacs viins       -- -s "^x^x" hist-complete

# insert unicode character
# usage example: 'ctrl-x i' 00A7 'ctrl-x i' will give you an §
# See for example http://unicode.org/charts/ for unicode characters code
#k# Insert Unicode character
bind2maps emacs viins       -- -s '^xi' insert-unicode-char

# use the new *-pattern-* widgets for incremental history search
if zrcgotwidget history-incremental-pattern-search-backward; then
    for seq wid in '^r' history-incremental-pattern-search-backward \
                   '^s' history-incremental-pattern-search-forward
    do
        bind2maps emacs viins vicmd -- -s $seq $wid
    done
    builtin unset -v seq wid
fi

if zrcgotkeymap menuselect; then
    #m# k Shift-tab Perform backwards menu completion
    bind2maps menuselect -- BackTab reverse-menu-complete

    #k# menu selection: pick item but stay in the menu
    bind2maps menuselect -- -s '\e^M' accept-and-menu-complete
    # also use + and INSERT since it's easier to press repeatedly
    bind2maps menuselect -- -s '+' accept-and-menu-complete
    bind2maps menuselect -- Insert accept-and-menu-complete

    # accept a completion and try to complete again by using menu
    # completion; very useful with completing directories
    # by using 'undo' one's got a simple file browser
    bind2maps menuselect -- -s '^o' accept-and-infer-next-history
fi

# Finally, here are still a few hardcoded escape sequences; Special sequences
# like Ctrl-<Cursor-key> etc do suck a fair bit, because they are not
# standardised and most of the time are not available in a terminals terminfo
# entry.
#
# While we do not encourage adding bindings like these, we will keep these for
# backward compatibility.

## use Ctrl-left-arrow and Ctrl-right-arrow for jumping to word-beginnings on
## the command line.
# URxvt sequences:
bind2maps emacs viins vicmd -- -s '\eOc' forward-word
bind2maps emacs viins vicmd -- -s '\eOd' backward-word
# These are for xterm:
bind2maps emacs viins vicmd -- -s '\e[1;5C' forward-word
bind2maps emacs viins vicmd -- -s '\e[1;5D' backward-word
## the same for alt-left-arrow and alt-right-arrow
# URxvt again:
bind2maps emacs viins vicmd -- -s '\e\e[C' forward-word
bind2maps emacs viins vicmd -- -s '\e\e[D' backward-word
# Xterm again:
bind2maps emacs viins vicmd -- -s '^[[1;3C' forward-word
bind2maps emacs viins vicmd -- -s '^[[1;3D' backward-word
# Also try ESC Left/Right:
bind2maps emacs viins vicmd -- -s '\e'${key[Right]} forward-word
bind2maps emacs viins vicmd -- -s '\e'${key[Left]}  backward-word

# autoloading

zrcautoload zmv
zrcautoload zed

# we don't want to quote/espace URLs on our own...
# if autoload -U url-quote-magic ; then
#    zle -N self-insert url-quote-magic
#    zstyle ':url-quote-magic:*' url-metas '*?[]^()~#{}='
# else
#    print 'Notice: no url-quote-magic available :('
# fi
alias url-quote='autoload -U url-quote-magic ; zle -N self-insert url-quote-magic'

#m# k ESC-h Call \kbd{run-help} for the 1st word on the command line
alias run-help >&/dev/null && unalias run-help
for rh in run-help{,-git,-ip,-openssl,-p4,-sudo,-svk,-svn}; do
    zrcautoload $rh
done; unset rh

# command not found handling

(( ${COMMAND_NOT_FOUND} == 1 )) &&
function command_not_found_handler () {
    emulate -L zsh
    if [[ -x ${GRML_ZSH_CNF_HANDLER} ]] ; then
        ${GRML_ZSH_CNF_HANDLER} $1
    fi
    return 1
}

# history

#v#
HISTFILE=${HISTFILE:-${ZDOTDIR:-${HOME}}/.zsh_history}
isgrmlcd && HISTSIZE=500  || HISTSIZE=5000
isgrmlcd && SAVEHIST=1000 || SAVEHIST=10000 # useful for setopt append_history

# dirstack handling

DIRSTACKSIZE=${DIRSTACKSIZE:-20}
DIRSTACKFILE=${DIRSTACKFILE:-${ZDOTDIR:-${HOME}}/.zdirs}

if zstyle -T ':grml:chpwd:dirstack' enable; then
    typeset -gaU GRML_PERSISTENT_DIRSTACK
    function grml_dirstack_filter () {
        local -a exclude
        local filter entry
        if zstyle -s ':grml:chpwd:dirstack' filter filter; then
            $filter $1 && return 0
        fi
        if zstyle -a ':grml:chpwd:dirstack' exclude exclude; then
            for entry in "${exclude[@]}"; do
                [[ $1 == ${~entry} ]] && return 0
            done
        fi
        return 1
    }

    function chpwd () {
        (( ZSH_SUBSHELL )) && return
        (( $DIRSTACKSIZE <= 0 )) && return
        [[ -z $DIRSTACKFILE ]] && return
        grml_dirstack_filter $PWD && return
        GRML_PERSISTENT_DIRSTACK=(
            $PWD "${(@)GRML_PERSISTENT_DIRSTACK[1,$DIRSTACKSIZE]}"
        )
        builtin print -l ${GRML_PERSISTENT_DIRSTACK} >! ${DIRSTACKFILE}
    }

    if [[ -f ${DIRSTACKFILE} ]]; then
        # Enabling NULL_GLOB via (N) weeds out any non-existing
        # directories from the saved dir-stack file.
        dirstack=( ${(f)"$(< $DIRSTACKFILE)"}(N) )
        # "cd -" won't work after login by just setting $OLDPWD, so
        [[ -d $dirstack[1] ]] && cd -q $dirstack[1] && cd -q $OLDPWD
    fi

    if zstyle -t ':grml:chpwd:dirstack' filter-on-load; then
        for i in "${dirstack[@]}"; do
            if ! grml_dirstack_filter "$i"; then
                GRML_PERSISTENT_DIRSTACK=(
                    "${GRML_PERSISTENT_DIRSTACK[@]}"
                    $i
                )
            fi
        done
    else
        GRML_PERSISTENT_DIRSTACK=( "${dirstack[@]}" )
    fi
fi

# directory based profiles

if is433 ; then

# chpwd_profiles(): Directory Profiles, Quickstart:
#
# In .zshrc.local:
#
#   zstyle ':chpwd:profiles:/usr/src/grml(|/|/*)'   profile grml
#   zstyle ':chpwd:profiles:/usr/src/debian(|/|/*)' profile debian
#   chpwd_profiles
#
# For details see the `grmlzshrc.5' manual page.
function chpwd_profiles () {
    local profile context
    local -i reexecute

    context=":chpwd:profiles:$PWD"
    zstyle -s "$context" profile profile || profile='default'
    zstyle -T "$context" re-execute && reexecute=1 || reexecute=0

    if (( ${+parameters[CHPWD_PROFILE]} == 0 )); then
        typeset -g CHPWD_PROFILE
        local CHPWD_PROFILES_INIT=1
        (( ${+functions[chpwd_profiles_init]} )) && chpwd_profiles_init
    elif [[ $profile != $CHPWD_PROFILE ]]; then
        (( ${+functions[chpwd_leave_profile_$CHPWD_PROFILE]} )) \
            && chpwd_leave_profile_${CHPWD_PROFILE}
    fi
    if (( reexecute )) || [[ $profile != $CHPWD_PROFILE ]]; then
        (( ${+functions[chpwd_profile_$profile]} )) && chpwd_profile_${profile}
    fi

    CHPWD_PROFILE="${profile}"
    return 0
}

chpwd_functions=( ${chpwd_functions} chpwd_profiles )

fi # is433

# Prompt setup for grml:

# set colors for use in prompts (modern zshs allow for the use of %F{red}foo%f
# in prompts to get a red "foo" embedded, but it's good to keep these for
# backwards compatibility).
if is437; then
    BLUE="%F{blue}"
    RED="%F{red}"
    GREEN="%F{green}"
    CYAN="%F{cyan}"
    MAGENTA="%F{magenta}"
    YELLOW="%F{yellow}"
    WHITE="%F{white}"
    NO_COLOR="%f"
elif zrcautoload colors && colors 2>/dev/null ; then
    BLUE="%{${fg[blue]}%}"
    RED="%{${fg_bold[red]}%}"
    GREEN="%{${fg[green]}%}"
    CYAN="%{${fg[cyan]}%}"
    MAGENTA="%{${fg[magenta]}%}"
    YELLOW="%{${fg[yellow]}%}"
    WHITE="%{${fg[white]}%}"
    NO_COLOR="%{${reset_color}%}"
else
    BLUE=$'%{\e[1;34m%}'
    RED=$'%{\e[1;31m%}'
    GREEN=$'%{\e[1;32m%}'
    CYAN=$'%{\e[1;36m%}'
    WHITE=$'%{\e[1;37m%}'
    MAGENTA=$'%{\e[1;35m%}'
    YELLOW=$'%{\e[1;33m%}'
    NO_COLOR=$'%{\e[0m%}'
fi

# First, the easy ones: PS2..4:

# secondary prompt, printed when the shell needs more information to complete a
# command.
PS2='\`%_> '
# selection prompt used within a select loop.
PS3='?# '
# the execution trace prompt (setopt xtrace). default: '+%N:%i>'
PS4='+%N:%i:%_> '

# Some additional features to use with our prompt:
#
#    - battery status
#    - debian_chroot
#    - vcs_info setup and version specific fixes

# display battery status on right side of prompt using 'GRML_DISPLAY_BATTERY=1' in .zshrc.pre

function battery () {
if [[ $GRML_DISPLAY_BATTERY -gt 0 ]] ; then
    if islinux ; then
        batterylinux
    elif isopenbsd ; then
        batteryopenbsd
    elif isfreebsd ; then
        batteryfreebsd
    elif isdarwin ; then
        batterydarwin
    else
        #not yet supported
        GRML_DISPLAY_BATTERY=0
    fi
fi
}

function batterylinux () {
GRML_BATTERY_LEVEL=''
local batteries bat capacity
batteries=( /sys/class/power_supply/BAT*(N) )
if (( $#batteries > 0 )) ; then
    for bat in $batteries ; do
        if [[ -e $bat/capacity ]]; then
            capacity=$(< $bat/capacity)
        else
            typeset -F energy_full=$(< $bat/energy_full)
            typeset -F energy_now=$(< $bat/energy_now)
            typeset -i capacity=$(( 100 * $energy_now / $energy_full))
        fi
        case $(< $bat/status) in
        Charging)
            GRML_BATTERY_LEVEL+=" ^"
            ;;
        Discharging)
            if (( capacity < 20 )) ; then
                GRML_BATTERY_LEVEL+=" !v"
            else
                GRML_BATTERY_LEVEL+=" v"
            fi
            ;;
        *) # Full, Unknown
            GRML_BATTERY_LEVEL+=" ="
            ;;
        esac
        GRML_BATTERY_LEVEL+="${capacity}%%"
    done
fi
}

function batteryopenbsd () {
GRML_BATTERY_LEVEL=''
local bat batfull batwarn batnow num
for num in 0 1 ; do
    bat=$(sysctl -n hw.sensors.acpibat${num} 2>/dev/null)
    if [[ -n $bat ]]; then
        batfull=${"$(sysctl -n hw.sensors.acpibat${num}.amphour0)"%% *}
        batwarn=${"$(sysctl -n hw.sensors.acpibat${num}.amphour1)"%% *}
        batnow=${"$(sysctl -n hw.sensors.acpibat${num}.amphour3)"%% *}
        case "$(sysctl -n hw.sensors.acpibat${num}.raw0)" in
            *" discharging"*)
                if (( batnow < batwarn )) ; then
                    GRML_BATTERY_LEVEL+=" !v"
                else
                    GRML_BATTERY_LEVEL+=" v"
                fi
                ;;
            *" charging"*)
                GRML_BATTERY_LEVEL+=" ^"
                ;;
            *)
                GRML_BATTERY_LEVEL+=" ="
                ;;
        esac
        GRML_BATTERY_LEVEL+="${$(( 100 * batnow / batfull ))%%.*}%%"
    fi
done
}

function batteryfreebsd () {
GRML_BATTERY_LEVEL=''
local num
local -A table
for num in 0 1 ; do
    table=( ${=${${${${${(M)${(f)"$(acpiconf -i $num 2>&1)"}:#(State|Remaining capacity):*}%%( ##|%)}//:[ $'\t']##/@}// /-}//@/ }} )
    if [[ -n $table ]] && [[ $table[State] != "not-present" ]] ; then
        case $table[State] in
            *discharging*)
                if (( $table[Remaining-capacity] < 20 )) ; then
                    GRML_BATTERY_LEVEL+=" !v"
                else
                    GRML_BATTERY_LEVEL+=" v"
                fi
                ;;
            *charging*)
                GRML_BATTERY_LEVEL+=" ^"
                ;;
            *)
                GRML_BATTERY_LEVEL+=" ="
                ;;
        esac
        GRML_BATTERY_LEVEL+="$table[Remaining-capacity]%%"
    fi
done
}

function batterydarwin () {
GRML_BATTERY_LEVEL=''
local -a table
table=( ${$(pmset -g ps)[(w)7,8]%%(\%|);} )
if [[ -n $table[2] ]] ; then
    case $table[2] in
        charging)
            GRML_BATTERY_LEVEL+=" ^"
            ;;
        discharging)
            if (( $table[1] < 20 )) ; then
                GRML_BATTERY_LEVEL+=" !v"
            else
                GRML_BATTERY_LEVEL+=" v"
            fi
            ;;
        *)
            GRML_BATTERY_LEVEL+=" ="
            ;;
    esac
    GRML_BATTERY_LEVEL+="$table[1]%%"
fi
}

# set variable debian_chroot if running in a chroot with /etc/debian_chroot
if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]] ; then
    debian_chroot=$(</etc/debian_chroot)
fi

# gather version control information for inclusion in a prompt

if zrcautoload vcs_info; then
    # `vcs_info' in zsh versions 4.3.10 and below have a broken `_realpath'
    # function, which can cause a lot of trouble with our directory-based
    # profiles. So:
    if [[ ${ZSH_VERSION} == 4.3.<-10> ]] ; then
        function VCS_INFO_realpath () {
            setopt localoptions NO_shwordsplit chaselinks
            ( builtin cd -q $1 2> /dev/null && pwd; )
        }
    fi

    zstyle ':vcs_info:*' max-exports 2

    if [[ -o restricted ]]; then
        zstyle ':vcs_info:*' enable NONE
    fi
fi

typeset -A grml_vcs_coloured_formats
typeset -A grml_vcs_plain_formats

grml_vcs_plain_formats=(
    format "(%s%)-[%b] "    "zsh: %r"
    actionformat "(%s%)-[%b|%a] " "zsh: %r"
    rev-branchformat "%b:%r"
)

grml_vcs_coloured_formats=(
    format "${MAGENTA}(${NO_COLOR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${MAGENTA}]${NO_COLOR} "
    actionformat "${MAGENTA}(${NO_COLOR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${YELLOW}|${RED}%a${MAGENTA}]${NO_COLOR} "
    rev-branchformat "%b${RED}:${YELLOW}%r"
)

typeset GRML_VCS_COLOUR_MODE=xxx

function grml_vcs_info_toggle_colour () {
    emulate -L zsh
    if [[ $GRML_VCS_COLOUR_MODE == plain ]]; then
        grml_vcs_info_set_formats coloured
    else
        grml_vcs_info_set_formats plain
    fi
    return 0
}

function grml_vcs_info_set_formats () {
    emulate -L zsh
    #setopt localoptions xtrace
    local mode=$1 AF F BF
    if [[ $mode == coloured ]]; then
        AF=${grml_vcs_coloured_formats[actionformat]}
        F=${grml_vcs_coloured_formats[format]}
        BF=${grml_vcs_coloured_formats[rev-branchformat]}
        GRML_VCS_COLOUR_MODE=coloured
    else
        AF=${grml_vcs_plain_formats[actionformat]}
        F=${grml_vcs_plain_formats[format]}
        BF=${grml_vcs_plain_formats[rev-branchformat]}
        GRML_VCS_COLOUR_MODE=plain
    fi

    zstyle ':vcs_info:*'              actionformats "$AF" "zsh: %r"
    zstyle ':vcs_info:*'              formats       "$F"  "zsh: %r"
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat  "$BF"
    return 0
}

# Change vcs_info formats for the grml prompt. The 2nd format sets up
# $vcs_info_msg_1_ to contain "zsh: repo-name" used to set our screen title.
if [[ "$TERM" == dumb ]] ; then
    grml_vcs_info_set_formats plain
else
    grml_vcs_info_set_formats coloured
fi

# Now for the fun part: The grml prompt themes in `promptsys' mode of operation

# This actually defines three prompts:
#
#    - grml
#    - grml-large
#    - grml-chroot
#
# They all share the same code and only differ with respect to which items they
# contain. The main source of documentation is the `prompt_grml_help' function
# below, which gets called when the user does this: prompt -h grml

function prompt_grml_help () {
    <<__EOF0__
  prompt grml

    This is the prompt as used by the grml-live system <http://grml.org>. It is
    a rather simple one-line prompt, that by default looks something like this:

        <user>@<host> <current-working-directory>[ <vcs_info-data>]%

    The prompt itself integrates with zsh's prompt themes system (as you are
    witnessing right now) and is configurable to a certain degree. In
    particular, these aspects are customisable:

        - The items used in the prompt (e.g. you can remove \`user' from
          the list of activated items, which will cause the user name to
          be omitted from the prompt string).

        - The attributes used with the items are customisable via strings
          used before and after the actual item.

    The available items are: at, battery, change-root, date, grml-chroot,
    history, host, jobs, newline, path, percent, rc, rc-always, sad-smiley,
    shell-level, time, user, vcs

    The actual configuration is done via zsh's \`zstyle' mechanism. The
    context, that is used while looking up styles is:

        ':prompt:grml:<left-or-right>:<subcontext>'

    Here <left-or-right> is either \`left' or \`right', signifying whether the
    style should affect the left or the right prompt. <subcontext> is either
    \`setup' or 'items:<item>', where \`<item>' is one of the available items.

    The styles:

        - use-rprompt (boolean): If \`true' (the default), print a sad smiley
          in $RPROMPT if the last command a returned non-successful error code.
          (This in only valid if <left-or-right> is "right"; ignored otherwise)

        - items (list): The list of items used in the prompt. If \`vcs' is
          present in the list, the theme's code invokes \`vcs_info'
          accordingly. Default (left): rc change-root user at host path vcs
          percent; Default (right): sad-smiley

        - strip-sensitive-characters (boolean): If the \`prompt_subst' option
          is active in zsh, the shell performs lots of expansions on prompt
          variable strings, including command substitution. So if you don't
          control where some of your prompt strings is coming from, this is
          an exploitable weakness. Grml's zsh setup does not set this option
          and it is off in the shell in zsh-mode by default. If it *is* turned
          on however, this style becomes active, and there are two flavours of
          it: On per default is a global variant in the '*:setup' context. This
          strips characters after the whole prompt string was constructed. There
          is a second variant in the '*:items:<item>', that is off by default.
          It allows fine grained control over which items' data is stripped.
          The characters that are stripped are: \$ and \`.

    Available styles in 'items:<item>' are: pre, post. These are strings that
    are inserted before (pre) and after (post) the item in question. Thus, the
    following would cause the user name to be printed in red instead of the
    default blue:

        zstyle ':prompt:grml:*:items:user' pre '%F{red}'

    Note, that the \`post' style may remain at its default value, because its
    default value is '%f', which turns the foreground text attribute off (which
    is exactly, what is still required with the new \`pre' value).
__EOF0__
}

function prompt_grml-chroot_help () {
    <<__EOF0__
  prompt grml-chroot

    This is a variation of the grml prompt, see: prompt -h grml

    The main difference is the default value of the \`items' style. The rest
    behaves exactly the same. Here are the defaults for \`grml-chroot':

        - left: grml-chroot user at host path percent
        - right: (empty list)
__EOF0__
}

function prompt_grml-large_help () {
    <<__EOF0__
  prompt grml-large

    This is a variation of the grml prompt, see: prompt -h grml

    The main difference is the default value of the \`items' style. In
    particular, this theme uses _two_ lines instead of one with the plain
    \`grml' theme. The rest behaves exactly the same. Here are the defaults
    for \`grml-large':

        - left: rc jobs history shell-level change-root time date newline user
                at host path vcs percent
        - right: sad-smiley
__EOF0__
}

function grml_prompt_setup () {
    emulate -L zsh
    autoload -Uz vcs_info
    # The following autoload is disabled for now, since this setup includes a
    # static version of the ‘add-zsh-hook’ function above. It needs to be
    # re-enabled as soon as that static definition is removed again.
    #autoload -Uz add-zsh-hook
    add-zsh-hook precmd prompt_$1_precmd
}

function prompt_grml_setup () {
    grml_prompt_setup grml
}

function prompt_grml-chroot_setup () {
    grml_prompt_setup grml-chroot
}

function prompt_grml-large_setup () {
    grml_prompt_setup grml-large
}

# These maps define default tokens and pre-/post-decoration for items to be
# used within the themes. All defaults may be customised in a context sensitive
# matter by using zsh's `zstyle' mechanism.
typeset -gA grml_prompt_pre_default \
            grml_prompt_post_default \
            grml_prompt_token_default \
            grml_prompt_token_function

grml_prompt_pre_default=(
    at                ''
    battery           ' '
    change-root       ''
    date              '%F{blue}'
    grml-chroot       '%F{red}'
    history           '%F{green}'
    host              ''
    jobs              '%F{cyan}'
    newline           ''
    path              '%B'
    percent           ''
    rc                '%B%F{red}'
    rc-always         ''
    sad-smiley        ''
    shell-level       '%F{red}'
    time              '%F{blue}'
    user              '%B%F{blue}'
    vcs               ''
)

grml_prompt_post_default=(
    at                ''
    battery           ''
    change-root       ''
    date              '%f'
    grml-chroot       '%f '
    history           '%f'
    host              ''
    jobs              '%f'
    newline           ''
    path              '%b'
    percent           ''
    rc                '%f%b'
    rc-always         ''
    sad-smiley        ''
    shell-level       '%f'
    time              '%f'
    user              '%f%b'
    vcs               ''
)

grml_prompt_token_default=(
    at                '@'
    battery           'GRML_BATTERY_LEVEL'
    change-root       'debian_chroot'
    date              '%D{%Y-%m-%d}'
    grml-chroot       'GRML_CHROOT'
    history           '{history#%!} '
    host              '%m '
    jobs              '[%j running job(s)] '
    newline           $'\n'
    path              '%40<..<%~%<< '
    percent           '%# '
    rc                '%(?..%? )'
    rc-always         '%?'
    sad-smiley        '%(?..:()'
    shell-level       '%(3L.+ .)'
    time              '%D{%H:%M:%S} '
    user              '%n'
    vcs               '0'
)

function grml_theme_has_token () {
    if (( ARGC != 1 )); then
        printf 'usage: grml_theme_has_token <name>\n'
        return 1
    fi
    (( ${+grml_prompt_token_default[$1]} ))
}

function GRML_theme_add_token_usage () {
    <<__EOF0__
  Usage: grml_theme_add_token <name> [-f|-i] <token/function> [<pre> <post>]

    <name> is the name for the newly added token. If the \`-f' or \`-i' options
    are used, <token/function> is the name of the function (see below for
    details). Otherwise it is the literal token string to be used. <pre> and
    <post> are optional.

  Options:

    -f <function>   Use a function named \`<function>' each time the token
                    is to be expanded.

    -i <function>   Use a function named \`<function>' to initialise the
                    value of the token _once_ at runtime.

    The functions are called with one argument: the token's new name. The
    return value is expected in the \$REPLY parameter. The use of these
    options is mutually exclusive.

    There is a utility function \`grml_theme_has_token', which you can use
    to test if a token exists before trying to add it. This can be a guard
    for situations in which a \`grml_theme_add_token' call may happen more
    than once.

  Example:

    To add a new token \`day' that expands to the current weekday in the
    current locale in green foreground colour, use this:

      grml_theme_add_token day '%D{%A}' '%F{green}' '%f'

    Another example would be support for \$VIRTUAL_ENV:

      function virtual_env_prompt () {
        REPLY=\${VIRTUAL_ENV+\${VIRTUAL_ENV:t} }
      }
      grml_theme_add_token virtual-env -f virtual_env_prompt

    After that, you will be able to use a changed \`items' style to
    assemble your prompt.
__EOF0__
}

function grml_theme_add_token () {
    emulate -L zsh
    local name token pre post
    local -i init funcall

    if (( ARGC == 0 )); then
        GRML_theme_add_token_usage
        return 0
    fi

    init=0
    funcall=0
    pre=''
    post=''
    name=$1
    shift
    if [[ $1 == '-f' ]]; then
        funcall=1
        shift
    elif [[ $1 == '-i' ]]; then
        init=1
        shift
    fi

    if (( ARGC == 0 )); then
        printf '
grml_theme_add_token: No token-string/function-name provided!\n\n'
        GRML_theme_add_token_usage
        return 1
    fi
    token=$1
    shift
    if (( ARGC != 0 && ARGC != 2 )); then
        printf '
grml_theme_add_token: <pre> and <post> need to by specified _both_!\n\n'
        GRML_theme_add_token_usage
        return 1
    fi
    if (( ARGC )); then
        pre=$1
        post=$2
        shift 2
    fi

    if grml_theme_has_token $name; then
        printf '
grml_theme_add_token: Token `%s'\'' exists! Giving up!\n\n' $name
        GRML_theme_add_token_usage
        return 2
    fi
    if (( init )); then
        REPLY=''
        $token $name
        token=$REPLY
    fi
    grml_prompt_pre_default[$name]=$pre
    grml_prompt_post_default[$name]=$post
    if (( funcall )); then
        grml_prompt_token_function[$name]=$token
        grml_prompt_token_default[$name]=23
    else
        grml_prompt_token_default[$name]=$token
    fi
}

function grml_wrap_reply () {
    emulate -L zsh
    local target="$1"
    local new="$2"
    local left="$3"
    local right="$4"

    if (( ${+parameters[$new]} )); then
        REPLY="${left}${(P)new}${right}"
    else
        REPLY=''
    fi
}

function grml_prompt_addto () {
    emulate -L zsh
    local target="$1"
    local lr it apre apost new v REPLY
    local -a items
    shift

    [[ $target == PS1 ]] && lr=left || lr=right
    zstyle -a ":prompt:${grmltheme}:${lr}:setup" items items || items=( "$@" )
    typeset -g "${target}="
    for it in "${items[@]}"; do
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" pre apre \
            || apre=${grml_prompt_pre_default[$it]}
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" post apost \
            || apost=${grml_prompt_post_default[$it]}
        zstyle -s ":prompt:${grmltheme}:${lr}:items:$it" token new \
            || new=${grml_prompt_token_default[$it]}
        if (( ${+grml_prompt_token_function[$it]} )); then
            REPLY=''
            ${grml_prompt_token_function[$it]} $it
        else
            case $it in
            battery)
                grml_wrap_reply $target $new '' ''
                ;;
            change-root)
                grml_wrap_reply $target $new '(' ')'
                ;;
            grml-chroot)
                if [[ -n ${(P)new} ]]; then
                    REPLY="$CHROOT"
                else
                    REPLY=''
                fi
                ;;
            vcs)
                v="vcs_info_msg_${new}_"
                if (( ! vcscalled )); then
                    vcs_info
                    vcscalled=1
                fi
                if (( ${+parameters[$v]} )) && [[ -n "${(P)v}" ]]; then
                    REPLY="${(P)v}"
                else
                    REPLY=''
                fi
                ;;
            *) REPLY="$new" ;;
            esac
        fi
        # Strip volatile characters per item. This is off by default. See the
        # global stripping code a few lines below for details.
        if [[ -o prompt_subst ]] && zstyle -t ":prompt:${grmltheme}:${lr}:items:$it" \
                                           strip-sensitive-characters
        then
            REPLY="${REPLY//[$\`]/}"
        fi
        typeset -g "${target}=${(P)target}${apre}${REPLY}${apost}"
    done

    # Per default, strip volatile characters (in the prompt_subst case)
    # globally. If the option is off, the style has no effect. For more
    # control, this can be turned off and stripping can be configured on a
    # per-item basis (see above).
    if [[ -o prompt_subst ]] && zstyle -T ":prompt:${grmltheme}:${lr}:setup" \
                                       strip-sensitive-characters
    then
        typeset -g "${target}=${${(P)target}//[$\`]/}"
    fi
}

function prompt_grml_precmd () {
    emulate -L zsh
    local grmltheme=grml
    local -a left_items right_items
    left_items=(rc change-root user at host path vcs percent)
    right_items=(sad-smiley)

    prompt_grml_precmd_worker
}

function prompt_grml-chroot_precmd () {
    emulate -L zsh
    local grmltheme=grml-chroot
    local -a left_items right_items
    left_items=(grml-chroot user at host path percent)
    right_items=()

    prompt_grml_precmd_worker
}

function prompt_grml-large_precmd () {
    emulate -L zsh
    local grmltheme=grml-large
    local -a left_items right_items
    left_items=(rc jobs history shell-level change-root time date newline
                user at host path vcs percent)
    right_items=(sad-smiley)

    prompt_grml_precmd_worker
}

function prompt_grml_precmd_worker () {
    emulate -L zsh
    local -i vcscalled=0

    grml_prompt_addto PS1 "${left_items[@]}"
    if zstyle -T ":prompt:${grmltheme}:right:setup" use-rprompt; then
        grml_prompt_addto RPS1 "${right_items[@]}"
    fi
}

function grml_prompt_fallback () {
    setopt prompt_subst
    local p0 p1

    p0="${RED}%(?..%? )${WHITE}${debian_chroot:+($debian_chroot)}"
    p1="${BLUE}%n${NO_COLOR}@%m %40<...<%B%~%b%<< "'${vcs_info_msg_0_}'"%# "
    if (( EUID == 0 )); then
        PROMPT="${BLUE}${p0}${RED}${p1}"
    else
        PROMPT="${RED}${p0}${BLUE}${p1}"
    fi
}

if zrcautoload promptinit && promptinit 2>/dev/null ; then
    # Since we define the required functions in here and not in files in
    # $fpath, we need to stick the theme's name into `$prompt_themes'
    # ourselves, since promptinit does not pick them up otherwise.
    prompt_themes+=( grml grml-chroot grml-large )
    # Also, keep the array sorted...
    prompt_themes=( "${(@on)prompt_themes}" )
else
    print 'Notice: no promptinit available :('
    grml_prompt_fallback
    function precmd () { (( ${+functions[vcs_info]} )) && vcs_info; }
fi

if is437; then
    # The prompt themes use modern features of zsh, that require at least
    # version 4.3.7 of the shell. Use the fallback otherwise.
    if [[ $GRML_DISPLAY_BATTERY -gt 0 ]]; then
        zstyle ':prompt:grml:right:setup' items sad-smiley battery
        add-zsh-hook precmd battery
    fi
    if [[ "$TERM" == dumb ]] ; then
        zstyle ":prompt:grml(|-large|-chroot):*:items:grml-chroot" pre ''
        zstyle ":prompt:grml(|-large|-chroot):*:items:grml-chroot" post ' '
        for i in rc user path jobs history date time shell-level; do
            zstyle ":prompt:grml(|-large|-chroot):*:items:$i" pre ''
            zstyle ":prompt:grml(|-large|-chroot):*:items:$i" post ''
        done
        unset i
        zstyle ':prompt:grml(|-large|-chroot):right:setup' use-rprompt false
    elif (( EUID == 0 )); then
        zstyle ':prompt:grml(|-large|-chroot):*:items:user' pre '%B%F{red}'
    fi

    # Finally enable one of the prompts.
    if [[ -n $GRML_CHROOT ]]; then
        prompt grml-chroot
    elif [[ $GRMLPROMPT -gt 0 ]]; then
        prompt grml-large
    else
        prompt grml
    fi
else
    grml_prompt_fallback
    function precmd () { (( ${+functions[vcs_info]} )) && vcs_info; }
fi

# Terminal-title wizardry

function ESC_print () {
    info_print $'\ek' $'\e\\' "$@"
}
function set_title () {
    info_print  $'\e]0;' $'\a' "$@"
}

function info_print () {
    local esc_begin esc_end
    esc_begin="$1"
    esc_end="$2"
    shift 2
    printf '%s' ${esc_begin}
    printf '%s' "$*"
    printf '%s' "${esc_end}"
}

function grml_reset_screen_title () {
    # adjust title of xterm
    # see http://www.faqs.org/docs/Linux-mini/Xterm-Title.html
    [[ ${NOTITLE:-} -gt 0 ]] && return 0
    case $TERM in
        (xterm*|rxvt*)
            set_title ${(%):-"%n@%m: %~"}
            ;;
    esac
}

function grml_vcs_to_screen_title () {
    if [[ $TERM == screen* ]] ; then
        if [[ -n ${vcs_info_msg_1_} ]] ; then
            ESC_print ${vcs_info_msg_1_}
        else
            ESC_print "zsh"
        fi
    fi
}

function grml_maintain_name () {
    # set hostname if not running on host with name 'grml'
    if [[ -n "$HOSTNAME" ]] && [[ "$HOSTNAME" != $(hostname) ]] ; then
       NAME="@$HOSTNAME"
    fi
}

function grml_cmd_to_screen_title () {
    # get the name of the program currently running and hostname of local
    # machine set screen window title if running in a screen
    if [[ "$TERM" == screen* ]] ; then
        local CMD="${1[(wr)^(*=*|sudo|ssh|-*)]}$NAME"
        ESC_print ${CMD}
    fi
}

function grml_control_xterm_title () {
    case $TERM in
        (xterm*|rxvt*)
            set_title "${(%):-"%n@%m:"}" "$2"
            ;;
    esac
}

# The following autoload is disabled for now, since this setup includes a
# static version of the ‘add-zsh-hook’ function above. It needs to be
# re-enabled as soon as that static definition is removed again.
#zrcautoload add-zsh-hook || add-zsh-hook () { :; }
if [[ $NOPRECMD -eq 0 ]]; then
    add-zsh-hook precmd grml_reset_screen_title
    add-zsh-hook precmd grml_vcs_to_screen_title
    add-zsh-hook preexec grml_maintain_name
    add-zsh-hook preexec grml_cmd_to_screen_title
    if [[ $NOTITLE -eq 0 ]]; then
        add-zsh-hook preexec grml_control_xterm_title
    fi
fi

# 'hash' some often used directories
#d# start
hash -d deb=/var/cache/apt/archives
hash -d doc=/usr/share/doc
hash -d linux=/lib/modules/$(command uname -r)/build/
hash -d log=/var/log
hash -d slog=/var/log/syslog
hash -d src=/usr/src
hash -d www=/var/www
#d# end

# some aliases
if check_com -c screen ; then
    if [[ $UID -eq 0 ]] ; then
        if [[ -r /etc/grml/screenrc ]]; then
            alias screen='screen -c /etc/grml/screenrc'
        fi
    elif [[ ! -r $HOME/.screenrc ]] ; then
        if [[ -r /etc/grml/screenrc_grml ]]; then
            alias screen='screen -c /etc/grml/screenrc_grml'
        else
            if [[ -r /etc/grml/screenrc ]]; then
                alias screen='screen -c /etc/grml/screenrc'
            fi
        fi
    fi
fi

# do we have GNU ls with color-support?
if [[ "$TERM" != dumb ]]; then
    #a1# List files with colors (\kbd{ls \ldots})
    alias ls="command ls ${ls_options:+${ls_options[*]}}"
    #a1# List all files, with colors (\kbd{ls -la \ldots})
    alias la="command ls -la ${ls_options:+${ls_options[*]}}"
    #a1# List files with long colored list, without dotfiles (\kbd{ls -l \ldots})
    alias ll="command ls -l ${ls_options:+${ls_options[*]}}"
    #a1# List files with long colored list, human readable sizes (\kbd{ls -hAl \ldots})
    alias lh="command ls -hAl ${ls_options:+${ls_options[*]}}"
    #a1# List files with long colored list, append qualifier to filenames (\kbd{ls -l \ldots})\\&\quad(\kbd{/} for directories, \kbd{@} for symlinks ...)
    alias l="command ls -l ${ls_options:+${ls_options[*]}}"
else
    alias la='command ls -la'
    alias ll='command ls -l'
    alias lh='command ls -hAl'
    alias l='command ls -l'
fi

if [[ -r /proc/mdstat ]]; then
    alias mdstat='cat /proc/mdstat'
fi

alias ...='cd ../../'

# generate alias named "$KERNELVERSION-reboot" so you can use boot with kexec:
if [[ -x /sbin/kexec ]] && [[ -r /proc/cmdline ]] ; then
    alias "$(uname -r)-reboot"="kexec -l --initrd=/boot/initrd.img-"$(uname -r)" --command-line=\"$(cat /proc/cmdline)\" /boot/vmlinuz-"$(uname -r)""
fi

# see http://www.cl.cam.ac.uk/~mgk25/unicode.html#term for details
alias term2iso="echo 'Setting terminal to iso mode' ; print -n '\e%@'"
alias term2utf="echo 'Setting terminal to utf-8 mode'; print -n '\e%G'"

# make sure it is not assigned yet
[[ -n ${aliases[utf2iso]} ]] && unalias utf2iso
function utf2iso () {
    if isutfenv ; then
        local ENV
        for ENV in $(env | command grep -i '.utf') ; do
            eval export "$(echo $ENV | sed 's/UTF-8/iso885915/ ; s/utf8/iso885915/')"
        done
    fi
}

# make sure it is not assigned yet
[[ -n ${aliases[iso2utf]} ]] && unalias iso2utf
function iso2utf () {
    if ! isutfenv ; then
        local ENV
        for ENV in $(env | command grep -i '\.iso') ; do
            eval export "$(echo $ENV | sed 's/iso.*/UTF-8/ ; s/ISO.*/UTF-8/')"
        done
    fi
}

# especially for roadwarriors using GNU screen and ssh:
if ! check_com asc &>/dev/null ; then
  function asc () { autossh -t "$@" 'screen -RdU' }
  compdef asc=ssh
fi

#f1# Hints for the use of zsh on grml
function zsh-help () {
    print "$bg[white]$fg[black]
zsh-help - hints for use of zsh on grml
=======================================$reset_color"

    print '
Main configuration of zsh happens in /etc/zsh/zshrc.
That file is part of the package grml-etc-core, if you want to
use them on a non-grml-system just get the tar.gz from
http://deb.grml.org/ or (preferably) get it from the git repository:

  http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

This version of grml'\''s zsh setup does not use skel/.zshrc anymore.
The file is still there, but it is empty for backwards compatibility.

For your own changes use these two files:
    $HOME/.zshrc.pre
    $HOME/.zshrc.local

The former is sourced very early in our zshrc, the latter is sourced
very lately.

System wide configuration without touching configuration files of grml
can take place in /etc/zsh/zshrc.local.

For information regarding zsh start at http://grml.org/zsh/

Take a look at grml'\''s zsh refcard:
% xpdf =(zcat /usr/share/doc/grml-docs/zsh/grml-zsh-refcard.pdf.gz)

Check out the main zsh refcard:
% '$BROWSER' http://www.bash2zsh.com/zsh_refcard/refcard.pdf

And of course visit the zsh-lovers:
% man zsh-lovers

You can adjust some options through environment variables when
invoking zsh without having to edit configuration files.
Basically meant for bash users who are not used to the power of
the zsh yet. :)

  "NOCOR=1    zsh" => deactivate automatic correction
  "NOMENU=1   zsh" => do not use auto menu completion
                      (note: use ctrl-d for completion instead!)
  "NOPRECMD=1 zsh" => disable the precmd + preexec commands (set GNU screen title)
  "NOTITLE=1  zsh" => disable setting the title of xterms without disabling
                      preexec() and precmd() completely
  "GRML_DISPLAY_BATTERY=1  zsh"
                   => activate battery status on right side of prompt (WIP)
  "COMMAND_NOT_FOUND=1 zsh"
                   => Enable a handler if an external command was not found
                      The command called in the handler can be altered by setting
                      the GRML_ZSH_CNF_HANDLER variable, the default is:
                      "/usr/share/command-not-found/command-not-found"

A value greater than 0 is enables a feature; a value equal to zero
disables it. If you like one or the other of these settings, you can
add them to ~/.zshrc.pre to ensure they are set when sourcing grml'\''s
zshrc.'

    print "
$bg[white]$fg[black]
Please report wishes + bugs to the grml-team: http://grml.org/bugs/
Enjoy your grml system with the zsh!$reset_color"
}

# debian stuff
if [[ -r /etc/debian_version ]] ; then
    if [[ -z "$GRML_NO_APT_ALIASES" ]]; then
        #a3# Execute \kbd{apt-cache policy}
        alias acp='apt-cache policy'
        if check_com -c apt ; then
          #a3# Execute \kbd{apt search}
          alias acs='apt search'
          #a3# Execute \kbd{apt show}
          alias acsh='apt show'
          #a3# Execute \kbd{apt dist-upgrade}
          salias adg="apt dist-upgrade"
          #a3# Execute \kbd{apt upgrade}
          salias ag="apt upgrade"
          #a3# Execute \kbd{apt install}
          salias agi="apt install"
          #a3# Execute \kbd{apt update}
          salias au="apt update"
        else
          alias acs='apt-cache search'
          alias acsh='apt-cache show'
          salias adg="apt-get dist-upgrade"
          salias ag="apt-get upgrade"
          salias agi="apt-get install"
          salias au="apt-get update"
        fi
        #a3# Execute \kbd{aptitude install}
        salias ati="aptitude install"
        #a3# Execute \kbd{aptitude update ; aptitude safe-upgrade}
        salias -a up="aptitude update ; aptitude safe-upgrade"
        #a3# Execute \kbd{dpkg-buildpackage}
        alias dbp='dpkg-buildpackage'
        #a3# Execute \kbd{grep-excuses}
        alias ge='grep-excuses'
    fi

    # get a root shell as normal user in live-cd mode:
    if isgrmlcd && [[ $UID -ne 0 ]] ; then
       alias su="sudo su"
    fi

fi

# use /var/log/syslog iff present, fallback to journalctl otherwise
if [ -e /var/log/syslog ] ; then
  #a1# Take a look at the syslog: \kbd{\$PAGER /var/log/syslog || journalctl}
  salias llog="$PAGER /var/log/syslog"     # take a look at the syslog
  #a1# Take a look at the syslog: \kbd{tail -f /var/log/syslog || journalctl}
  salias tlog="tail -f /var/log/syslog"    # follow the syslog
elif check_com -c journalctl ; then
  salias llog="journalctl"
  salias tlog="journalctl -f"
fi

# sort installed Debian-packages by size
if check_com -c dpkg-query ; then
    #a3# List installed Debian-packages sorted by size
    alias debs-by-size="dpkg-query -Wf 'x \${Installed-Size} \${Package} \${Status}\n' | sed -ne '/^x  /d' -e '/^x \(.*\) install ok installed$/s//\1/p' | sort -nr"
fi

# if cdrecord is a symlink (to wodim) or isn't present at all warn:
if [[ -L /usr/bin/cdrecord ]] || ! check_com -c cdrecord; then
    if check_com -c wodim; then
        function cdrecord () {
            <<__EOF0__
cdrecord is not provided under its original name by Debian anymore.
See #377109 in the BTS of Debian for more details.

Please use the wodim binary instead
__EOF0__
            return 1
        }
    fi
fi

if isgrmlcd; then
    # No core dumps: important for a live-cd-system
    limit -s core 0
fi

# grmlstuff
function grmlstuff () {
# people should use 'grml-x'!
    if check_com -c 915resolution; then
        function 855resolution () {
            echo "Please use 915resolution as resolution modifying tool for Intel \
graphic chipset."
            return -1
        }
    fi

    #a1# Output version of running grml
    alias grml-version='cat /etc/grml_version'

    if check_com -c grml-debootstrap ; then
        function debian2hd () {
            echo "Installing debian to harddisk is possible by using grml-debootstrap."
            return 1
        }
    fi
}

# now run the functions
isgrml && checkhome
is4    && isgrml    && grmlstuff
is4    && grmlcomp

# keephack
is4 && xsource "/etc/zsh/keephack"

# wonderful idea of using "e" glob qualifier by Peter Stephenson
# You use it as follows:
# $ NTREF=/reference/file
# $ ls -l *(e:nt:)
# This lists all the files in the current directory newer than the reference file.
# You can also specify the reference file inline; note quotes:
# $ ls -l *(e:'nt ~/.zshenv':)
is4 && function nt () {
    if [[ -n $1 ]] ; then
        local NTREF=${~1}
    fi
    [[ $REPLY -nt $NTREF ]]
}

# shell functions

#f1# Reload an autoloadable function
function freload () { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
compdef _functions freload

#
# Usage:
#
#      e.g.:   a -> b -> c -> d  ....
#
#      sll a
#
#
#      if parameter is given with leading '=', lookup $PATH for parameter and resolve that
#
#      sll =java
#
#      Note: limit for recursive symlinks on linux:
#            http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/namei.c?id=refs/heads/master#l808
#            This limits recursive symlink follows to 8,
#            while limiting consecutive symlinks to 40.
#
#      When resolving and displaying information about symlinks, no check is made
#      that the displayed information does make any sense on your OS.
#      We leave that decission to the user.
#
#      The zstat module is used to detect symlink loops. zstat is available since zsh4.
#      With an older zsh you will need to abort with <C-c> in that case.
#      When a symlink loop is detected, a warning ist printed and further processing is stopped.
#
#      Module zstat is loaded by default in grml zshrc, no extra action needed for that.
#
#      Known bugs:
#      If you happen to come across a symlink that points to a destination on another partition
#      with the same inode number, that will be marked as symlink loop though it is not.
#      Two hints for this situation:
#      I)  Play lottery the same day, as you seem to be rather lucky right now.
#      II) Send patches.
#
#      return status:
#      0 upon success
#      1 file/dir not accesible
#      2 symlink loop detected
#
#f1# List symlinks in detail (more detailed version of 'readlink -f', 'whence -s' and 'namei -l')
function sll () {
    if [[ -z ${1} ]] ; then
        printf 'Usage: %s <symlink(s)>\n' "${0}"
        return 1
    fi

    local file jumpd curdir
    local -i 10 RTN LINODE i
    local -a    SEENINODES
    curdir="${PWD}"
    RTN=0

    for file in "${@}" ; do
        SEENINODES=()
        ls -l "${file:a}"   || RTN=1

        while [[ -h "$file" ]] ; do
            if is4 ; then
                LINODE=$(zstat -L +inode "${file}")
                for i in ${SEENINODES} ; do
                    if (( ${i} == ${LINODE} )) ; then
                        builtin cd -q "${curdir}"
                        print 'link loop detected, aborting!'
                        return 2
                    fi
                done
                SEENINODES+=${LINODE}
            fi
            jumpd="${file:h}"
            file="${file:t}"

            if [[ -d ${jumpd} ]] ; then
                builtin cd -q "${jumpd}"  || RTN=1
            fi
            file=$(readlink "$file")

            jumpd="${file:h}"
            file="${file:t}"

            if [[ -d ${jumpd} ]] ; then
                builtin cd -q "${jumpd}"  || RTN=1
            fi

            ls -l "${PWD}/${file}"     || RTN=1
        done
        shift 1
        if (( ${#} >= 1 )) ; then
            print ""
        fi
        builtin cd -q "${curdir}"
    done
    return ${RTN}
}

# TODO: Is it supported to use pager settings like this?
#   PAGER='less -Mr' - If so, the use of $PAGER here needs fixing
# with respect to wordsplitting. (ie. ${=PAGER})
if check_com -c $PAGER ; then
    #f3# View Debian's changelog of given package(s)
    function dchange () {
        emulate -L zsh
        [[ -z "$1" ]] && printf 'Usage: %s <package_name(s)>\n' "$0" && return 1

        local package
        for package in "$@" ; do
            if [[ -r /usr/share/doc/${package}/changelog.Debian.gz ]] ; then
                $PAGER /usr/share/doc/${package}/changelog.Debian.gz
            elif [[ -r /usr/share/doc/${package}/changelog.gz ]] ; then
                $PAGER /usr/share/doc/${package}/changelog.gz
            elif [[ -r /usr/share/doc/${package}/changelog ]] ; then
                $PAGER /usr/share/doc/${package}/changelog
            else
                if check_com -c aptitude ; then
                    echo "No changelog for package $package found, using aptitude to retrieve it."
                    aptitude changelog "$package"
                elif check_com -c apt-get ; then
                    echo "No changelog for package $package found, using apt-get to retrieve it."
                    apt-get changelog "$package"
                else
                    echo "No changelog for package $package found, sorry."
                fi
            fi
        done
    }
    function _dchange () { _files -W /usr/share/doc -/ }
    compdef _dchange dchange

    #f3# View Debian's NEWS of a given package
    function dnews () {
        emulate -L zsh
        if [[ -r /usr/share/doc/$1/NEWS.Debian.gz ]] ; then
            $PAGER /usr/share/doc/$1/NEWS.Debian.gz
        else
            if [[ -r /usr/share/doc/$1/NEWS.gz ]] ; then
                $PAGER /usr/share/doc/$1/NEWS.gz
            else
                echo "No NEWS file for package $1 found, sorry."
                return 1
            fi
        fi
    }
    function _dnews () { _files -W /usr/share/doc -/ }
    compdef _dnews dnews

    #f3# View Debian's copyright of a given package
    function dcopyright () {
        emulate -L zsh
        if [[ -r /usr/share/doc/$1/copyright ]] ; then
            $PAGER /usr/share/doc/$1/copyright
        else
            echo "No copyright file for package $1 found, sorry."
            return 1
        fi
    }
    function _dcopyright () { _files -W /usr/share/doc -/ }
    compdef _dcopyright dcopyright

    #f3# View upstream's changelog of a given package
    function uchange () {
        emulate -L zsh
        if [[ -r /usr/share/doc/$1/changelog.gz ]] ; then
            $PAGER /usr/share/doc/$1/changelog.gz
        else
            echo "No changelog for package $1 found, sorry."
            return 1
        fi
    }
    function _uchange () { _files -W /usr/share/doc -/ }
    compdef _uchange uchange
fi

# zsh profiling
function profile () {
    ZSH_PROFILE_RC=1 zsh "$@"
}

#f1# Edit an alias via zle
function edalias () {
    [[ -z "$1" ]] && { echo "Usage: edalias <alias_to_edit>" ; return 1 } || vared aliases'[$1]' ;
}
compdef _aliases edalias

#f1# Edit a function via zle
function edfunc () {
    [[ -z "$1" ]] && { echo "Usage: edfunc <function_to_edit>" ; return 1 } || zed -f "$1" ;
}
compdef _functions edfunc

# use it e.g. via 'Restart apache2'
#m# f6 Start() \kbd{service \em{process}}\quad\kbd{start}
#m# f6 Restart() \kbd{service \em{process}}\quad\kbd{restart}
#m# f6 Stop() \kbd{service \em{process}}\quad\kbd{stop}
#m# f6 Reload() \kbd{service \em{process}}\quad\kbd{reload}
#m# f6 Force-Reload() \kbd{service \em{process}}\quad\kbd{force-reload}
#m# f6 Status() \kbd{service \em{process}}\quad\kbd{status}
if [[ -d /etc/init.d || -d /etc/service ]] ; then
    function __start_stop () {
        local action_="${1:l}"  # e.g Start/Stop/Restart
        local service_="$2"
        local param_="$3"

        local service_target_="$(readlink /etc/init.d/$service_)"
        if [[ $service_target_ == "/usr/bin/sv" ]]; then
            # runit
            case "${action_}" in
                start) if [[ ! -e /etc/service/$service_ ]]; then
                           $SUDO ln -s "/etc/sv/$service_" "/etc/service/"
                       else
                           $SUDO "/etc/init.d/$service_" "${action_}" "$param_"
                       fi ;;
                # there is no reload in runits sysv emulation
                reload) $SUDO "/etc/init.d/$service_" "force-reload" "$param_" ;;
                *) $SUDO "/etc/init.d/$service_" "${action_}" "$param_" ;;
            esac
        else
            # sysv/sysvinit-utils, upstart
            if check_com -c service ; then
              $SUDO service "$service_" "${action_}" "$param_"
            else
              $SUDO "/etc/init.d/$service_" "${action_}" "$param_"
            fi
        fi
    }

    function _grmlinitd () {
        local -a scripts
        scripts=( /etc/init.d/*(x:t) )
        _describe "service startup script" scripts
    }

    for i in Start Restart Stop Force-Reload Reload Status ; do
        eval "function $i () { __start_stop $i \"\$1\" \"\$2\" ; }"
        compdef _grmlinitd $i
    done
    builtin unset -v i
fi

#f1# Provides useful information on globbing
function H-Glob () {
    echo -e "
    /      directories
    .      plain files
    @      symbolic links
    =      sockets
    p      named pipes (FIFOs)
    *      executable plain files (0100)
    %      device files (character or block special)
    %b     block special files
    %c     character special files
    r      owner-readable files (0400)
    w      owner-writable files (0200)
    x      owner-executable files (0100)
    A      group-readable files (0040)
    I      group-writable files (0020)
    E      group-executable files (0010)
    R      world-readable files (0004)
    W      world-writable files (0002)
    X      world-executable files (0001)
    s      setuid files (04000)
    S      setgid files (02000)
    t      files with the sticky bit (01000)

  print *(m-1)          # Files modified up to a day ago
  print *(a1)           # Files accessed a day ago
  print *(@)            # Just symlinks
  print *(Lk+50)        # Files bigger than 50 kilobytes
  print *(Lk-50)        # Files smaller than 50 kilobytes
  print **/*.c          # All *.c files recursively starting in \$PWD
  print **/*.c~file.c   # Same as above, but excluding 'file.c'
  print (foo|bar).*     # Files starting with 'foo' or 'bar'
  print *~*.*           # All Files that do not contain a dot
  chmod 644 *(.^x)      # make all plain non-executable files publically readable
  print -l *(.c|.h)     # Lists *.c and *.h
  print **/*(g:users:)  # Recursively match all files that are owned by group 'users'
  echo /proc/*/cwd(:h:t:s/self//) # Analogous to >ps ax | awk '{print $1}'<"
}
alias help-zshglob=H-Glob

# grep for running process, like: 'any vim'
function any () {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any <keyword>" >&2 ; return 1
    else
        ps xauwww | grep -i "${grep_options[@]}" "[${1[1]}]${1[2,-1]}"
    fi
}


# After resuming from suspend, system is paging heavily, leading to very bad interactivity.
# taken from $LINUX-KERNELSOURCE/Documentation/power/swsusp.txt
[[ -r /proc/1/maps ]] && \
function deswap () {
    print 'Reading /proc/[0-9]*/maps and sending output to /dev/null, this might take a while.'
    cat $(sed -ne 's:.* /:/:p' /proc/[0-9]*/maps | sort -u | grep -v '^/dev/')  > /dev/null
    print 'Finished, running "swapoff -a; swapon -a" may also be useful.'
}

# a wrapper for vim, that deals with title setting
#   VIM_OPTIONS
#       set this array to a set of options to vim you always want
#       to have set when calling vim (in .zshrc.local), like:
#           VIM_OPTIONS=( -p )
#       This will cause vim to send every file given on the
#       commandline to be send to it's own tab (needs vim7).
if check_com vim; then
    function vim () {
        VIM_PLEASE_SET_TITLE='yes' command vim ${VIM_OPTIONS} "$@"
    }
fi

ssl_hashes=( sha512 sha256 sha1 md5 )

for sh in ${ssl_hashes}; do
    eval 'ssl-cert-'${sh}'() {
        emulate -L zsh
        if [[ -z $1 ]] ; then
            printf '\''usage: %s <file>\n'\'' "ssh-cert-'${sh}'"
            return 1
        fi
        openssl x509 -noout -fingerprint -'${sh}' -in $1
    }'
done; unset sh

function ssl-cert-fingerprints () {
    emulate -L zsh
    local i
    if [[ -z $1 ]] ; then
        printf 'usage: ssl-cert-fingerprints <file>\n'
        return 1
    fi
    for i in ${ssl_hashes}
        do ssl-cert-$i $1;
    done
}

function ssl-cert-info () {
    emulate -L zsh
    if [[ -z $1 ]] ; then
        printf 'usage: ssl-cert-info <file>\n'
        return 1
    fi
    openssl x509 -noout -text -in $1
    ssl-cert-fingerprints $1
}

# make sure our environment is clean regarding colors
builtin unset -v BLUE RED GREEN CYAN YELLOW MAGENTA WHITE NO_COLOR

# "persistent history"
# just write important commands you always need to $GRML_IMPORTANT_COMMANDS
# defaults for backward compatibility to ~/.important_commands
if [[ -r ~/.important_commands ]] ; then
    GRML_IMPORTANT_COMMANDS=~/.important_commands
else
    GRML_IMPORTANT_COMMANDS=${GRML_IMPORTANT_COMMANDS:-${ZDOTDIR:-${HOME}}/.important_commands}
fi
[[ -r ${GRML_IMPORTANT_COMMANDS} ]] && builtin fc -R ${GRML_IMPORTANT_COMMANDS}

# load the lookup subsystem if it's available on the system
zrcautoload lookupinit && lookupinit

# variables

# set terminal property (used e.g. by msgid-chooser)
export COLORTERM="yes"

# aliases

# general
#a2# Execute \kbd{du -sch}
[[ -n "$GRML_NO_SMALL_ALIASES" ]] || alias da='du -sch'

# listing stuff
#a2# Execute \kbd{ls -lSrah}
alias dir="command ls -lSrah"
#a2# Only show dot-directories
alias lad='command ls -d .*(/)'
#a2# Only show dot-files
alias lsa='command ls -a .*(.)'
#a2# Only files with setgid/setuid/sticky flag
alias lss='command ls -l *(s,S,t)'
#a2# Only show symlinks
alias lsl='command ls -l *(@)'
#a2# Display only executables
alias lsx='command ls -l *(*)'
#a2# Display world-{readable,writable,executable} files
alias lsw='command ls -ld *(R,W,X.^ND/)'
#a2# Display the ten biggest files
alias lsbig="command ls -flh *(.OL[1,10])"
#a2# Only show directories
alias lsd='command ls -d *(/)'
#a2# Only show empty directories
alias lse='command ls -d *(/^F)'
#a2# Display the ten newest files
alias lsnew="command ls -rtlh *(D.om[1,10])"
#a2# Display the ten oldest files
alias lsold="command ls -rtlh *(D.Om[1,10])"
#a2# Display the ten smallest files
alias lssmall="command ls -Srl *(.oL[1,10])"
#a2# Display the ten newest directories and ten newest .directories
alias lsnewdir="command ls -rthdl *(/om[1,10]) .*(D/om[1,10])"
#a2# Display the ten oldest directories and ten oldest .directories
alias lsolddir="command ls -rthdl *(/Om[1,10]) .*(D/Om[1,10])"

# some useful aliases
#a2# Remove current empty directory. Execute \kbd{cd ..; rmdir \$OLDCWD}
alias rmcdir='cd ..; rmdir $OLDPWD || cd $OLDPWD'

#a2# ssh with StrictHostKeyChecking=no \\&\quad and UserKnownHostsFile unset
alias insecssh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
#a2# scp with StrictHostKeyChecking=no \\&\quad and UserKnownHostsFile unset
alias insecscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'

# work around non utf8 capable software in utf environment via $LANG and luit
if check_com isutfenv && check_com luit ; then
    if check_com -c mrxvt ; then
        isutfenv && [[ -n "$LANG" ]] && \
            alias mrxvt="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} luit mrxvt"
    fi

    if check_com -c aterm ; then
        isutfenv && [[ -n "$LANG" ]] && \
            alias aterm="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} luit aterm"
    fi

    if check_com -c centericq ; then
        isutfenv && [[ -n "$LANG" ]] && \
            alias centericq="LANG=${LANG/(#b)(*)[.@]*/$match[1].iso885915} luit centericq"
    fi
fi

# useful functions

#f5# Backup \kbd{file_or_folder {\rm to} file_or_folder\_timestamp}
function bk () {
    emulate -L zsh
    local current_date=$(date -u "+%Y%m%dT%H%M%SZ")
    local clean keep move verbose result all to_bk
    setopt extended_glob
    keep=1
    while getopts ":hacmrv" opt; do
        case $opt in
            a) (( all++ ));;
            c) unset move clean && (( ++keep ));;
            m) unset keep clean && (( ++move ));;
            r) unset move keep && (( ++clean ));;
            v) verbose="-v";;
            h) <<__EOF0__
bk [-hcmv] FILE [FILE ...]
bk -r [-av] [FILE [FILE ...]]
Backup a file or folder in place and append the timestamp
Remove backups of a file or folder, or all backups in the current directory

Usage:
-h    Display this help text
-c    Keep the file/folder as is, create a copy backup using cp(1) (default)
-m    Move the file/folder, using mv(1)
-r    Remove backups of the specified file or directory, using rm(1). If none
      is provided, remove all backups in the current directory.
-a    Remove all (even hidden) backups.
-v    Verbose

The -c, -r and -m options are mutually exclusive. If specified at the same time,
the last one is used.

The return code is the sum of all cp/mv/rm return codes.
__EOF0__
return 0;;
            \?) bk -h >&2; return 1;;
        esac
    done
    shift "$((OPTIND-1))"
    if (( keep > 0 )); then
        if islinux || isfreebsd; then
            for to_bk in "$@"; do
                cp $verbose -a "${to_bk%/}" "${to_bk%/}_$current_date"
                (( result += $? ))
            done
        else
            for to_bk in "$@"; do
                cp $verbose -pR "${to_bk%/}" "${to_bk%/}_$current_date"
                (( result += $? ))
            done
        fi
    elif (( move > 0 )); then
        while (( $# > 0 )); do
            mv $verbose "${1%/}" "${1%/}_$current_date"
            (( result += $? ))
            shift
        done
    elif (( clean > 0 )); then
        if (( $# > 0 )); then
            for to_bk in "$@"; do
                rm $verbose -rf "${to_bk%/}"_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z
                (( result += $? ))
            done
        else
            if (( all > 0 )); then
                rm $verbose -rf *_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z(D)
            else
                rm $verbose -rf *_[0-9](#c8)T([0-1][0-9]|2[0-3])([0-5][0-9])(#c2)Z
            fi
            (( result += $? ))
        fi
    fi
    return $result
}

#f5# cd to directory and list files
function cl () {
    emulate -L zsh
    cd $1 && ls -a
}

# smart cd function, allows switching to /etc when running 'cd /etc/fstab'
function cd () {
    if (( ${#argv} == 1 )) && [[ -f ${1} ]]; then
        [[ ! -e ${1:h} ]] && return 1
        print "Correcting ${1} to ${1:h}"
        builtin cd ${1:h}
    else
        builtin cd "$@"
    fi
}

#f5# Create Directory and \kbd{cd} to it
function mkcd () {
    if (( ARGC != 1 )); then
        printf 'usage: mkcd <new-directory>\n'
        return 1;
    fi
    if [[ ! -d "$1" ]]; then
        command mkdir -p "$1"
    else
        printf '`%s'\'' already exists: cd-ing.\n' "$1"
    fi
    builtin cd "$1"
}

#f5# Create temporary directory and \kbd{cd} to it
function cdt () {
    builtin cd "$(mktemp -d)"
    builtin pwd
}

#f5# List files which have been accessed within the last {\it n} days, {\it n} defaults to 1
function accessed () {
    emulate -L zsh
    print -l -- *(a-${1:-1})
}

#f5# List files which have been changed within the last {\it n} days, {\it n} defaults to 1
function changed () {
    emulate -L zsh
    print -l -- *(c-${1:-1})
}

#f5# List files which have been modified within the last {\it n} days, {\it n} defaults to 1
function modified () {
    emulate -L zsh
    print -l -- *(m-${1:-1})
}
# modified() was named new() in earlier versions, add an alias for backwards compatibility
check_com new || alias new=modified

# use colors when GNU grep with color-support
if (( $#grep_options > 0 )); then
    o=${grep_options:+"${grep_options[*]}"}
    #a2# Execute \kbd{grep -{}-color=auto}
    alias grep='grep '$o
    alias egrep='egrep '$o
    unset o
fi

# Translate DE<=>EN
# 'translate' looks up a word in a file with language-to-language
# translations (field separator should be " : "). A typical wordlist looks
# like the following:
#  | english-word : german-translation
# It's also only possible to translate english to german but not reciprocal.
# Use the following oneliner to reverse the sort order:
#  $ awk -F ':' '{ print $2" : "$1" "$3 }' \
#    /usr/local/lib/words/en-de.ISO-8859-1.vok > ~/.translate/de-en.ISO-8859-1.vok
#f5# Translates a word
function trans () {
    emulate -L zsh
    case "$1" in
        -[dD]*)
            translate -l de-en $2
            ;;
        -[eE]*)
            translate -l en-de $2
            ;;
        *)
            echo "Usage: $0 { -D | -E }"
            echo "         -D == German to English"
            echo "         -E == English to German"
    esac
}

# Usage: simple-extract <file>
# Using option -d deletes the original archive file.
#f5# Smart archive extractor
function simple-extract () {
    emulate -L zsh
    setopt extended_glob noclobber
    local ARCHIVE DELETE_ORIGINAL DECOMP_CMD USES_STDIN USES_STDOUT GZTARGET WGET_CMD
    local RC=0
    zparseopts -D -E "d=DELETE_ORIGINAL"
    for ARCHIVE in "${@}"; do
        case $ARCHIVE in
            *(tar.bz2|tbz2|tbz))
                DECOMP_CMD="tar -xvjf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *(tar.gz|tgz))
                DECOMP_CMD="tar -xvzf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *(tar.xz|txz|tar.lzma))
                DECOMP_CMD="tar -xvJf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *tar)
                DECOMP_CMD="tar -xvf -"
                USES_STDIN=true
                USES_STDOUT=false
                ;;
            *rar)
                DECOMP_CMD="unrar x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *lzh)
                DECOMP_CMD="lha x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *7z)
                DECOMP_CMD="7z x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *(zip|jar))
                DECOMP_CMD="unzip"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *deb)
                DECOMP_CMD="ar -x"
                USES_STDIN=false
                USES_STDOUT=false
                ;;
            *bz2)
                DECOMP_CMD="bzip2 -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *(gz|Z))
                DECOMP_CMD="gzip -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *(xz|lzma))
                DECOMP_CMD="xz -d -c -"
                USES_STDIN=true
                USES_STDOUT=true
                ;;
            *)
                print "ERROR: '$ARCHIVE' has unrecognized archive type." >&2
                RC=$((RC+1))
                continue
                ;;
        esac

        if ! check_com ${DECOMP_CMD[(w)1]}; then
            echo "ERROR: ${DECOMP_CMD[(w)1]} not installed." >&2
            RC=$((RC+2))
            continue
        fi

        GZTARGET="${ARCHIVE:t:r}"
        if [[ -f $ARCHIVE ]] ; then

            print "Extracting '$ARCHIVE' ..."
            if $USES_STDIN; then
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} < "$ARCHIVE" > $GZTARGET
                else
                    ${=DECOMP_CMD} < "$ARCHIVE"
                fi
            else
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} "$ARCHIVE" > $GZTARGET
                else
                    ${=DECOMP_CMD} "$ARCHIVE"
                fi
            fi
            [[ $? -eq 0 && -n "$DELETE_ORIGINAL" ]] && rm -f "$ARCHIVE"

        elif [[ "$ARCHIVE" == (#s)(https|http|ftp)://* ]] ; then
            if check_com curl; then
                WGET_CMD="curl -L -s -o -"
            elif check_com wget; then
                WGET_CMD="wget -q -O -"
            elif check_com fetch; then
                WGET_CMD="fetch -q -o -"
            else
                print "ERROR: neither wget, curl nor fetch is installed" >&2
                RC=$((RC+4))
                continue
            fi
            print "Downloading and Extracting '$ARCHIVE' ..."
            if $USES_STDIN; then
                if $USES_STDOUT; then
                    ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD} > $GZTARGET
                    RC=$((RC+$?))
                else
                    ${=WGET_CMD} "$ARCHIVE" | ${=DECOMP_CMD}
                    RC=$((RC+$?))
                fi
            else
                if $USES_STDOUT; then
                    ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE") > $GZTARGET
                else
                    ${=DECOMP_CMD} =(${=WGET_CMD} "$ARCHIVE")
                fi
            fi

        else
            print "ERROR: '$ARCHIVE' is neither a valid file nor a supported URI." >&2
            RC=$((RC+8))
        fi
    done
    return $RC
}

function __archive_or_uri () {
    _alternative \
        'files:Archives:_files -g "*.(#l)(tar.bz2|tbz2|tbz|tar.gz|tgz|tar.xz|txz|tar.lzma|tar|rar|lzh|7z|zip|jar|deb|bz2|gz|Z|xz|lzma)"' \
        '_urls:Remote Archives:_urls'
}

function _simple_extract () {
    _arguments \
        '-d[delete original archivefile after extraction]' \
        '*:Archive Or Uri:__archive_or_uri'
}
compdef _simple_extract simple-extract
[[ -n "$GRML_NO_SMALL_ALIASES" ]] || alias se=simple-extract

#f5# Change the xterm title from within GNU-screen
function xtrename () {
    emulate -L zsh
    if [[ $1 != "-f" ]] ; then
        if [[ -z ${DISPLAY} ]] ; then
            printf 'xtrename only makes sense in X11.\n'
            return 1
        fi
    else
        shift
    fi
    if [[ -z $1 ]] ; then
        printf 'usage: xtrename [-f] "title for xterm"\n'
        printf '  renames the title of xterm from _within_ screen.\n'
        printf '  also works without screen.\n'
        printf '  will not work if DISPLAY is unset, use -f to override.\n'
        return 0
    fi
    print -n "\eP\e]0;${1}\C-G\e\\"
    return 0
}

# Create small urls via http://goo.gl using curl(1).
# API reference: https://code.google.com/apis/urlshortener/
function zurl () {
    emulate -L zsh
    setopt extended_glob

    if [[ -z $1 ]]; then
        print "USAGE: zurl <URL>"
        return 1
    fi

    local PN url prog api json contenttype item
    local -a data
    PN=$0
    url=$1

    # Prepend 'http://' to given URL where necessary for later output.
    if [[ ${url} != http(s|)://* ]]; then
        url='http://'${url}
    fi

    if check_com -c curl; then
        prog=curl
    else
        print "curl is not available, but mandatory for ${PN}. Aborting."
        return 1
    fi
    api='https://www.googleapis.com/urlshortener/v1/url'
    contenttype="Content-Type: application/json"
    json="{\"longUrl\": \"${url}\"}"
    data=(${(f)"$($prog --silent -H ${contenttype} -d ${json} $api)"})
    # Parse the response
    for item in "${data[@]}"; do
        case "$item" in
            ' '#'"id":'*)
                item=${item#*: \"}
                item=${item%\",*}
                printf '%s\n' "$item"
                return 0
                ;;
        esac
    done
    return 1
}

#f2# Find history events by search pattern and list them by date.
function whatwhen () {
    emulate -L zsh
    local usage help ident format_l format_s first_char remain first last
    usage='USAGE: whatwhen [options] <searchstring> <search range>'
    help='Use `whatwhen -h'\'' for further explanations.'
    ident=${(l,${#${:-Usage: }},, ,)}
    format_l="${ident}%s\t\t\t%s\n"
    format_s="${format_l//(\\t)##/\\t}"
    # Make the first char of the word to search for case
    # insensitive; e.g. [aA]
    first_char=[${(L)1[1]}${(U)1[1]}]
    remain=${1[2,-1]}
    # Default search range is `-100'.
    first=${2:-\-100}
    # Optional, just used for `<first> <last>' given.
    last=$3
    case $1 in
        ("")
            printf '%s\n\n' 'ERROR: No search string specified. Aborting.'
            printf '%s\n%s\n\n' ${usage} ${help} && return 1
        ;;
        (-h)
            printf '%s\n\n' ${usage}
            print 'OPTIONS:'
            printf $format_l '-h' 'show help text'
            print '\f'
            print 'SEARCH RANGE:'
            printf $format_l "'0'" 'the whole history,'
            printf $format_l '-<n>' 'offset to the current history number; (default: -100)'
            printf $format_s '<[-]first> [<last>]' 'just searching within a give range'
            printf '\n%s\n' 'EXAMPLES:'
            printf ${format_l/(\\t)/} 'whatwhen grml' '# Range is set to -100 by default.'
            printf $format_l 'whatwhen zsh -250'
            printf $format_l 'whatwhen foo 1 99'
        ;;
        (\?)
            printf '%s\n%s\n\n' ${usage} ${help} && return 1
        ;;
        (*)
            # -l list results on stout rather than invoking $EDITOR.
            # -i Print dates as in YYYY-MM-DD.
            # -m Search for a - quoted - pattern within the history.
            fc -li -m "*${first_char}${remain}*" $first $last
        ;;
    esac
}

# mercurial related stuff
if check_com -c hg ; then
    # gnu like diff for mercurial
    # http://www.selenic.com/mercurial/wiki/index.cgi/TipsAndTricks
    #f5# GNU like diff for mercurial
    function hgdi () {
        emulate -L zsh
        local i
        for i in $(hg status -marn "$@") ; diff -ubwd <(hg cat "$i") "$i"
    }

    # build debian package
    #a2# Alias for \kbd{hg-buildpackage}
    alias hbp='hg-buildpackage'

    # execute commands on the versioned patch-queue from the current repos
    [[ -n "$GRML_NO_SMALL_ALIASES" ]] || alias mq='hg -R $(readlink -f $(hg root)/.hg/patches)'

    # diffstat for specific version of a mercurial repository
    #   hgstat      => display diffstat between last revision and tip
    #   hgstat 1234 => display diffstat between revision 1234 and tip
    #f5# Diffstat for specific version of a mercurial repos
    function hgstat () {
        emulate -L zsh
        [[ -n "$1" ]] && hg diff -r $1 -r tip | diffstat || hg export tip | diffstat
    }

fi # end of check whether we have the 'hg'-executable

# disable bracketed paste mode for dumb terminals
[[ "$TERM" == dumb ]] && unset zle_bracketed_paste

# grml-small cleanups and workarounds

# The following is used to remove zsh-config-items that do not work
# in grml-small by default.
# If you do not want these adjustments (for whatever reason), set
# $GRMLSMALL_SPECIFIC to 0 in your .zshrc.pre file (which this configuration
# sources if it is there).

if (( GRMLSMALL_SPECIFIC > 0 )) && isgrmlsmall ; then

    # Clean up

    unset "abk[V]"
    unalias    'V'      &> /dev/null
    unfunction vman     &> /dev/null
    unfunction viless   &> /dev/null
    unfunction 2html    &> /dev/null

    # manpages are not in grmlsmall
    unfunction manzsh   &> /dev/null
    unfunction man2     &> /dev/null

    # Workarounds

    # See https://github.com/grml/grml/issues/56
    if ! [[ -x ${commands[dig]} ]]; then
        function dig_after_all () {
            unfunction dig
            unfunction _dig
            autoload -Uz _dig
            unfunction dig_after_all
        }
        function dig () {
            if [[ -x ${commands[dig]} ]]; then
                dig_after_all
                command dig "$@"
                return "$!"
            fi
            printf 'This installation does not include `dig'\'' for size reasons.\n'
            printf 'Try `drill'\'' as a light weight alternative.\n'
            return 0
        }
        function _dig () {
            if [[ -x ${commands[dig]} ]]; then
                dig_after_all
                zle -M 'Found `dig'\'' installed. '
            else
                zle -M 'Try `drill'\'' instead of `dig'\''.'
            fi
        }
        compdef _dig dig
    fi
fi

zrclocal

## genrefcard.pl settings

### doc strings for external functions from files
#m# f5 grml-wallpaper() Sets a wallpaper (try completion for possible values)

### example: split functions-search 8,16,24,32
#@# split functions-search 8

## END OF FILE #################################################################
# vim:filetype=zsh foldmethod=marker autoindent expandtab shiftwidth=4
# Local variables:
# mode: sh
# End:

