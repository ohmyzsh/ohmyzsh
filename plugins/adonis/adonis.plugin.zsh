# Adonis Plugin

# This plugin provide autocompletion for adonis
# Adonis : https://adonisjs.com/

# Author: Dimensi0n | Erwan ROUSSEL

_adonis() {
  compadd `adonis | cut -d " " -f 3 |  sed -E "s/.\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | tail -n+7 | sed '/^\s*$/d'`
}

compdef _adonis adonis