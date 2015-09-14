#compdef spring 'spring'
#autoload

_spring() {

        local cword
        let cword=CURRENT-1

        local hints
        hints=()

        local reply
        while read -r line; do
                reply=`echo "$line" | awk '{printf $1 ":"; for (i=2; i<NF; i++) printf $i " "; print $NF}'`
                hints+=("$reply")
        done < <(spring hint ${cword} ${words[*]})

        if ((cword == 1)) {
                _describe -t commands 'commands' hints
                return 0
        }

        _describe -t options 'options' hints
        _files

        return 0
}

_spring "$@"