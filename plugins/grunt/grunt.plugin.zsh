#compdef grunt
#autoload
# -----------------------------------------------------------------------------
#  _grunt
#
#  Completion script for grunt.
#   - https://github.com/gruntjs/grunt
#   - https://github.com/gruntjs/grunt-cli
#
# -----------------------------------------------------------------------------
#
#  Version     : 0.1.2
#  Author      : Yonchu <yuyuchu3333@gmail.com>
#  License     : MIT License
#  Repository  : https://github.com/yonchu/grunt-zsh-completion
#  Last Change : 20 Aug 2014.
#
#  Copyright (c) 2013 Yonchu.
#
# -----------------------------------------------------------------------------
# USAGE
# -----
#
# Enable caching:
#
#   If you want to use the cache, set the followings in your .zshrc:
#
#     zstyle ':completion:*' use-cache yes
#
#
# Settings:
#
#  - Show grunt file path:
#      zstyle ':completion::complete:grunt::options:' show_grunt_path yes
#
#  - Cache expiration days (default: 7):
#      zstyle ':completion::complete:grunt::options:' expire 1
#
#  - Not update options cache if target gruntfile is changed.
#      zstyle ':completion::complete:grunt::options:' no_update_options yes
#
#  Note that if you change the zstyle settings,
#  you should delete the cache file and restart zsh.
#
#    $ rm ~/.zcompcache/grunt
#    $ exec zsh
#
# -----------------------------------------------------------------------------

