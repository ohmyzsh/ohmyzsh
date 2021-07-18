
# Cartridge basic commands
_cartridge_get_command_list () {
    cartridge | sed "1,/Available Commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
}

_cartridge () {
   compadd `_cartridge_get_command_list`
}

compdef _cartridge cartridge
