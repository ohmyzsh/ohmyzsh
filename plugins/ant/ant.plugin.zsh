_ant_does_target_list_need_generating () {
    local build_file=$1
    [ ! -f .ant_targets ] && return 0;
    [ $build_file -nt .ant_targets ] && return 0;
    return 1;
}

_ant () {
    _arguments ':target:->target' '-f[build-file]:filename:->files' 

    case "$state" in
        files)
            compadd -- $(grep -l --color=never "<target" *.xml)
            ;;
        target)
            build_file="build.xml"
            if [[ "$words[2]" == "-f" ]]; then
                build_file="$words[3]"
            fi

            if [ $? -eq 0 -a -f $build_file ]; then
                if _ant_does_target_list_need_generating $build_file; then
                    ant -f $build_file -p | awk -F " " 'NR > 5 { print lastTarget }{lastTarget = $1}' > .ant_targets
                fi
                compadd -- $(cat .ant_targets)
            fi
            ;;
    esac   
}

compdef _ant ant