function __grunt() {
    local curcontext="$curcontext" update_policy state
    local show_grunt_path update_msg gruntfile opts tasks

    # Setup cache-policy.
    zstyle -s ":completion:${curcontext}:" cache-policy update_policy
    if [[ -z $update_policy ]]; then
        zstyle ":completion:${curcontext}:" cache-policy __grunt_caching_policy
    fi

    # Check show_path option.
    zstyle -b ":completion:${curcontext}:options:" show_grunt_path show_grunt_path

    # Get current gruntfile.
    gruntfile=$(__grunt_get_gruntfile)

    # Initialize opts and tasks.
    opts=()
    tasks=()

    # Add help options.
    opts+=('(- 1 *)'{-h,--help}'[Display this help text.]')

    ## Complete without gruntfile.
    if [[ ! -f $gruntfile ]]; then
        _arguments "${opts[@]}"
        return
    fi

    ## Complete with gruntfile.
    # Retrieve cache.
    if ! __grunt_update_cache "$gruntfile"; then
        update_msg=' (cache updated)'
    fi

    # Make options completion.
    if [[ ${#__grunt_opts} -gt 0 ]]; then
        opts+=("${__grunt_opts[@]}")
    fi

    # Complete arguments.
    _arguments \
        "${opts[@]}" \
        '*: :->tasks' \
        && return

    case $state in
        tasks)
            if [[ $show_grunt_path == 'yes' ]]; then
                update_msg="$update_msg: ${${gruntfile/#$HOME/~}%/}"
            fi
            # Make tasks completion.
            if [[ ${#__grunt_tasks} -gt 0 ]]; then
                tasks+=("${__grunt_tasks[@]}")
                _describe -t grunt-task "$verbose grunt task$update_msg" tasks || return 1
            fi
        ;;
    esac

    return 0
}

# Cache policy:
#   The cache file name: grunt
#   The cache variable name: __grunt_version __grunt_gruntfile __grunt_opts __grunt_tasks
function __grunt_update_cache() {
    # TODO
    local version='0.1.2'
    local is_updating=0
    local gruntfile="$1"
    local grunt_info no_update_options cache_path

    # Check no_update_options option.
    zstyle -b ":completion:${curcontext}:options:" no_update_options no_update_options


    if ! ( ((  $+__grunt_gruntfile )) \
        && (( $+__grunt_opts )) \
        && (( $+__grunt_tasks )) ) \
        && ! _retrieve_cache 'grunt'; then
        is_updating=1
    fi

    if [[ $gruntfile != $__grunt_gruntfile ]]; then
        # Except for --help options.
        __grunt_gruntfile=$gruntfile
        if [[ $no_update_options == 'yes' ]]; then
            if [[ $PREFIX == ${PREFIX#-} ]]; then
                # Not options completions.
                is_updating=1
            elif [[ ${#__grunt_opts} -lt 2 ]]; then
                is_updating=1
            else
                unset __grunt_gruntfile
            fi
        else
            is_updating=1
        fi
    else
        if [[ $PREFIX != ${PREFIX#-} && ${#__grunt_opts} -gt 1 ]]; then
            unset __grunt_gruntfile
        fi
    fi

    if _cache_invalid 'grunt'; then
        is_updating=1
    fi

    # Check _grunt version.
    if [[ $__grunt_version != $version ]]; then
        is_updating=1
    fi

    if [[ $is_updating -ne 0 ]]; then
        # Update cache.
        __grunt_version=$version
        __grunt_gruntfile=$gruntfile
        is_updating=1
        grunt_info=$(grunt --help --no-color --gruntfile "$__grunt_gruntfile" 2>/dev/null)
        __grunt_opts=(${(f)"$(__grunt_get_opts "$grunt_info")"})
        __grunt_tasks=(${(f)"$(__grunt_get_tasks "$grunt_info")"})
        _store_cache 'grunt' __grunt_version __grunt_gruntfile __grunt_opts __grunt_tasks
    fi
    return $is_updating
}

function __grunt_get_tasks() {
    echo -E "$1" \
        | grep 'Available tasks' -A 100 \
        | grep '^ ' \
        | sed -e 's/^[[:blank:]]*//' -e 's/[[:blank:]]*$//' \
        | sed -e 's/:/\\:/g' \
        | sed -e 's/  /:/'
}

function __grunt_get_opts() {
    local opt_hunk opt_sep opt_num line opt
    opt_hunk=$(echo -E "$1" \
        | grep 'Options$' -A 100 \
        | sed '1 d' \
        | sed -e 's/[[:blank:]]*$//' \
    )

    opt_sep=()
    opt_hunk=(${(f)opt_hunk})
    opt_num=0
    for line in "$opt_hunk[@]"; do
        opt=$(echo -E "$line" | sed -e 's/^[[:blank:]]*//')
        if [[ $line == $opt ]]; then
            break
        fi
        if [[ $opt != ${opt#-} ]]; then
            # Start with -
            (( opt_num++ ))
            opt=$(echo -E "$opt" | sed 's/^\(\(--[^ ]*\)\(, \(-[^ ]*\)\)*\)  */\2\\t\4\\\t/')
        fi
        opt_sep[$opt_num]=("${opt_sep[$opt_num]}${opt}")
    done

    for line in "$opt_sep[@]"; do
        opt=(${(s:\t:)line})
        if [[ ${opt[1]} == '--help' ]]; then
            continue
        fi
        if [[ ${#opt} -eq 2 ]]; then
            echo -E "(${opt[1]})${opt[1]}[${opt[2]}]"
        else
            echo -E "(${opt[1]},${opt[2]})${opt[1]}[${opt[3]}]"
            echo -E "(${opt[1]},${opt[2]})${opt[2]}[${opt[3]}]"
        fi
    done
}

function __grunt_get_gruntfile() {
    local gruntfile
    local curpath="$PWD"
    while [ "$curpath" ]; do
        for gruntfile in "$curpath/"{G,g}runtfile.{js,coffee}; do
            if [[ -e "$gruntfile" ]]; then
                echo "$gruntfile"
                return
            fi
        done
        curpath=${curpath%/*}
    done
    return 1
}

function __grunt_caching_policy() {
    # Returns status zero if the completions cache needs rebuilding.

    # Rebuild if .agignore more recent than cache.
    if [[ -f $__grunt_gruntfile && $__grunt_gruntfile -nt $1 ]]; then
        # Invalid cache because gruntfile is old.
        return 0
    fi

    local -a oldp
    local expire
    zstyle -s ":completion:${curcontext}:options:" expire expire || expire=7
    # Rebuild if cache is more than $expire days.
    oldp=( "$1"(Nm+$expire) )
    (( $#oldp ))
}

compdef __grunt grunt