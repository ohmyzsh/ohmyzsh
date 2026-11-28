# Shrink directory paths, e.g. /home/me/foo/bar/quux -> ~/f/b/quux.
#
# For a fish-style working directory in your command prompt, add the following
# to your theme or zshrc:
#
#   setopt prompt_subst
#   PS1='%n@%m $(shrink_path -f)>'
#
# The following options are available:
#
#   -f, --fish       fish simulation, equivalent to -l -s -t.
#   -g, --glob       Add asterisk to allow globbing of shrunk path (equivalent to -e "*")
#   -l, --last       Print the last directory's full name.
#   -s, --short      Truncate directory names to the number of characters given by -#. Without
#                    -s, names are truncated without making them ambiguous.
#   -t, --tilde      Substitute ~ for the home directory.
#   -T, --nameddirs  Substitute named directories as well.
#   -#               Truncate each directly to at least this many characters inclusive of the
#                    ellipsis character(s) (defaulting to 1).
#   -e SYMBOL        Postfix symbol(s) to indicate that a directory name had been truncated.
#   -q, --quote      Quote special characters in the shrunk path
#
# The long options can also be set via zstyle, like
#   zstyle :prompt:shrink_path fish yes
#
# Note: Directory names containing two or more consecutive spaces are not yet
# supported.
#
# Keywords: prompt directory truncate shrink collapse fish
#
# Copyright (C) 2008 by Daniel Friesel <derf@xxxxxxxxxxxxxxxxxx>
# License: WTFPL <http://www.wtfpl.net>
#
# Ref: https://www.zsh.org/mla/workers/2009/msg00415.html
#      https://www.zsh.org/mla/workers/2009/msg00419.html

shrink_path () {
        setopt localoptions
        setopt rc_quotes null_glob

        typeset -i lastfull=0
        typeset -i short=0
        typeset -i tilde=0
        typeset -i named=0
        typeset -i length=1
        typeset ellipsis=""
        typeset -i quote=0
        typeset -i expand=0

        if zstyle -t ':prompt:shrink_path' fish; then
                lastfull=1
                short=1
                tilde=1
        fi
        if zstyle -t ':prompt:shrink_path' nameddirs; then
                tilde=1
                named=1
        fi

        local last
        zstyle -s ':prompt:shrink_path' last last
        case "$last" in
          (false|no|off|0) lastfull=0 ;;
          (true|yes|on|1) lastfull=1 ;;
          (""|*[^0-9]*) lastfull=0 ;;
          (*) lastfull=$last ;;
        esac

        zstyle -t ':prompt:shrink_path' short && short=1
        zstyle -t ':prompt:shrink_path' tilde && tilde=1
        zstyle -t ':prompt:shrink_path' glob && ellipsis='*'
        zstyle -t ':prompt:shrink_path' quote && quote=1
        zstyle -t ':prompt:shrink_path' expand && expand=1

        while [[ $1 == -* ]]; do
                case $1 in
                        --)
                                shift
                                break
                        ;;
                        -f|--fish)
                                lastfull=1
                                short=1
                                tilde=1
                        ;;
                        -h|--help)
                                print 'Usage: shrink_path [-f -l -s -t] [directory]'
                                print ' -f, --fish      fish-simulation, like -l -s -t'
                                print ' -g, --glob      Add asterisk to allow globbing of shrunk path (equivalent to -e "*")'
                                print ' -l, --last [#]  Print the last n directory''s full name (default 1).'
                                print ' -s, --short     Truncate directory names to the number of characters given by -#. Without'
                                print '                 -s, names are truncated without making them ambiguous.'
                                print ' -t, --tilde     Substitute ~ for the home directory'
                                print ' -T, --nameddirs Substitute named directories as well'
                                print ' -#              Truncate each directly to at least this many characters inclusive of the'
                                print '                 ellipsis character(s) (defaulting to 1).'
                                print ' -e SYMBOL       Postfix symbol(s) to indicate that a directory name had been truncated.'
                                print ' -q, --quote     Quote special characters in the shrunk path'
                                print ' -x, --expand    Print the full path. This takes precedence over the other options'
                                print ''
                                print 'The long options can also be set via zstyle, like'
                                print '  zstyle :prompt:shrink_path fish yes'
                                return 0
                        ;;
                        -l|--last)
                          lastfull=1
                          if [[ -n "$2" && "$2" != *[^0-9]* ]]; then
                            shift
                            lastfull=$1
                          fi
                        ;;
                        -s|--short) short=1 ;;
                        -t|--tilde) tilde=1 ;;
                        -T|--nameddirs)
                                tilde=1
                                named=1
                        ;;
                        -[0-9]|-[0-9][0-9])
                                length=${1/-/}
                        ;;
                        -e)
                                shift
                                ellipsis="$1"
                        ;;
                        -g|--glob)
                                ellipsis='*'
                        ;;
                        -q|--quote)
                                quote=1
                        ;;
                        -x|--expand)
                                expand=1
                        ;;
                esac
                shift
        done

        typeset -i elllen=${#ellipsis}
        typeset -a tree expn
        typeset result part dir=${1-$PWD}
        typeset -i i

        [[ -d $dir ]] || return 0

        if (( expand )) {
                echo "$dir"
                return 0
        }

        if (( named )) {
                for part in ${(k)nameddirs}; {
                        [[ $dir == ${nameddirs[$part]}(/*|) ]] && dir=${dir/#${nameddirs[$part]}/\~$part}
                }
        }
        (( tilde )) && dir=${dir/#$HOME/\~}
        tree=(${(s:/:)dir})
        (
                if [[ $tree[1] == \~* ]] {
                        cd -q ${~tree[1]}
                        result=$tree[1]
                        shift tree
                } else {
                        cd -q /
                }
                for dir in $tree; {
                        if (( lastfull && $#tree <= lastfull )) {
                                result+="/${(j:/:)tree[@]}"
                                break
                        }
                        expn=(a b)
                        part=''
                        i=0
                        until [[ $i -gt 99 || ( $i -ge $((length - ellen)) || $dir == $part ) && ( (( ${#expn} == 1 )) || $dir = $expn ) ]]; do
                                (( i++ ))
                                part+=$dir[$i]
                                expn=($(echo ${part}*(-/)))
                                (( short )) && [[ $i -ge $((length - ellen)) ]] && break
                        done

                        typeset -i dif=$(( ${#dir} - ${#part} - ellen ))
                        if [[ $dif -gt 0 ]]
                        then
                            (( quote )) && part=${(q)part}
                            part+="$ellipsis"
                        else
                            part="$dir"
                            (( quote )) && part=${(q)part}
                        fi
                        result+="/$part"
                        cd -q $dir
                        shift tree
                }
                echo ${result:-/}
        )
}

## vim:ft=zsh
