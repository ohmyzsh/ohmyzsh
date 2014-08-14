function cabal_sandbox_info() {
    cabal_files=(*.cabal(N))
    if [ $#cabal_files -gt 0 ]; then
        if [ -f cabal.sandbox.config ]; then
            echo "%{$fg[green]%}[sandboxed] %{$reset_color%}"
        else
            echo "%{$fg[red]%}[not sandboxed] %{$reset_color%}"
        fi
    fi
}

autoload bashcompinit
bashcompinit

# cabal command line completion
# Copyright 2007-2008 "Lennart Kolmodin" <kolmodin@gentoo.org>
#                     "Duncan Coutts"     <dcoutts@gentoo.org>
#

_cabal()
{
    # get the word currently being completed
    local cur
    cur=${COMP_WORDS[$COMP_CWORD]}

    # create a command line to run
    local cmd
    # copy all words the user has entered
    cmd=( ${COMP_WORDS[@]} )

    # replace the current word with --list-options
    cmd[${COMP_CWORD}]="--list-options"

    # the resulting completions should be put into this array
    COMPREPLY=( $( compgen -W "$( ${cmd[@]} )" -- $cur ) )
}

complete -F _cabal -o default cabal
