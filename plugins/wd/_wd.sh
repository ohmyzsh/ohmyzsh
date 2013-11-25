#compdef wd.sh

zstyle ":completion:*:descriptions" format "%B%d%b"

CONFIG=$HOME/.warprc

local -a main_commands
main_commands=(
    add:'Adds the current working directory to your warp points'
    #add'\!':'Overwrites existing warp point' # TODO: Fix
    rm:'Removes the given warp point'
    ls:'Outputs all stored warp points'
    show:'Outputs warp points to current directory'
)

local -a points
while read line
do
    points+=$(awk "{ gsub(/\/Users\/$USER|\/home\/$USER/,\"~\"); print }" <<< $line)
done < $CONFIG

_wd()
{
    # init variables
    local curcontext="$curcontext" state line
    typeset -A opt_args

    # init state
    _arguments \
        '1: :->command' \
        '2: :->argument'

    case $state in
        command)
            compadd "$@" add rm ls show
            _describe -t warp-points 'Warp points:' points && ret=0
            ;;
        argument)
            case $words[2] in
                rm|add!)
                    _describe -t warp-points 'warp points' points && ret=0
                    ;;
                *)
            esac
    esac
}

_wd "$@"
