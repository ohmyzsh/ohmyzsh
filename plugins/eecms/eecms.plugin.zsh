# ExpressionEngine CMS basic command completion

_eecms_console () {
    echo "php $(find . -maxdepth 3 -mindepth 1 -name 'eecms' -type f | head -n 1)"
}

_eecms_get_command_list () {
    `_eecms_console` | sed "/Available commands/,/^/d" | sed "s/[[:space:]].*//g"
}

_eecms () {
    compadd `_eecms_get_command_list`
}

compdef _eecms '`_eecms_console`'
compdef _eecms 'system/ee/eecms'
compdef _eecms eecms

#Alias
alias eecms='`_eecms_console`'
