# ------------------------------------------------------------------------------
#          FILE:  pecl.plugin.zsh
#   DESCRIPTION:  oh-my-zsh pecl plugin file.
#        AUTHOR:  Hongbo Tang (thbourlove@gmail.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

_pecl_get_command_list () {
    pecl help | sed '1d;/Usage:/,$d;s/ .*//g'
}

_pecl_get_package_list () {
    pecl list | sed '1,/PACKAGE/d;s/ .*//g'
}

_pecl () {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    _arguments \
        '1: :->command'\
        '2: :->package'\
        '3: :->extra'
    case $state in
        command)
            compadd `_pecl_get_command_list`
            ;;
        package)
            case $words[2] in
                uninstall|upgrade|package-dependencies|info)
                    compadd `_pecl_get_package_list`
                    ;;
            esac
            ;;
    esac
}

compdef _pecl pecl
