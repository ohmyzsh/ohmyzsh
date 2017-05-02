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
#  Version     : 0.2.0
#  Author      : Yonchu <yuyuchu3333@gmail.com>
#  License     : MIT License
#  Repository  : https://github.com/yonchu/grunt-zsh-completion
#  Last Change : 23 Jun 2015.
#
#  Copyright (c) 2015 Yonchu.
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

    # Make optioins completion.
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
    local version='0.2.0'
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
        # Update caceh.
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
    echo -E "$1" | awk \
    'BEGIN {
        TASK = ""
        SUB_NR = 0
    }
    /Available tasks$/, NF == 0 {
        SUB_NR++
        if (SUB_NR == 1 || NF == 0) next
        if ($0 ~ /^[[:blank:]]+[^[:blank:]]+  [^[:blank:]]/) {
            if (TASK != "") {
                print TASK
                TASK = ""
            }
            sub(/^[ \t]+/, "")
            sub(/[ \t]+$/, "")
            gsub(/:/, "\\:")
            sub(/[ ][ ]/, ":")
            TASK = $0
        } else {
            sub(/^[ \t]+/, "")
            sub(/[ \t]+$/, "")
            gsub(/:/, "\\:")
            TASK = TASK " " $0
        }
    }
    END {
        if (TASK != "") {
            print TASK
        }
    }'
}

function __grunt_get_opts() {
    # ex.)
    # before:
    # --xxx, -y  description....
    # after:
    # (--xxx,-y)--xxx[description]"
    # (--xxx,-y)-y[description]"
    echo -E "$1" | awk \
        'BEGIN {
            OPT_COMP_NUM = -1
            SUB_NR = 0
        }
        /Options$/, NF == 0 {
            SUB_NR++
            if (SUB_NR == 1 || NF == 0) next
            sub(/^[ \t]+/, "")
            sub(/[ \t]+$/, "")
            if ($0 ~ /^-.*  [^[:blank:]]/) {
                OPT_COMP_NUM++
                OPT_COMP[OPT_COMP_NUM] = $0
            } else {
                OPT_COMP[OPT_COMP_NUM] = OPT_COMP[OPT_COMP_NUM] " " $0
            }
        }
        END {
            for (i = 0; i <= OPT_COMP_NUM; i++) {
                split(OPT_COMP[i], opt_desc, "  ")
                opt_hunk = opt_desc[1]
                desc = opt_desc[2]
                gsub(/ /, "", opt_hunk)
                if (opt_hunk == "--help,-h") continue
                split(opt_hunk, opts, ",")
                for (opt in opts) {
                    printf "(%s)%s[%s]", opt_hunk, opts[opt], desc
                    print ""
                }
            }
        }'
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

__grunt "$@"
