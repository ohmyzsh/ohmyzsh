# ------------------------------------------------------------------------------
#          FILE:  pear.plugin.zsh
#   DESCRIPTION:  oh-my-zsh pear plugin file.
#        AUTHOR:  Hongbo Tang (thbourlove@gmail.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

_pear_get_command_list () {
    pear help | sed '1d;/Usage:/,$d;s/ .*//g'
}

_pear_get_package_list () {
    pear list | sed '1,/PACKAGE/d;s/ .*//g'
}

_pear () {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    _arguments \
        '1: :->command'\
        '2: :->package'\
        '3: :->extra'
    case $state in
        command)
            compadd `_pear_get_command_list`
            ;;
        package)
            case $words[2] in
                uninstall|upgrade|package-dependencies|info)
                    compadd `_pear_get_package_list`
                    ;;
            esac
            ;;
    esac
}

compdef _pear pear
